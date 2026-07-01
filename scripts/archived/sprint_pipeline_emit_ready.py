#!/usr/bin/env python3
"""
Append one READY_FOR_REVIEW line to SPRINT_PIPELINE_LOCAL_INBOX (JSONL).

Use from an executor wrapper or Cursor PA post-task hook on the **same host** as
`sprint_slack_pipeline_bridge.py`, so the bridge advances the sprint without a human
posting in Slack.

  export SPRINT_PIPELINE_LOCAL_INBOX=~/.../sprint_pipeline_local_inbox.jsonl
  python3 scripts/sprint_pipeline_emit_ready.py --slice T00.SL1 ...

If SPRINT_PIPELINE_LOCAL_INBOX is unset, pass --inbox path explicitly.

Draining that inbox into Slack (review channel, auto-PASS, next-queue file) is done by
``sprint_slack_pipeline_bridge.py``. On your workstation the Socket runner
``mma_creation/local_instance/scripts/slack_socket_runner.py`` can invoke the bridge
``--once`` on a timer when **SPRINT_PIPELINE_BRIDGE_IN_RUNNER** is set — see
``SLACK_APP_SETUP_CHECKLIST.md`` § Companion runner (mma_creation) and
``sprint_slack_pipeline_bridge.py`` docstring.
"""

from __future__ import annotations

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path


def _git_head(cwd: Path) -> str:
    try:
        out = subprocess.run(
            ["git", "rev-parse", "HEAD"],
            cwd=cwd,
            capture_output=True,
            text=True,
            timeout=30,
            check=False,
        )
        if out.returncode == 0 and out.stdout.strip():
            return out.stdout.strip()[:40]
    except OSError:
        pass
    return "none"


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--inbox", help="JSONL path (default: env SPRINT_PIPELINE_LOCAL_INBOX)")
    ap.add_argument("--slice", required=True, help="Slice id e.g. T00.SL1")
    ap.add_argument("--plan-root", required=True, help="Repo-relative plan dir with trailing slash")
    ap.add_argument("--plan-id", default="", help="Plan cross id")
    ap.add_argument("--repo", required=True)
    ap.add_argument("--branch", required=True)
    ap.add_argument("--commit", default="", help="Git sha; default: git rev-parse HEAD in --git-cwd")
    ap.add_argument("--git-cwd", type=Path, help="Repo checkout for default --commit")
    ap.add_argument("--v1-evidence", required=True)
    ap.add_argument("--verify-tiers", default="V0")
    ap.add_argument(
        "--requires-hitm",
        action="store_true",
        help="If set, bridge will not auto-chain to next slice; PASS routes to #hitm-gate",
    )
    ap.add_argument(
        "--next-queue-message-path",
        default="",
        help="Filename under SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR",
    )
    args = ap.parse_args()

    raw_inbox = (args.inbox or os.environ.get("SPRINT_PIPELINE_LOCAL_INBOX", "")).strip()
    if not raw_inbox:
        sys.exit("Set SPRINT_PIPELINE_LOCAL_INBOX or pass --inbox")
    inbox = Path(raw_inbox).expanduser()

    commit = args.commit.strip()
    if not commit or commit == "none":
        cwd = args.git_cwd.expanduser() if args.git_cwd else Path.cwd()
        commit = _git_head(cwd)

    obj = {
        "status": "READY_FOR_REVIEW",
        "slice_id": args.slice,
        "plan_root": args.plan_root,
        "plan_id": args.plan_id,
        "repo": args.repo,
        "branch": args.branch,
        "commit": commit,
        "v1_evidence": args.v1_evidence,
        "verify_tiers": args.verify_tiers,
        "requires_hitm": bool(args.requires_hitm),
        "next_queue_message_path": args.next_queue_message_path or "",
    }
    line = json.dumps(obj, separators=(",", ":")) + "\n"
    inbox.parent.mkdir(parents=True, exist_ok=True)
    with inbox.open("a", encoding="utf-8") as f:
        f.write(line)


if __name__ == "__main__":
    main()
