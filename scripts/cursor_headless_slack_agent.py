#!/usr/bin/env python3
"""
Run the Cursor CLI agent in headless (print) mode and watch Slack channels for:
1) task intake (e.g. #cli-interface), and
2) PR lifecycle updates (e.g. #pull-requests).

This script does *not* embed the Cursor Slack MCP: that runs inside the IDE/CLI
agent context. Here we use the Slack Web API with a bot token so a long-lived
process can poll the channel, forward prompts to `cursor agent -p`, and post
replies in thread.

Environment (core)
-----------------
  CURSOR_API_KEY          API key for Cursor (also accepted by the agent binary).
  SLACK_BOT_TOKEN         xoxb-... bot token (see scopes below).
  SLACK_TASK_CHANNEL      Channel ID (C...) or name (e.g. #cli-interface).
                          Backward compatible alias: SLACK_CHANNEL.
  SLACK_PR_CHANNEL        PR status channel ID/name (default: #pull-requests).

Environment (optional)
----------------------
  CURSOR_AGENT_WORKSPACE  Repo root passed to `--workspace` (default: cwd). Also
                            used as the default for --workspace CLI if unset.
  CURSOR_AGENT_BIN        Full path to `agent`/`cursor-agent` if not on PATH.
  CURSOR_AGENT_FORCE      If "1"/"true"/"yes", add `--force` (allows edits/shell).
  CURSOR_AGENT_EXTRA_ARGS JSON list of extra argv tokens for the agent, e.g.
                            ["--approve-mcps","--model","composer-2-fast"].
  CURSOR_SLACK_POLL_SEC   Poll interval seconds (default: 15).
  CURSOR_SLACK_STATE_FILE Path to JSON state (default: workspace/.cursor_slack_agent_state.json).
                            On first run (no file / last_ts=0), the script seeds the
                            cursor from the latest message so backlog is not replayed.
  CURSOR_PR_LOG_FILE      JSONL log for tracked PR events (default:
                            workspace/.cursor_pr_status_log.jsonl).
  CURSOR_SLACK_TASK_MODE  mention | prefix | both (default: both).
  CURSOR_SLACK_PREFIX     Text prefix that marks a task when mode uses prefix (default: "!cursor").
  CURSOR_SLACK_TOP_LEVEL  If "1", ignore thread replies for new tasks (default: 1).
  CURSOR_AGENT_TIMEOUT_SEC Subprocess timeout in seconds (default: 3600; 0 = none).
  CURSOR_SLACK_MAX_MESSAGE_CHARS  Max chars per Slack thread reply (default: 2400).
                            Long agent output is split into multiple thread messages.
  CURSOR_SLACK_THREAD_TASKS  If "1"/"true", process !cursor/mention tasks in thread
                            replies (default: off; only top-level messages are tasks).
  CURSOR_SLACK_THREAD_SCAN_LIMIT  Number of parent threads to inspect for new
                            replies each poll (default: 50; max: 200).

Slack app scopes (bot token)
----------------------------
  channels:history channels:read chat:write
  Optional: users:read (for nicer logging)

Invite the bot to the channel before running.

Usage
-----
  export CURSOR_API_KEY=...
  export SLACK_BOT_TOKEN=xoxb-...
  export SLACK_TASK_CHANNEL='#cli-interface'
  export SLACK_PR_CHANNEL='#pull-requests'
  cd /path/to/repo
  python3 scripts/cursor_headless_slack_agent.py

Or: python3 scripts/cursor_headless_slack_agent.py --workspace /path/to/repo
"""

from __future__ import annotations

import argparse
import json
import logging
import os
import subprocess
import re
import shutil
import signal
import sys
import time
import urllib.error
import urllib.request
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Optional

LOG = logging.getLogger("cursor_slack_agent")


def _env_bool(name: str, default: bool = False) -> bool:
    v = os.environ.get(name)
    if v is None:
        return default
    return v.strip().lower() in ("1", "true", "yes", "on")


def _slack_max_message_chars() -> int:
    raw = os.environ.get("CURSOR_SLACK_MAX_MESSAGE_CHARS", "2400").strip()
    try:
        n = int(raw)
        return max(500, min(n, 3500))
    except ValueError:
        return 2400


def _chunk_text(label: str, body: str, max_len: int) -> list[str]:
    """Split body into Slack-sized parts with chunk n/total headers when needed."""
    if not body:
        return []
    total = (len(body) + max_len - 1) // max_len
    out: list[str] = []
    label_line = f"*{label}*\n" if label else ""
    for i in range(total):
        part = body[i * max_len : (i + 1) * max_len]
        chunk_hdr = f"*chunk {i + 1}/{total}*\n" if total > 1 else ""
        out.append(f"{label_line}{chunk_hdr}{part}")
    return out


def _thread_scan_limit() -> int:
    raw = os.environ.get("CURSOR_SLACK_THREAD_SCAN_LIMIT", "50").strip()
    try:
        n = int(raw)
        return max(1, min(n, 200))
    except ValueError:
        return 50


def _slack_api(token: str, method: str, payload: dict[str, Any]) -> dict[str, Any]:
    url = f"https://slack.com/api/{method}"
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=data,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json; charset=utf-8",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=60) as resp:
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


def slack_plain_text(text: str) -> str:
    """Best-effort strip of Slack mrkdwn mention/link noise for the agent prompt."""
    if not text:
        return ""
    # <@U123> -> empty, <#C123|name> -> #name, <url|label> -> label/url
    t = re.sub(r"<@[^>]+>", " ", text)
    t = re.sub(r"<#([^|>]+)\|([^>]+)>", r"#\2", t)
    t = re.sub(r"<#([^>]+)>", r"#channel", t)
    t = re.sub(r"<(https?://[^|>]+)\|([^>]+)>", r"\2 \1", t)
    t = re.sub(r"<(https?://[^>]+)>", r"\1", t)
    return " ".join(t.split()).strip()


@dataclass
class AgentResult:
    returncode: int
    stdout: str
    stderr: str


def resolve_agent_prefix() -> list[str]:
    override = os.environ.get("CURSOR_AGENT_BIN")
    if override:
        return [override]
    for name in ("agent", "cursor-agent"):
        p = shutil.which(name)
        if p:
            return [p]
    cursor = shutil.which("cursor")
    if cursor:
        return [cursor, "agent"]
    raise FileNotFoundError(
        "Could not find Cursor agent CLI. Install via https://cursor.com/install "
        "or set CURSOR_AGENT_BIN to the `agent` / `cursor-agent` binary."
    )


def run_headless_agent(
    workspace: Path,
    prompt: str,
    *,
    force: bool,
    extra_args: list[str],
    timeout: Optional[float],
) -> AgentResult:
    prefix = resolve_agent_prefix()
    cmd: list[str] = [
        *prefix,
        "-p",
        "--trust",
        "--output-format",
        "text",
        "--workspace",
        str(workspace.resolve()),
    ]
    if _env_bool("CURSOR_SLACK_APPROVE_MCPS", default=True):
        cmd.append("--approve-mcps")
    if force:
        cmd.extend(("--force",))
    cmd.extend(extra_args)
    if prompt:
        cmd.append(prompt)

    env = os.environ.copy()
    if os.environ.get("CURSOR_API_KEY"):
        env.setdefault("CURSOR_API_KEY", os.environ["CURSOR_API_KEY"])

    LOG.info("Running: %s ...", " ".join(cmd[:6]))
    p = subprocess.run(
        cmd,
        cwd=str(workspace),
        env=env,
        capture_output=True,
        text=True,
        timeout=timeout,
    )
    return AgentResult(p.returncode, p.stdout or "", p.stderr or "")


@dataclass
class SlackBridge:
    token: str
    task_channel_id: str
    pr_channel_id: str
    workspace: Path
    state_path: Path
    pr_log_path: Path
    task_mode: str
    prefix: str
    top_level_only: bool
    allow_thread_tasks: bool
    force_agent: bool
    extra_args: list[str]
    agent_timeout: Optional[float]
    bot_user_id: Optional[str] = None
    last_task_ts: str = "0"
    last_pr_ts: str = "0"
    tracked_pr_urls: list[str] = field(default_factory=list)

    @classmethod
    def from_env(cls, workspace: Path) -> SlackBridge:
        token = os.environ.get("SLACK_BOT_TOKEN", "").strip()
        if not token:
            sys.exit("SLACK_BOT_TOKEN is required")
        raw_task_ch = (
            os.environ.get("SLACK_TASK_CHANNEL", "").strip()
            or os.environ.get("SLACK_CHANNEL", "").strip()
        )
        if not raw_task_ch:
            sys.exit("SLACK_TASK_CHANNEL (or SLACK_CHANNEL) is required")
        raw_pr_ch = os.environ.get("SLACK_PR_CHANNEL", "#pull-requests").strip()

        raw_state = os.environ.get("CURSOR_SLACK_STATE_FILE", "").strip()
        if raw_state:
            state_path = Path(raw_state).expanduser()
        else:
            state_path = workspace / ".cursor_slack_agent_state.json"
        raw_pr_log = os.environ.get("CURSOR_PR_LOG_FILE", "").strip()
        pr_log_path = (
            Path(raw_pr_log).expanduser()
            if raw_pr_log
            else workspace / ".cursor_pr_status_log.jsonl"
        )
        task_mode = os.environ.get("CURSOR_SLACK_TASK_MODE", "both").strip().lower()
        if task_mode not in ("mention", "prefix", "both"):
            sys.exit("CURSOR_SLACK_TASK_MODE must be mention, prefix, or both")

        prefix = os.environ.get("CURSOR_SLACK_PREFIX", "!cursor")
        top = _env_bool("CURSOR_SLACK_TOP_LEVEL", default=True)
        allow_thread_tasks = _env_bool("CURSOR_SLACK_THREAD_TASKS", default=False) or not top
        force = _env_bool("CURSOR_AGENT_FORCE", default=False)
        extra = os.environ.get("CURSOR_AGENT_EXTRA_ARGS", "").strip()
        extra_args: list[str] = []
        if extra:
            try:
                extra_args = json.loads(extra)
                if not isinstance(extra_args, list) or not all(
                    isinstance(x, str) for x in extra_args
                ):
                    raise ValueError("not a JSON list of strings")
            except (json.JSONDecodeError, ValueError) as e:
                sys.exit(f"CURSOR_AGENT_EXTRA_ARGS must be a JSON list of strings: {e}")
        to_raw = os.environ.get("CURSOR_AGENT_TIMEOUT_SEC", "3600").strip()
        agent_timeout: Optional[float]
        if to_raw in ("", "0", "none", "None"):
            agent_timeout = None
        else:
            try:
                agent_timeout = float(to_raw)
            except ValueError:
                sys.exit("CURSOR_AGENT_TIMEOUT_SEC must be a number or 0")

        task_ch = cls._resolve_channel_id(token, raw_task_ch)
        pr_ch = cls._resolve_channel_id(token, raw_pr_ch)
        self = cls(
            token=token,
            task_channel_id=task_ch,
            pr_channel_id=pr_ch,
            workspace=workspace,
            state_path=state_path,
            pr_log_path=pr_log_path,
            task_mode=task_mode,
            prefix=prefix,
            top_level_only=top,
            allow_thread_tasks=allow_thread_tasks,
            force_agent=force,
            extra_args=extra_args,
            agent_timeout=agent_timeout,
        )
        self.tracked_pr_urls = []
        self._load_state()
        self._hydrate_bot_user()
        return self

    @staticmethod
    def _resolve_channel_id(token: str, raw: str) -> str:
        raw = raw.strip()
        if re.match(r"^C[0-9A-Z]+$", raw):
            return raw
        name = raw.lstrip("#").strip()
        if not name:
            sys.exit("Invalid SLACK_CHANNEL")
        cursor: Optional[str] = None
        while True:
            payload: dict[str, Any] = {"types": "public_channel,private_channel", "limit": 200}
            if cursor:
                payload["cursor"] = cursor
            data = _slack_api(token, "conversations.list", payload)
            for ch in data.get("channels", []):
                if ch.get("name") == name:
                    return ch["id"]
            cursor = data.get("response_metadata", {}).get("next_cursor") or None
            if not cursor:
                break
        sys.exit(
            f"Channel {raw!r} not found for this token. "
            "Invite the bot, check spelling, or pass a channel ID (C...)."
        )

    def _load_state(self) -> None:
        if not self.state_path.is_file():
            return
        try:
            data = json.loads(self.state_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as e:
            LOG.warning("Ignoring state file %s: %s", self.state_path, e)
            return
        self.last_task_ts = str(data.get("last_task_ts", "0"))
        self.last_pr_ts = str(data.get("last_pr_ts", "0"))
        self.tracked_pr_urls = [
            x for x in data.get("tracked_pr_urls", []) if isinstance(x, str)
        ]

    def _save_state(self) -> None:
        self.state_path.parent.mkdir(parents=True, exist_ok=True)
        tmp = self.state_path.with_suffix(self.state_path.suffix + ".tmp")
        data = {
            "last_task_ts": self.last_task_ts,
            "last_pr_ts": self.last_pr_ts,
            "tracked_pr_urls": sorted(set(self.tracked_pr_urls or []))[-200:],
        }
        tmp.write_text(json.dumps(data, indent=2), encoding="utf-8")
        tmp.replace(self.state_path)

    def _append_pr_log(self, event: dict[str, Any]) -> None:
        self.pr_log_path.parent.mkdir(parents=True, exist_ok=True)
        with self.pr_log_path.open("a", encoding="utf-8") as f:
            f.write(json.dumps(event, ensure_ascii=True) + "\n")

    def _hydrate_bot_user(self) -> None:
        data = _slack_api(self.token, "auth.test", {})
        self.bot_user_id = data.get("user_id")
        LOG.info("Slack bot user_id=%s", self.bot_user_id)

    def _bootstrap_channel_last_ts(self, channel_id: str, which: str) -> None:
        if which == "task" and float(self.last_task_ts) > 0:
            return
        if which == "pr" and float(self.last_pr_ts) > 0:
            return
        data = _slack_api(
            self.token,
            "conversations.history",
            {"channel": channel_id, "limit": 1},
        )
        msgs = data.get("messages", [])
        value = str(msgs[0]["ts"]) if msgs and msgs[0].get("ts") else str(time.time())
        if which == "task":
            self.last_task_ts = value
        else:
            self.last_pr_ts = value
        self._save_state()
        LOG.info("Bootstrapped %s last_ts=%s (no historical replay).", which, value)

    def bootstrap_last_ts_if_unset(self) -> None:
        """Seed cursors to latest channel messages to avoid replaying old backlog."""
        self._bootstrap_channel_last_ts(self.task_channel_id, "task")
        self._bootstrap_channel_last_ts(self.pr_channel_id, "pr")

    def _is_task(self, text: str) -> bool:
        mention = bool(self.bot_user_id and f"<@{self.bot_user_id}>" in text)
        s = text.lstrip()
        pfx = bool(self.prefix and s.startswith(self.prefix))
        if self.task_mode == "mention":
            return mention
        if self.task_mode == "prefix":
            return pfx
        return mention or pfx

    def _extract_prompt(self, text: str) -> str:
        t = text
        if self.bot_user_id:
            t = t.replace(f"<@{self.bot_user_id}>", " ")
        t = t.strip()
        if self.prefix and t.startswith(self.prefix):
            t = t[len(self.prefix) :].strip()
        return slack_plain_text(t)

    def fetch_new_messages(self, channel_id: str, last_ts: str) -> list[dict[str, Any]]:
        """Slack returns newest first; we reverse to oldest first for safe cursor updates.

        Uses `oldest` so we load messages *after* `last_ts`, not only the last N in the
        channel (see Slack `conversations.history` + pagination).
        """
        all_msgs: list[dict[str, Any]] = []
        page: Optional[str] = None
        while True:
            payload: dict[str, Any] = {
                "channel": channel_id,
                "limit": 200,
            }
            if float(last_ts) > 0:
                payload["oldest"] = last_ts
            if page:
                payload["cursor"] = page
            data = _slack_api(self.token, "conversations.history", payload)
            all_msgs.extend(data.get("messages", []))
            page = (data.get("response_metadata") or {}).get("next_cursor") or None
            if not page:
                break
        return list(reversed(all_msgs))

    def fetch_new_thread_replies(self, channel_id: str, last_ts: str) -> list[dict[str, Any]]:
        """Fetch new thread replies after last_ts.

        Thread replies are not consistently discoverable from channel history alone.
        """
        data = _slack_api(
            self.token,
            "conversations.history",
            {"channel": channel_id, "limit": _thread_scan_limit()},
        )
        parents = data.get("messages", [])
        candidate_thread_ts: list[str] = []
        for msg in parents:
            if not isinstance(msg, dict):
                continue
            if int(msg.get("reply_count", 0) or 0) <= 0:
                continue
            latest_reply = str(msg.get("latest_reply", "0"))
            thread_ts = str(msg.get("thread_ts", msg.get("ts", "0")))
            if float(latest_reply or "0") <= float(last_ts):
                continue
            if float(thread_ts or "0") <= 0:
                continue
            candidate_thread_ts.append(thread_ts)

        out: list[dict[str, Any]] = []
        for thread_ts in sorted(set(candidate_thread_ts), key=float):
            page: Optional[str] = None
            while True:
                payload: dict[str, Any] = {
                    "channel": channel_id,
                    "ts": thread_ts,
                    "limit": 200,
                    "oldest": last_ts,
                }
                if page:
                    payload["cursor"] = page
                replies = _slack_api(self.token, "conversations.replies", payload)
                for msg in replies.get("messages", []):
                    ts = str(msg.get("ts", "0"))
                    if ts == thread_ts:
                        continue
                    if float(ts or "0") <= float(last_ts):
                        continue
                    out.append(msg)
                page = (replies.get("response_metadata") or {}).get("next_cursor") or None
                if not page:
                    break

        return sorted(out, key=lambda m: float(str(m.get("ts", "0"))))

    def post_thread_reply(self, channel_id: str, thread_ts: str, text: str) -> None:
        max_c = _slack_max_message_chars()
        for i in range(0, len(text), max_c):
            part = text[i : i + max_c]
            if i > 0:
                part = f"(continued) {part}"
            _slack_api(
                self.token,
                "chat.postMessage",
                {
                    "channel": channel_id,
                    "thread_ts": thread_ts,
                    "text": part,
                },
            )

    def post_thread_messages(self, channel_id: str, thread_ts: str, messages: list[str]) -> None:
        for msg in messages:
            if not msg:
                continue
            self.post_thread_reply(channel_id, thread_ts, msg)

    def _write_last_run_log(self, code: int, out: str, err: str) -> Path:
        log_path = self.workspace / ".cursor_slack_agent_last_run.log"
        try:
            log_path.write_text(
                f"exit={code}\n\n--- stdout ---\n{out}\n\n--- stderr ---\n{err}\n",
                encoding="utf-8",
            )
        except OSError as e:
            LOG.warning("Could not write %s: %s", log_path, e)
        return log_path

    def _advance_task(self, ts: str) -> None:
        if float(ts) > float(self.last_task_ts):
            self.last_task_ts = ts
        self._save_state()

    def _advance_pr(self, ts: str) -> None:
        if float(ts) > float(self.last_pr_ts):
            self.last_pr_ts = ts
        self._save_state()

    def _extract_pr_urls(self, text: str) -> list[str]:
        return re.findall(r"https://github\.com/[^\s>]+/pull/\d+", text or "")

    def _extract_pr_status(self, text: str) -> str:
        t = (text or "").lower()
        for key in ("approved", "merged", "changes_requested", "blocked", "reviewing", "opened"):
            if key in t:
                return key
        return "noted"

    def process_task_once(self) -> None:
        channel_msgs = self.fetch_new_messages(self.task_channel_id, self.last_task_ts)
        if self.allow_thread_tasks:
            thread_msgs = self.fetch_new_thread_replies(self.task_channel_id, self.last_task_ts)
            by_ts: dict[str, dict[str, Any]] = {}
            for m in channel_msgs + thread_msgs:
                ts = str(m.get("ts", ""))
                if ts:
                    by_ts[ts] = m
            messages = [by_ts[k] for k in sorted(by_ts.keys(), key=float)]
        else:
            messages = channel_msgs

        for m in messages:
            ts = m.get("ts")
            if not ts or float(ts) <= float(self.last_task_ts):
                continue
            st = m.get("subtype")
            if st in ("channel_join", "channel_leave", "channel_topic", "pinned_item"):
                self._advance_task(ts)
                continue
            if m.get("type") != "message":
                self._advance_task(ts)
                continue
            in_thread = bool(
                m.get("thread_ts") and m.get("thread_ts") != m.get("ts")
            )
            if (
                self.top_level_only
                and in_thread
                and not self.allow_thread_tasks
            ):
                LOG.info(
                    "Skipping thread task ts=%s because thread intake is disabled "
                    "(top_level_only=%s allow_thread_tasks=%s)",
                    ts,
                    self.top_level_only,
                    self.allow_thread_tasks,
                )
                self._advance_task(ts)
                continue
            uid = m.get("user")
            if uid and self.bot_user_id and uid == self.bot_user_id:
                self._advance_task(ts)
                continue
            text = m.get("text", "") or ""
            if not self._is_task(text):
                self._advance_task(ts)
                continue
            thread_ts = m.get("thread_ts") or ts
            prompt = self._extract_prompt(text)
            if not prompt:
                self.post_thread_reply(
                    self.task_channel_id,
                    thread_ts,
                    "_(empty task after removing trigger; message ignored)_",
                )
                self._advance_task(ts)
                continue
            if _env_bool("CURSOR_SLACK_DRY_RUN", default=False):
                out = f"[dry-run] Would run headless agent with prompt:\n{prompt}"
                err = ""
                code = 0
            else:
                res = run_headless_agent(
                    self.workspace,
                    prompt,
                    force=self.force_agent,
                    extra_args=self.extra_args,
                    timeout=self.agent_timeout,
                )
                code, out, err = res.returncode, res.stdout, res.stderr
            log_path = self._write_last_run_log(code, out, err)
            max_c = _slack_max_message_chars()
            reply_parts: list[str] = [
                f"*Agent finished* (exit {code}). Full output logged to `{log_path.name}` "
                f"(~{len(out) + len(err)} chars; see threaded chunks below)."
            ]
            reply_parts.extend(_chunk_text("stdout", out, max_c))
            if err:
                reply_parts.extend(_chunk_text("stderr", err, max_c))
            urls = self._extract_pr_urls(out + "\n" + err)
            for url in urls:
                if url not in self.tracked_pr_urls:
                    self.tracked_pr_urls.append(url)
                    self._append_pr_log(
                        {
                            "ts": ts,
                            "event": "tracked_pr_added",
                            "pr_url": url,
                            "source_channel": self.task_channel_id,
                        }
                    )
            self.post_thread_messages(
                self.task_channel_id, thread_ts, reply_parts
            )
            self._advance_task(ts)

    def process_pr_once(self) -> None:
        for m in self.fetch_new_messages(self.pr_channel_id, self.last_pr_ts):
            ts = m.get("ts")
            if not ts or float(ts) <= float(self.last_pr_ts):
                continue
            if m.get("type") != "message":
                self._advance_pr(ts)
                continue
            text = m.get("text", "") or ""
            if not text:
                self._advance_pr(ts)
                continue
            urls = self._extract_pr_urls(text)
            status = self._extract_pr_status(text)
            tracked_hit = [u for u in urls if u in (self.tracked_pr_urls or [])]
            if tracked_hit:
                self._append_pr_log(
                    {
                        "ts": ts,
                        "event": "pr_status_update",
                        "status": status,
                        "pr_urls": tracked_hit,
                        "channel": self.pr_channel_id,
                        "text": slack_plain_text(text)[:1000],
                    }
                )
            elif self.bot_user_id and f"<@{self.bot_user_id}>" in text:
                self._append_pr_log(
                    {
                        "ts": ts,
                        "event": "manual_escalation_note",
                        "status": status,
                        "channel": self.pr_channel_id,
                        "text": slack_plain_text(text)[:1000],
                    }
                )
            self._advance_pr(ts)

    def loop(self, interval: float) -> None:
        LOG.info(
            "Watching task=%s pr=%s workspace=%s mode=%s prefix=%s top_level_only=%s allow_thread_tasks=%s thread_scan_limit=%s",
            self.task_channel_id,
            self.pr_channel_id,
            self.workspace,
            self.task_mode,
            self.prefix,
            self.top_level_only,
            self.allow_thread_tasks,
            _thread_scan_limit(),
        )
        while not self._stop:
            try:
                self.process_task_once()
                self.process_pr_once()
            except Exception:
                LOG.exception("Poll error; will retry")
            time.sleep(max(1.0, interval))
        LOG.info("Shutdown complete")

    _stop = False

    def request_stop(self, *_: Any) -> None:
        self._stop = True


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Headless Cursor agent with Slack #channel task bridge."
    )
    parser.add_argument(
        "--workspace",
        type=Path,
        default=Path(os.environ.get("CURSOR_AGENT_WORKSPACE", ".")).resolve(),
        help="Directory for --workspace (default: $CURSOR_AGENT_WORKSPACE or cwd)",
    )
    parser.add_argument(
        "--once",
        action="store_true",
        help="Poll and process one time then exit (for cron/systemd oneshot)",
    )
    parser.add_argument(
        "-v", "--verbose", action="store_true", help="Debug logging (HTTP noise stays minimal)"
    )
    args = parser.parse_args()

    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format="%(asctime)s %(levelname)s %(message)s",
    )

    bridge = SlackBridge.from_env(args.workspace)
    bridge.bootstrap_last_ts_if_unset()
    interval = float(os.environ.get("CURSOR_SLACK_POLL_SEC", "15"))

    if args.once:
        bridge.process_task_once()
        bridge.process_pr_once()
        return

    for sig in (signal.SIGINT, signal.SIGTERM):
        signal.signal(sig, lambda *_: bridge.request_stop())

    bridge.loop(interval)


if __name__ == "__main__":
    main()
