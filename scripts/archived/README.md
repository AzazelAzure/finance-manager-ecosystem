# Archived scripts

Deprecated or superseded automation. **Do not run** unless explicitly reviving with HitM approval.

## Deprecated orchestration and Slack bridges (2026-06-26)

Moved during admin governance overhaul. Replaced by:

- **Cursor:** native multitask/subagents for local execution; PR automation via `gh` CLI
- **Antigravity:** native IDE automations for admin workflows (daily status, etc.)

| Script | Former role |
|---|---|
| `antigravity_slack_runner.py` | Slack bridge for Antigravity |
| `cursor_bridge_daemon.sh` | Cursor headless Slack bridge daemon |
| `cursor_headless_slack_agent.py` | Headless Cursor Slack agent |
| `sprint_slack_pipeline_bridge.py` | Sprint → Slack pipeline poller |
| `orchestrator.py` | Antigravity CLI wrapper for task dispatch |

## One-off Python (former repo root)

See [`root_one_off_python/README.md`](./root_one_off_python/README.md).
