#!/usr/bin/env python3
"""
Sprint Slack pipeline bridge — automate #sprint-queue → #review-queue → (optional) next slice / #hitm-gate.

Polls Slack with a bot token (same pattern as scripts/cursor_headless_slack_agent.py). Intended to run
as a long-lived process (systemd, tmux, or Cursor PA host) so HitM does not manually babysit handoffs.

Machine-readable lines (embed in a thread reply under the sprint task, or top-level in #review-queue):

  SPRINT_PIPELINE_JSON: {"status":"READY_FOR_REVIEW",...}
  SPRINT_PIPELINE_JSON: {"status":"REVIEW_VERDICT",...}

Executor / Cursor PA can signal readiness **without** posting in Slack:

- Append one line to the file set by **`SPRINT_PIPELINE_LOCAL_INBOX`** (JSONL). Same schema as
  `READY_FOR_REVIEW` (either raw JSON or `SPRINT_PIPELINE_JSON: {...}`). The bridge drains this
  file on the **same host** and posts to `#review-queue` like a sprint-thread READY.

Optional: use **`scripts/sprint_pipeline_emit_ready.py`** from an agent wrapper after exit 0.

Coordination with Socket Mode runner (`slack_socket_runner.py`)
----------------------------------------------------------------
Canonical companion runner (Socket Mode + outbox drain) lives in **mma_creation**:

  ``~/Documents/mma_creation/local_instance/scripts/slack_socket_runner.py``

When **SPRINT_PIPELINE_BRIDGE_IN_RUNNER** is true and **SPRINT_PIPELINE_LOCAL_INBOX** is set (e.g. in
``local_instance/.secrets/slack.env`` or ``companion_boot.env``), that runner periodically invokes
**this script** with ``--once`` so ``sprint_pipeline_emit_ready.py`` lines are drained without a
separate long-lived ``sprint_slack_pipeline_bridge.py`` process. Optional: **SPRINT_PIPELINE_BRIDGE_SCRIPT**,
**SPRINT_PIPELINE_BRIDGE_CWD**, **SPRINT_PIPELINE_BRIDGE_INTERVAL_SEC** (default 25).

This bridge uses **Slack Web API polling** and an optional **local JSONL inbox**. You may still run
``python3 scripts/sprint_slack_pipeline_bridge.py`` standalone on the same host if you prefer. Align
Slack scopes and channel IDs with ``design_docs/.../12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md`` and
``governance/cursor_pa_slack_visibility.md`` where applicable.

Environment (required)
----------------------
  SLACK_BOT_TOKEN              xoxb-... (channels:history, channels:read, chat:write)
  SPRINT_PIPELINE_SPRINT_CHANNEL   Channel ID or name (e.g. #sprint-queue)
  SPRINT_PIPELINE_REVIEW_CHANNEL   Channel ID or name (e.g. #review-queue)

Environment (optional)
----------------------
  SPRINT_PIPELINE_HITM_CHANNEL     #hitm-gate — when verdict requires HitM
  SPRINT_PIPELINE_POLL_SEC         Poll interval (default: 25)
  SPRINT_PIPELINE_STATE_FILE       JSON state path (default: <cwd>/.sprint_pipeline_bridge_state.json)
  SPRINT_PIPELINE_LOCAL_INBOX      If set (tilde-expanded path to a JSONL file), each poll reads new
                                   lines with READY_FOR_REVIEW — no Slack sprint-thread reply needed.
  SPRINT_BRIDGE_AUTO_PASS_IF_NON_HITM  Default false: if true, after READY and requires_hitm=false, post
                                   synthetic PASS and continue chain (no human/reviewer verdict needed).
  SPRINT_BRIDGE_AUTO_PASS_V0       Default false: when AUTO_PASS_IF_NON_HITM is false, optionally auto-PASS
                                   when verify_tiers is exactly "V0".
  SPRINT_BRIDGE_REVIEW_AGENT_ENABLED  If true and auto-pass is off: run cursor-agent to produce REVIEW_VERDICT.
  SPRINT_BRIDGE_REVIEW_WORKSPACE      Workspace path for reviewer agent run.
  SPRINT_BRIDGE_REVIEW_TIMEOUT_SEC    Reviewer agent timeout seconds (default: 420).
  SPRINT_BRIDGE_REVIEW_MODEL          Optional cursor-agent model slug for reviewer runs.
  SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR  Required if READY / VERDICT JSON uses next_queue_message_path;
                                   must be an absolute or tilde path; file paths must resolve under it.

Safety
------
  next_queue_message_path in JSON is tilde-expanded and must be under SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR
  when that env is set; otherwise path-based next posts are skipped.

Usage
-----
  export SLACK_BOT_TOKEN=xoxb-...
  export SPRINT_PIPELINE_SPRINT_CHANNEL='#sprint-queue'
  export SPRINT_PIPELINE_REVIEW_CHANNEL='#review-queue'
  export SPRINT_PIPELINE_HITM_CHANNEL='#hitm-gate'
  export SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR="$HOME/Documents/python/finance_manager/plans/pipeline_queue"
  python3 scripts/sprint_slack_pipeline_bridge.py

  python3 scripts/sprint_slack_pipeline_bridge.py --dry-run --once   # log actions only, single iteration
"""

from __future__ import annotations

import argparse
import hashlib
import json
import logging
import os
import re
import shutil
import subprocess
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path
from typing import Any, Optional

LOG = logging.getLogger("sprint_pipeline_bridge")


def _ts_format(v: float) -> str:
    return f"{float(v):.6f}"


def _ts_parse(raw: Any, default: float) -> float:
    try:
        return float(str(raw))
    except (TypeError, ValueError):
        return default


def _env_bool(name: str, default: bool = False) -> bool:
    v = os.environ.get(name)
    if v is None:
        return default
    return v.strip().lower() in ("1", "true", "yes", "on")


def _slack_api(token: str, method: str, payload: dict[str, Any]) -> dict[str, Any]:
    url = f"https://slack.com/api/{method}"
    # Slack Web API methods are reliably accepted as form-encoded payloads.
    # Some methods (notably conversations.replies) can reject JSON bodies as
    # missing required args even when fields are present.
    form_payload = {k: v for k, v in payload.items() if v is not None}
    data = urllib.parse.urlencode(form_payload).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=data,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=90) as resp:
            body = resp.read().decode("utf-8")
    except urllib.error.HTTPError as e:
        err = e.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"Slack HTTP {e.code}: {err}") from e
    except OSError as e:
        raise RuntimeError(f"Slack request failed: {e}") from e
    out = json.loads(body)
    if not out.get("ok"):
        raise RuntimeError(f"Slack API {method} error: {out!r}")
    return out


def resolve_channel_id(token: str, raw: str) -> str:
    raw = raw.strip()
    if re.match(r"^C[0-9A-Z]+$", raw):
        return raw
    name = raw.lstrip("#").strip()
    if not name:
        sys.exit("Invalid channel")
    cursor: Optional[str] = None
    while True:
        payload: dict[str, Any] = {"types": "public_channel,private_channel", "limit": 200}
        if cursor:
            payload["cursor"] = cursor
        data = _slack_api(token, "conversations.list", payload)
        for ch in data.get("channels", []):
            if ch.get("name") == name:
                return str(ch["id"])
        cursor = data.get("response_metadata", {}).get("next_cursor") or None
        if not cursor:
            break
    sys.exit(f"Channel {raw!r} not found. Invite the bot or pass channel ID (C...).")


def extract_pipeline_jsons(text: str) -> list[dict[str, Any]]:
    """One JSON object per line: SPRINT_PIPELINE_JSON: {...}"""
    if not text:
        return []
    out: list[dict[str, Any]] = []
    for line in text.splitlines():
        s = line.strip()
        if not s.startswith("SPRINT_PIPELINE_JSON:"):
            continue
        raw = s[len("SPRINT_PIPELINE_JSON:") :].strip()
        try:
            obj = json.loads(raw)
        except json.JSONDecodeError as e:
            LOG.warning("Bad SPRINT_PIPELINE_JSON: %s", e)
            continue
        if isinstance(obj, dict):
            out.append(obj)
    return out


def parse_local_inbox_line(line: str) -> list[dict[str, Any]]:
    """Accept either Slack-style prefix or one raw JSON object per line (executor emit)."""
    s = line.strip()
    if not s:
        return []
    if s.startswith("SPRINT_PIPELINE_JSON:"):
        return extract_pipeline_jsons(s)
    if s.startswith("{"):
        try:
            obj = json.loads(s)
        except json.JSONDecodeError as e:
            LOG.warning("Bad JSON in local inbox line: %s", e)
            return []
        if isinstance(obj, dict):
            return [obj]
    return []


def _truthy(val: Any) -> bool:
    if isinstance(val, bool):
        return val
    s = str(val).strip().lower()
    return s in ("1", "true", "yes", "on")


def _safe_next_path(raw: str, basedir: Optional[Path]) -> Optional[Path]:
    if not raw or not raw.strip():
        return None
    if basedir is None:
        LOG.warning("next_queue_message_path set but SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR unset; skip")
        return None
    base = basedir.expanduser().resolve()
    p = Path(raw.strip())
    path = (base / p).resolve() if not p.is_absolute() else p.expanduser().resolve()
    try:
        path.relative_to(base)
    except ValueError:
        LOG.error("next_queue_message_path %s escapes basedir %s", path, base)
        return None
    return path


class PipelineBridge:
    def __init__(
        self,
        *,
        token: str,
        sprint_ch: str,
        review_ch: str,
        hitm_ch: Optional[str],
        state_path: Path,
        poll_sec: float,
        auto_pass_v0: bool,
        auto_pass_if_non_hitm: bool,
        review_agent_enabled: bool,
        review_workspace: Optional[Path],
        review_timeout_sec: int,
        review_model: Optional[str],
        local_inbox: Optional[Path],
        next_base: Optional[Path],
        dry_run: bool,
    ) -> None:
        self.token = token
        self.sprint_id = resolve_channel_id(token, sprint_ch)
        self.review_id = resolve_channel_id(token, review_ch)
        self.hitm_id = resolve_channel_id(token, hitm_ch) if hitm_ch else None
        self.state_path = state_path
        self.poll_sec = poll_sec
        self.auto_pass_v0 = auto_pass_v0
        self.auto_pass_if_non_hitm = auto_pass_if_non_hitm
        self.review_agent_enabled = review_agent_enabled
        self.review_workspace = review_workspace.expanduser().resolve() if review_workspace else None
        self.review_timeout_sec = max(60, min(int(review_timeout_sec), 1800))
        self.review_model = review_model.strip() if review_model else None
        self.local_inbox = local_inbox.expanduser().resolve() if local_inbox else None
        self.next_base = next_base.resolve() if next_base else None
        self.dry_run = dry_run
        self.state: dict[str, Any] = {}
        self._load_state()

    def _load_state(self) -> None:
        if self.state_path.is_file():
            try:
                self.state = json.loads(self.state_path.read_text(encoding="utf-8"))
            except (OSError, json.JSONDecodeError) as e:
                LOG.warning("Resetting state: %s", e)
                self.state = {}
        if "waterline_sprint_reply_ts" not in self.state:
            self.state["waterline_sprint_reply_ts"] = _ts_format(time.time())
        if "waterline_review_ts" not in self.state:
            self.state["waterline_review_ts"] = _ts_format(time.time())
        self.state["waterline_sprint_reply_ts"] = _ts_format(
            _ts_parse(self.state.get("waterline_sprint_reply_ts"), time.time())
        )
        self.state["waterline_review_ts"] = _ts_format(
            _ts_parse(self.state.get("waterline_review_ts"), time.time())
        )
        if "done_keys" not in self.state:
            self.state["done_keys"] = []
        if "verdict_done_keys" not in self.state:
            self.state["verdict_done_keys"] = []
        if "local_inbox_done_keys" not in self.state:
            self.state["local_inbox_done_keys"] = []
        if "next_posted_keys" not in self.state:
            self.state["next_posted_keys"] = []
        if "hitm_posted_keys" not in self.state:
            self.state["hitm_posted_keys"] = []

    def _should_auto_pass(self, ready: dict[str, Any]) -> bool:
        if _truthy(ready.get("requires_hitm")):
            return False
        if self.auto_pass_if_non_hitm:
            return True
        tiers = str(ready.get("verify_tiers", "")).strip().upper()
        return bool(self.auto_pass_v0 and tiers == "V0")

    @staticmethod
    def _verdict_dedupe_key(verdict: dict[str, Any]) -> str:
        return hashlib.sha256(
            json.dumps(verdict, sort_keys=True, separators=(",", ":")).encode()
        ).hexdigest()[:48]

    @staticmethod
    def _transition_key(verdict: dict[str, Any]) -> str:
        """Stable idempotency key for PASS transition side-effects."""
        slice_id = str(verdict.get("slice_id", "")).strip()
        requires_hitm = _truthy(verdict.get("requires_hitm"))
        next_path = str(verdict.get("next_queue_message_path", "")).strip()
        return hashlib.sha256(
            f"{slice_id}|pass|hitm={int(requires_hitm)}|next={next_path}".encode()
        ).hexdigest()[:48]

    def _save_state(self) -> None:
        self.state_path.parent.mkdir(parents=True, exist_ok=True)
        tmp = self.state_path.with_suffix(".tmp")
        tmp.write_text(json.dumps(self.state, indent=2), encoding="utf-8")
        tmp.replace(self.state_path)

    def _dedupe_add(self, bucket: str, key: str) -> bool:
        lst = self.state.setdefault(bucket, [])
        if key in lst:
            return False
        lst.append(key)
        lst[:] = lst[-500:]
        return True

    @staticmethod
    def _msg_text(msg: dict[str, Any]) -> str:
        return str(msg.get("text", "") or "")

    @staticmethod
    def _extract_json_line(text: str, prefix: str) -> Optional[dict[str, Any]]:
        for line in text.splitlines():
            s = line.strip()
            if not s.startswith(prefix):
                continue
            raw = s[len(prefix) :].strip()
            try:
                obj = json.loads(raw)
            except json.JSONDecodeError:
                continue
            if isinstance(obj, dict):
                return obj
        return None

    def _run_reviewer_agent(self, ready: dict[str, Any]) -> Optional[dict[str, Any]]:
        if not self.review_agent_enabled:
            return None
        if _truthy(ready.get("requires_hitm", False)):
            return None
        if not self.review_workspace:
            LOG.warning("Review agent enabled but SPRINT_BRIDGE_REVIEW_WORKSPACE unset")
            return None
        exe = shutil.which("cursor-agent")
        if not exe:
            LOG.warning("Review agent enabled but cursor-agent not found on PATH")
            return None
        if not os.environ.get("CURSOR_API_KEY"):
            LOG.warning("Review agent enabled but CURSOR_API_KEY is unset")
            return None

        slice_id = str(ready.get("slice_id", "")).strip()
        next_path = str(ready.get("next_queue_message_path", "")).strip()
        prompt = (
            "You are a strict review agent for sprint handoff automation.\n"
            "Review this READY_FOR_REVIEW payload and run lightweight repo checks as needed.\n"
            "If acceptable, output EXACTLY one line prefixed with 'SPRINT_PIPELINE_JSON: ' containing\n"
            "a JSON object with status=REVIEW_VERDICT, verdict=PASS, reviewer=review-agent, requires_hitm,\n"
            "v2_evidence, and next_queue_message_path.\n"
            "If not acceptable, output the same schema with verdict=FAIL and explain in v2_evidence.\n"
            "Important: if next_queue_message_path is set and missing under SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR,\n"
            "create the file first (using existing queue-file style) before returning PASS.\n"
            "READY payload JSON:\n"
            + json.dumps(ready, ensure_ascii=True)
        )
        cmd: list[str] = [
            exe,
            "--workspace",
            str(self.review_workspace),
            "--print",
            "--output-format",
            "text",
            "--trust",
            "--force",
            "--approve-mcps",
            "--sandbox",
            "disabled",
        ]
        if self.review_model:
            cmd.extend(["--model", self.review_model])
        cmd.append(prompt)
        try:
            proc = subprocess.run(
                cmd,
                cwd=str(self.review_workspace),
                capture_output=True,
                text=True,
                timeout=self.review_timeout_sec,
            )
        except subprocess.TimeoutExpired:
            LOG.warning("Review agent timeout slice=%s timeout=%ss", slice_id, self.review_timeout_sec)
            return None
        except OSError as e:
            LOG.warning("Review agent execution failed: %s", e)
            return None
        out = (proc.stdout or "").strip()
        err = (proc.stderr or "").strip()
        if proc.returncode != 0:
            LOG.warning("Review agent exit=%s slice=%s stderr=%s", proc.returncode, slice_id, err[:300])
            return None
        verdict = self._extract_json_line(out, "SPRINT_PIPELINE_JSON:")
        if not verdict:
            LOG.warning("Review agent produced no REVIEW_VERDICT JSON slice=%s", slice_id)
            return None
        if str(verdict.get("status", "")) != "REVIEW_VERDICT":
            LOG.warning("Review agent verdict missing status=REVIEW_VERDICT slice=%s", slice_id)
            return None
        if not str(verdict.get("slice_id", "")).strip():
            verdict["slice_id"] = slice_id
        if next_path and not str(verdict.get("next_queue_message_path", "")).strip():
            verdict["next_queue_message_path"] = next_path
        return verdict

    def post_message(self, channel_id: str, text: str) -> Optional[str]:
        if self.dry_run:
            LOG.info("[dry-run] post to %s: %s", channel_id, text[:500])
            return "dry-run"
        data = _slack_api(
            self.token,
            "chat.postMessage",
            {"channel": channel_id, "text": text},
        )
        return str(data.get("ts", ""))

    def scan_sprint_threads(self) -> None:
        wl = _ts_parse(self.state.get("waterline_sprint_reply_ts"), time.time())
        data = _slack_api(
            self.token,
            "conversations.history",
            {"channel": self.sprint_id, "limit": 75},
        )
        parents = [m for m in data.get("messages", []) if int(m.get("reply_count", 0) or 0) > 0]
        max_seen = wl
        for parent in parents:
            thread_ts = str(parent.get("thread_ts", parent.get("ts", "")))
            if not thread_ts:
                continue
            page: Optional[str] = None
            while True:
                payload: dict[str, Any] = {
                    "channel": self.sprint_id,
                    "ts": thread_ts,
                    "limit": 200,
                }
                if page:
                    payload["cursor"] = page
                rep = _slack_api(self.token, "conversations.replies", payload)
                for msg in rep.get("messages", []):
                    ts = str(msg.get("ts", "0"))
                    if ts == thread_ts:
                        continue
                    tsn = float(ts)
                    if tsn <= wl:
                        continue
                    max_seen = max(max_seen, tsn)
                    text = self._msg_text(msg)
                    for obj in extract_pipeline_jsons(text):
                        if obj.get("status") != "READY_FOR_REVIEW":
                            continue
                        slice_id = str(obj.get("slice_id", "")).strip()
                        if not slice_id:
                            continue
                        key = hashlib.sha256(
                            f"{thread_ts}|{ts}|{slice_id}".encode()
                        ).hexdigest()[:32]
                        if not self._dedupe_add("done_keys", key):
                            continue
                        self._handle_ready(thread_ts, ts, obj)
                page = (rep.get("response_metadata") or {}).get("next_cursor") or None
                if not page:
                    break
        self.state["waterline_sprint_reply_ts"] = _ts_format(max(max_seen, wl))

    def scan_local_inbox(self) -> None:
        if not self.local_inbox:
            return
        p = self.local_inbox
        if not p.is_file():
            return
        try:
            raw = p.read_text(encoding="utf-8")
        except OSError as e:
            LOG.warning("Local inbox read failed %s: %s", p, e)
            return
        for line in raw.splitlines():
            s = line.strip()
            if not s:
                continue
            for obj in parse_local_inbox_line(s):
                if str(obj.get("status", "")) != "READY_FOR_REVIEW":
                    continue
                slice_id = str(obj.get("slice_id", "")).strip()
                if not slice_id:
                    continue
                key = hashlib.sha256(
                    json.dumps(obj, sort_keys=True, separators=(",", ":")).encode()
                ).hexdigest()[:32]
                if not self._dedupe_add("local_inbox_done_keys", key):
                    continue
                self._handle_ready("local-inbox", key, obj, source="local_inbox")

    def _handle_ready(
        self,
        parent_ts: str,
        reply_ts: str,
        ready: dict[str, Any],
        *,
        source: str = "slack_thread",
    ) -> None:
        slice_id = str(ready.get("slice_id", ""))
        plan_root = str(ready.get("plan_root", ""))
        plan_id = str(ready.get("plan_id", ""))
        repo = str(ready.get("repo", ""))
        branch = str(ready.get("branch", ""))
        commit = str(ready.get("commit", "none"))
        v1 = str(ready.get("v1_evidence", ""))
        tiers = str(ready.get("verify_tiers", "")).strip()

        if source == "local_inbox":
            thread_info = (
                f"*Source:* local machine (`SPRINT_PIPELINE_LOCAL_INBOX`) "
                f"(ref `{reply_ts}`; no `#sprint-queue` thread correlation)."
            )
        else:
            thread_info = (
                f"Sprint thread: parent_ts `{parent_ts}` completion reply `{reply_ts}`"
            )

        body = (
            f"*Automated review request*\n"
            f"{thread_info}\n"
            f"*SLICE_ID:* `{slice_id}`\n"
            f"*PLAN_ROOT:* `{plan_root}`\n"
            f"*PLAN_ID:* `{plan_id}`\n"
            f"*REPO:* `{repo}`\n"
            f"*BRANCH:* `{branch}`\n"
            f"*COMMIT:* `{commit}`\n"
            f"*V1_EVIDENCE:*\n{v1}\n"
            f"*VERIFY_TIERS:* `{tiers}`\n\n"
            f"Post a verdict reply containing a line:\n"
            f'`SPRINT_PIPELINE_JSON: {{"status":"REVIEW_VERDICT","slice_id":"{slice_id}","verdict":"PASS|FAIL","reviewer":"<id>","requires_hitm":true|false,"v2_evidence":"...","next_queue_message_path":"optional/under/basedir.txt"}}`'
        )
        LOG.info("Forwarding READY_FOR_REVIEW slice=%s to review channel", slice_id)
        self.post_message(self.review_id, body)

        if self._should_auto_pass(ready):
            raw_next = str(ready.get("next_queue_message_path", "") or "").strip()
            if raw_next and not _truthy(ready.get("requires_hitm", False)):
                next_path = _safe_next_path(raw_next, self.next_base)
                if not next_path or not next_path.is_file():
                    missing_note = (
                        "*Auto-pass held — missing next queue file*\n"
                        f"*SLICE_ID:* `{slice_id}`\n"
                        f"*Expected path:* `{raw_next}` under `SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR`\n"
                        "Create the next task file first, then post `REVIEW_VERDICT` PASS with the same "
                        "`next_queue_message_path`."
                    )
                    LOG.warning(
                        "Auto PASS held for slice %s: next queue file missing (%s)",
                        slice_id,
                        next_path,
                    )
                    self.post_message(self.review_id, missing_note)
                    return
            v2 = (
                "auto-pass non-HitM slice (SPRINT_BRIDGE_AUTO_PASS_IF_NON_HITM)"
                if self.auto_pass_if_non_hitm
                else "auto-pass V0 slice (SPRINT_BRIDGE_AUTO_PASS_V0)"
            )
            verdict = {
                "status": "REVIEW_VERDICT",
                "slice_id": slice_id,
                "verdict": "PASS",
                "reviewer": "sprint_slack_pipeline_bridge",
                "requires_hitm": _truthy(ready.get("requires_hitm", False)),
                "v2_evidence": v2,
                "next_queue_message_path": ready.get("next_queue_message_path", ""),
            }
            line = f"SPRINT_PIPELINE_JSON: {json.dumps(verdict, separators=(',', ':'))}"
            LOG.info("Auto PASS slice %s (tiers=%s)", slice_id, tiers or "?")
            self.post_message(self.review_id, line)
            self._process_verdict(verdict)
            return

        verdict = self._run_reviewer_agent(ready)
        if verdict:
            line = f"SPRINT_PIPELINE_JSON: {json.dumps(verdict, separators=(',', ':'))}"
            LOG.info("Review agent verdict slice=%s verdict=%s", slice_id, verdict.get("verdict"))
            self.post_message(self.review_id, line)
            self._process_verdict(verdict)

    def scan_review_channel(self) -> None:
        wl = _ts_parse(self.state.get("waterline_review_ts"), time.time())
        all_msgs: list[dict[str, Any]] = []
        page: Optional[str] = None
        while True:
            payload: dict[str, Any] = {"channel": self.review_id, "limit": 200}
            if wl > 0:
                payload["oldest"] = _ts_format(wl)
            if page:
                payload["cursor"] = page
            data = _slack_api(self.token, "conversations.history", payload)
            all_msgs.extend(data.get("messages", []))
            page = (data.get("response_metadata") or {}).get("next_cursor") or None
            if not page:
                break
        max_ts = wl
        for msg in sorted(all_msgs, key=lambda m: float(str(m.get("ts", "0")))):
            ts = float(str(msg.get("ts", "0")))
            if ts <= wl:
                continue
            max_ts = max(max_ts, ts)
            text = self._msg_text(msg)
            for obj in extract_pipeline_jsons(text):
                if obj.get("status") != "REVIEW_VERDICT":
                    continue
                self._process_verdict(obj)
        self.state["waterline_review_ts"] = _ts_format(max(max_ts, wl))

    def _process_verdict(self, verdict: dict[str, Any]) -> None:
        if str(verdict.get("status", "")) != "REVIEW_VERDICT":
            return
        vk = self._verdict_dedupe_key(verdict)
        vlist = self.state.setdefault("verdict_done_keys", [])
        if vk in vlist:
            return
        vlist.append(vk)
        vlist[:] = vlist[-500:]

        vd = str(verdict.get("verdict", "")).upper()
        if vd != "PASS":
            LOG.info("Verdict %s — no downstream automation for slice %s", vd, verdict.get("slice_id"))
            return
        transition_key = self._transition_key(verdict)
        if _truthy(verdict.get("requires_hitm")):
            if not self._dedupe_add("hitm_posted_keys", transition_key):
                LOG.info(
                    "Duplicate PASS transition for slice %s (hitm route) — skip",
                    verdict.get("slice_id"),
                )
                return
            if not self.hitm_id:
                LOG.warning("requires_hitm but SPRINT_PIPELINE_HITM_CHANNEL unset")
                return
            slice_id = verdict.get("slice_id", "")
            hitm_text = (
                f"*HitM gate — slice ready for human verify*\n"
                f"*SLICE_ID:* `{slice_id}`\n"
                f"*V2 / evidence:* {verdict.get('v2_evidence', '')}\n"
                f"SPRINT_PIPELINE_JSON:{json.dumps({'status': 'HITM_REQUEST', 'slice_id': slice_id, 'verdict': 'PASS_PENDING_HITM'}, separators=(',', ':'))}"
            )
            self.post_message(self.hitm_id, hitm_text)
            return

        raw_next = str(verdict.get("next_queue_message_path", "") or "").strip()
        if not raw_next:
            LOG.info("PASS with no next_queue_message_path; stop chain here.")
            return
        if not self._dedupe_add("next_posted_keys", transition_key):
            LOG.info(
                "Duplicate PASS transition for slice %s (next route) — skip",
                verdict.get("slice_id"),
            )
            return
        path = _safe_next_path(raw_next, self.next_base)
        if not path or not path.is_file():
            LOG.warning("next message file missing: %s", path)
            return
        try:
            nxt = path.read_text(encoding="utf-8").strip()
        except OSError as e:
            LOG.error("Read next queue file: %s", e)
            return
        if not nxt:
            LOG.warning("Empty next queue file: %s", path)
            return
        LOG.info("Posting next #sprint-queue message from %s", path)
        self.post_message(self.sprint_id, nxt)

    def run_once(self) -> None:
        self.scan_local_inbox()
        self.scan_sprint_threads()
        self.scan_review_channel()
        self._save_state()

    def run_forever(self) -> None:
        while True:
            try:
                self.run_once()
            except Exception as e:
                LOG.exception("poll error: %s", e)
            time.sleep(self.poll_sec)


def main() -> None:
    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s %(levelname)s %(message)s",
    )
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--dry-run", action="store_true", help="Log actions, do not post to Slack")
    ap.add_argument("--once", action="store_true", help="Single poll cycle then exit")
    args = ap.parse_args()

    token = os.environ.get("SLACK_BOT_TOKEN", "").strip()
    if not token:
        sys.exit("SLACK_BOT_TOKEN is required")
    sprint_ch = os.environ.get("SPRINT_PIPELINE_SPRINT_CHANNEL", "").strip()
    review_ch = os.environ.get("SPRINT_PIPELINE_REVIEW_CHANNEL", "").strip()
    if not sprint_ch or not review_ch:
        sys.exit("SPRINT_PIPELINE_SPRINT_CHANNEL and SPRINT_PIPELINE_REVIEW_CHANNEL are required")
    hitm = os.environ.get("SPRINT_PIPELINE_HITM_CHANNEL", "").strip() or None
    poll = float(os.environ.get("SPRINT_PIPELINE_POLL_SEC", "25"))
    raw_state = os.environ.get("SPRINT_PIPELINE_STATE_FILE", "").strip()
    state_path = (
        Path(raw_state).expanduser()
        if raw_state
        else Path.cwd() / ".sprint_pipeline_bridge_state.json"
    )
    auto_v0 = _env_bool("SPRINT_BRIDGE_AUTO_PASS_V0", default=False)
    auto_non = _env_bool("SPRINT_BRIDGE_AUTO_PASS_IF_NON_HITM", default=False)
    review_agent_enabled = _env_bool("SPRINT_BRIDGE_REVIEW_AGENT_ENABLED", default=False)
    raw_review_ws = os.environ.get("SPRINT_BRIDGE_REVIEW_WORKSPACE", "").strip()
    review_ws = Path(raw_review_ws).expanduser() if raw_review_ws else None
    try:
        review_timeout = int(str(os.environ.get("SPRINT_BRIDGE_REVIEW_TIMEOUT_SEC", "420")).strip() or "420")
    except ValueError:
        review_timeout = 420
    review_model = os.environ.get("SPRINT_BRIDGE_REVIEW_MODEL", "").strip() or None
    raw_inbox = os.environ.get("SPRINT_PIPELINE_LOCAL_INBOX", "").strip()
    local_inbox = Path(raw_inbox).expanduser() if raw_inbox else None
    raw_base = os.environ.get("SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR", "").strip()
    next_base = Path(raw_base).expanduser() if raw_base else None

    bridge = PipelineBridge(
        token=token,
        sprint_ch=sprint_ch,
        review_ch=review_ch,
        hitm_ch=hitm,
        state_path=state_path,
        poll_sec=poll,
        auto_pass_v0=auto_v0,
        auto_pass_if_non_hitm=auto_non,
        review_agent_enabled=review_agent_enabled,
        review_workspace=review_ws,
        review_timeout_sec=review_timeout,
        review_model=review_model,
        local_inbox=local_inbox,
        next_base=next_base,
        dry_run=args.dry_run,
    )
    if args.once:
        bridge.run_once()
        return
    bridge.run_forever()


if __name__ == "__main__":
    main()
