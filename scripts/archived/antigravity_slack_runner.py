#!/usr/bin/env python3
"""
DEPRECATED for orchestration (2026-05-05): HitM standard is Cursor + **Cursor PA**
(JSONL outbox → Slack). Do not onboard new sprint traffic to this bridge; see
`governance/cursor_pa_slack_visibility.md` and `governance/archived/agent_workspace_isolation.md`.

Antigravity CLI Slack Runner — bridge between Slack channels and `antigravity chat`.

This script polls Slack channels (e.g. #review-queue) for task messages,
invokes `antigravity chat --mode agent` with the prompt, and posts the
result back as a threaded reply.

Architecture: mirrors scripts/cursor_headless_slack_agent.py but targets
the Antigravity (Gemini) CLI instead of Cursor CLI.

Created: 2026-05-04 — Emergency Orchestration Huddle (D10).

Environment (core)
------------------
  SLACK_BOT_TOKEN          xoxb-... bot token for the antigravity-agent Slack account.
  AG_SLACK_CHANNEL         Channel ID or name (e.g. #review-queue).

Environment (optional)
----------------------
  AG_WORKSPACE             Repo root passed as cwd to `antigravity chat` (default: cwd).
  AG_BINARY                Full path to antigravity if not on PATH (default: /usr/bin/antigravity).
  AG_MODE                  Mode for antigravity chat: ask | edit | agent (default: agent).
  AG_SLACK_PREFIX           Text prefix that marks a task (default: "!antigravity").
  AG_SLACK_POLL_SEC        Poll interval seconds (default: 15).
  AG_SLACK_STATE_FILE      Path to JSON state (default: workspace/.antigravity_slack_state.json).
  AG_TIMEOUT_SEC           Subprocess timeout in seconds (default: 3600; 0 = none).
  AG_SLACK_MAX_CHARS       Max chars per Slack thread reply (default: 2400).

Slack app scopes (bot token)
----------------------------
  channels:history channels:read chat:write

Usage
-----
  export SLACK_BOT_TOKEN=xoxb-...
  export AG_SLACK_CHANNEL='#review-queue'
  python3 scripts/antigravity_slack_runner.py --workspace ~/Documents/python/finance_manager
"""

from __future__ import annotations

import argparse
import json
import logging
import os
import re
import shutil
import signal
import subprocess
import sys
import time
import urllib.error
import urllib.request
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Optional

LOG = logging.getLogger("antigravity_slack_runner")


def _env_bool(name: str, default: bool = False) -> bool:
    v = os.environ.get(name)
    if v is None:
        return default
    return v.strip().lower() in ("1", "true", "yes", "on")


def _slack_api(token: str, method: str, payload: dict[str, Any]) -> dict[str, Any]:
    """Call Slack Web API. Raises RuntimeError on failure."""
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
    """Strip Slack mrkdwn noise for the agent prompt."""
    if not text:
        return ""
    t = re.sub(r"<@[^>]+>", " ", text)
    t = re.sub(r"<#([^|>]+)\|([^>]+)>", r"#\2", t)
    t = re.sub(r"<#([^>]+)>", r"#channel", t)
    t = re.sub(r"<(https?://[^|>]+)\|([^>]+)>", r"\2 \1", t)
    t = re.sub(r"<(https?://[^>]+)>", r"\1", t)
    return " ".join(t.split()).strip()


def resolve_antigravity_binary() -> str:
    """Find the antigravity binary."""
    override = os.environ.get("AG_BINARY")
    if override:
        return override
    ag = shutil.which("antigravity")
    if ag:
        return ag
    default = "/usr/bin/antigravity"
    if os.path.isfile(default):
        return default
    raise FileNotFoundError(
        "Could not find antigravity CLI. Check installation or set AG_BINARY."
    )


@dataclass
class AgentResult:
    returncode: int
    stdout: str
    stderr: str


def run_antigravity_chat(
    workspace: Path,
    prompt: str,
    *,
    mode: str = "agent",
    timeout: Optional[float] = None,
    add_files: Optional[list[str]] = None,
) -> AgentResult:
    """Run `antigravity chat` with the given prompt and capture output."""
    binary = resolve_antigravity_binary()
    cmd: list[str] = [binary, "chat", "--mode", mode]

    if add_files:
        for f in add_files:
            cmd.extend(["--add-file", f])

    # Pass prompt via stdin to avoid shell escaping issues
    cmd.append("-")  # read from stdin

    LOG.info("Running: %s (mode=%s, cwd=%s)", binary, mode, workspace)
    try:
        p = subprocess.run(
            cmd,
            cwd=str(workspace),
            input=prompt,
            capture_output=True,
            text=True,
            timeout=timeout,
        )
        return AgentResult(p.returncode, p.stdout or "", p.stderr or "")
    except subprocess.TimeoutExpired:
        return AgentResult(124, "", f"Timeout after {timeout}s")
    except FileNotFoundError as e:
        return AgentResult(127, "", str(e))


def resolve_channel_id(token: str, raw: str) -> str:
    """Resolve #channel-name to Slack channel ID."""
    raw = raw.strip()
    if re.match(r"^C[0-9A-Z]+$", raw):
        return raw
    name = raw.lstrip("#").strip()
    if not name:
        sys.exit("Invalid AG_SLACK_CHANNEL")
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
        f"Channel {raw!r} not found. Invite the bot, check spelling, "
        "or pass a channel ID (C...)."
    )


@dataclass
class AntigravitySlackRunner:
    token: str
    channel_id: str
    workspace: Path
    state_path: Path
    mode: str
    prefix: str
    agent_timeout: Optional[float]
    max_chars: int
    bot_user_id: Optional[str] = None
    last_ts: str = "0"
    _stop: bool = False

    @classmethod
    def from_env(cls, workspace: Path) -> "AntigravitySlackRunner":
        token = os.environ.get("SLACK_BOT_TOKEN", "").strip()
        if not token:
            sys.exit("SLACK_BOT_TOKEN is required")

        raw_ch = os.environ.get("AG_SLACK_CHANNEL", "").strip()
        if not raw_ch:
            sys.exit("AG_SLACK_CHANNEL is required")

        channel_id = resolve_channel_id(token, raw_ch)

        raw_state = os.environ.get("AG_SLACK_STATE_FILE", "").strip()
        state_path = (
            Path(raw_state).expanduser()
            if raw_state
            else workspace / ".antigravity_slack_state.json"
        )

        mode = os.environ.get("AG_MODE", "agent").strip()
        prefix = os.environ.get("AG_SLACK_PREFIX", "!antigravity").strip()

        to_raw = os.environ.get("AG_TIMEOUT_SEC", "3600").strip()
        agent_timeout: Optional[float]
        if to_raw in ("", "0", "none", "None"):
            agent_timeout = None
        else:
            try:
                agent_timeout = float(to_raw)
            except ValueError:
                sys.exit("AG_TIMEOUT_SEC must be a number or 0")

        raw_max = os.environ.get("AG_SLACK_MAX_CHARS", "2400").strip()
        try:
            max_chars = max(500, min(int(raw_max), 3500))
        except ValueError:
            max_chars = 2400

        self = cls(
            token=token,
            channel_id=channel_id,
            workspace=workspace,
            state_path=state_path,
            mode=mode,
            prefix=prefix,
            agent_timeout=agent_timeout,
            max_chars=max_chars,
        )
        self._load_state()
        self._hydrate_bot_user()
        return self

    def _hydrate_bot_user(self) -> None:
        data = _slack_api(self.token, "auth.test", {})
        self.bot_user_id = data.get("user_id")
        LOG.info("Slack bot user_id=%s", self.bot_user_id)

    def _load_state(self) -> None:
        if not self.state_path.is_file():
            return
        try:
            data = json.loads(self.state_path.read_text(encoding="utf-8"))
            self.last_ts = str(data.get("last_ts", "0"))
        except (OSError, json.JSONDecodeError) as e:
            LOG.warning("Ignoring state file %s: %s", self.state_path, e)

    def _save_state(self) -> None:
        self.state_path.parent.mkdir(parents=True, exist_ok=True)
        tmp = self.state_path.with_suffix(self.state_path.suffix + ".tmp")
        tmp.write_text(
            json.dumps({"last_ts": self.last_ts}, indent=2),
            encoding="utf-8",
        )
        tmp.replace(self.state_path)

    def _bootstrap_ts(self) -> None:
        if float(self.last_ts) > 0:
            return
        data = _slack_api(
            self.token,
            "conversations.history",
            {"channel": self.channel_id, "limit": 1},
        )
        msgs = data.get("messages", [])
        self.last_ts = str(msgs[0]["ts"]) if msgs else str(time.time())
        self._save_state()
        LOG.info("Bootstrapped last_ts=%s (no historical replay).", self.last_ts)

    def _is_task(self, text: str) -> bool:
        """Check if message is a task for this runner."""
        mention = bool(self.bot_user_id and f"<@{self.bot_user_id}>" in text)
        pfx = bool(self.prefix and text.lstrip().startswith(self.prefix))
        return mention or pfx

    def _extract_prompt(self, text: str) -> str:
        t = text
        if self.bot_user_id:
            t = t.replace(f"<@{self.bot_user_id}>", " ")
        t = t.strip()
        if self.prefix and t.startswith(self.prefix):
            t = t[len(self.prefix):].strip()
        return slack_plain_text(t)

    def _post_reply(self, thread_ts: str, text: str) -> None:
        for i in range(0, len(text), self.max_chars):
            part = text[i: i + self.max_chars]
            if i > 0:
                part = f"(continued) {part}"
            _slack_api(
                self.token,
                "chat.postMessage",
                {
                    "channel": self.channel_id,
                    "thread_ts": thread_ts,
                    "text": part,
                },
            )

    def _advance(self, ts: str) -> None:
        if float(ts) > float(self.last_ts):
            self.last_ts = ts
        self._save_state()

    def process_once(self) -> None:
        """Poll for new messages and process tasks."""
        all_msgs: list[dict[str, Any]] = []
        page: Optional[str] = None
        while True:
            payload: dict[str, Any] = {
                "channel": self.channel_id,
                "limit": 200,
            }
            if float(self.last_ts) > 0:
                payload["oldest"] = self.last_ts
            if page:
                payload["cursor"] = page
            data = _slack_api(self.token, "conversations.history", payload)
            all_msgs.extend(data.get("messages", []))
            page = (data.get("response_metadata") or {}).get("next_cursor") or None
            if not page:
                break

        # Oldest first
        messages = sorted(all_msgs, key=lambda m: float(str(m.get("ts", "0"))))

        for m in messages:
            ts = m.get("ts")
            if not ts or float(ts) <= float(self.last_ts):
                continue

            # Skip system messages
            st = m.get("subtype")
            if st in ("channel_join", "channel_leave", "channel_topic", "pinned_item"):
                self._advance(ts)
                continue
            if m.get("type") != "message":
                self._advance(ts)
                continue

            # Skip own messages
            uid = m.get("user")
            if uid and self.bot_user_id and uid == self.bot_user_id:
                self._advance(ts)
                continue

            text = m.get("text", "") or ""
            if not self._is_task(text):
                self._advance(ts)
                continue

            thread_ts = m.get("thread_ts") or ts
            prompt = self._extract_prompt(text)
            if not prompt:
                self._post_reply(thread_ts, "_(empty task after removing trigger; ignored)_")
                self._advance(ts)
                continue

            # Execute
            LOG.info("Task received (ts=%s): %.200s...", ts, prompt)
            self._post_reply(thread_ts, f"🔄 *Antigravity processing...*\nMode: `{self.mode}`")

            if _env_bool("AG_DRY_RUN"):
                result = AgentResult(0, f"[dry-run] Would run: {prompt}", "")
            else:
                result = run_antigravity_chat(
                    self.workspace,
                    prompt,
                    mode=self.mode,
                    timeout=self.agent_timeout,
                )

            # Post results
            status = "✅" if result.returncode == 0 else "❌"
            header = f"{status} *Antigravity finished* (exit {result.returncode})"
            self._post_reply(thread_ts, header)

            if result.stdout:
                self._post_reply(thread_ts, f"*stdout:*\n```\n{result.stdout[:self.max_chars]}\n```")
            if result.stderr:
                self._post_reply(thread_ts, f"*stderr:*\n```\n{result.stderr[:self.max_chars]}\n```")

            # Log locally
            log_path = self.workspace / ".antigravity_slack_last_run.log"
            try:
                log_path.write_text(
                    f"exit={result.returncode}\n\n--- stdout ---\n{result.stdout}\n\n--- stderr ---\n{result.stderr}\n",
                    encoding="utf-8",
                )
            except OSError:
                pass

            self._advance(ts)

    def loop(self, interval: float) -> None:
        LOG.info(
            "Watching channel=%s workspace=%s mode=%s prefix=%s",
            self.channel_id,
            self.workspace,
            self.mode,
            self.prefix,
        )
        while not self._stop:
            try:
                self.process_once()
            except Exception:
                LOG.exception("Poll error; will retry")
            time.sleep(max(1.0, interval))
        LOG.info("Shutdown complete")

    def request_stop(self, *_: Any) -> None:
        self._stop = True


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Antigravity CLI Slack runner — bridge Slack tasks to `antigravity chat`."
    )
    parser.add_argument(
        "--workspace",
        type=Path,
        default=Path(os.environ.get("AG_WORKSPACE", ".")).resolve(),
        help="Repo root for antigravity chat (default: $AG_WORKSPACE or cwd)",
    )
    parser.add_argument(
        "--once",
        action="store_true",
        help="Poll and process one time then exit (for cron/systemd oneshot)",
    )
    parser.add_argument(
        "-v", "--verbose", action="store_true", help="Debug logging"
    )
    args = parser.parse_args()

    logging.basicConfig(
        level=logging.DEBUG if args.verbose else logging.INFO,
        format="%(asctime)s %(levelname)s %(message)s",
    )

    runner = AntigravitySlackRunner.from_env(args.workspace)
    runner._bootstrap_ts()
    interval = float(os.environ.get("AG_SLACK_POLL_SEC", "15"))

    if args.once:
        runner.process_once()
        return

    for sig in (signal.SIGINT, signal.SIGTERM):
        signal.signal(sig, lambda *_: runner.request_stop())

    runner.loop(interval)


if __name__ == "__main__":
    main()
