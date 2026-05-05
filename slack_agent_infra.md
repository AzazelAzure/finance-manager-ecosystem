# Slack Agent Infra Map (local workstation)

This is the path map for the Slack automation stack currently used by Cursor PA + companion runtime on this machine.

## 1) Primary runtime (Socket Mode runner)

- `/home/pproctor/Documents/mma_creation/local_instance/scripts/slack_socket_runner.py`
  - Main long-lived Slack Socket Mode process.
  - Reads inbound Slack events, writes `slack_inbox.jsonl`, drains `slack_outbox.jsonl`, drains `slack_command_queue.jsonl`.
  - Also supports optional sprint bridge polling (`SPRINT_PIPELINE_BRIDGE_IN_RUNNER=true`).

- `/home/pproctor/.config/systemd/user/slack-socket-runner.service`
  - User systemd unit that runs the Socket Mode runner.

## 2) Core env/config files

- `/home/pproctor/Documents/mma_creation/local_instance/.secrets/slack.env`
  - Slack app tokens/scopes and runner behavior toggles (`SLACK_AUTO_REPLY_*`, `SLACK_SEEN_REACTION_*`, etc.).

- `/home/pproctor/Documents/mma_creation/local_instance/.secrets/companion_boot.env`
  - Overlay env for companion services (bridge toggles, sprint pipeline env, optional digest/env overrides).

- `/home/pproctor/Documents/mma_creation/local_instance/SLACK_APP_SETUP_CHECKLIST.md`
  - Operational checklist for runner, bridge, command queue, and sprint-pipeline wiring.

## 3) Inbound/outbound files used by the runner

- `/home/pproctor/Documents/mma_creation/local_instance/slack_inbox.jsonl`
  - Append-only inbound Slack events captured by Socket Mode.

- `/home/pproctor/Documents/mma_creation/local_instance/slack_outbox.jsonl`
  - Outbound queued messages; runner marks rows `sent`/`error`.

- `/home/pproctor/Documents/mma_creation/local_instance/slack_auto_reply.jsonl`
  - Log of template auto-replies (if enabled).

## 4) Structured command queue (Web API actions)

- `/home/pproctor/Documents/mma_creation/local_instance/slack_command_queue.jsonl`
  - Queue for allowlisted Slack Web API actions (`chat.postMessage`, `reactions.add`, `conversations.replies`, etc.).

- `/home/pproctor/Documents/mma_creation/local_instance/slack_command_results.jsonl`
  - Per-command result rows (`done`/`error`).

- `/home/pproctor/Documents/mma_creation/local_instance/slack_conversation_replies.jsonl`
  - Logged payloads from `conversations.replies` reads.

- `/home/pproctor/Documents/mma_creation/local_instance/scripts/queue_slack_api_command.py`
  - Helper script to append structured API command rows.

- `/home/pproctor/Documents/mma_creation/local_instance/scripts/queue_slack_message.py`
  - Helper script to append a plain outbound row to `slack_outbox.jsonl`.

## 5) Inbox -> agent bridge (oneshot + timer)

- `/home/pproctor/Documents/mma_creation/local_instance/scripts/slack_inbox_bridge.py`
  - Reads new `slack_inbox.jsonl` rows and routes to:
    - PA mode via `agent-prompt` (headless daemon), or
    - executor mode via direct `cursor-agent --workspace` for structured tasks.

- `/home/pproctor/.config/systemd/user/slack-inbox-bridge.service`
  - Oneshot unit running `slack_inbox_bridge.py --once`.

- `/home/pproctor/.config/systemd/user/slack-inbox-bridge.timer`
  - Periodic trigger for the oneshot bridge.

- `/home/pproctor/Documents/mma_creation/local_instance/.slack_inbox_bridge_state.json`
  - Bridge cursor state (line offset into `slack_inbox.jsonl`).

- `/home/pproctor/Documents/mma_creation/local_instance/slack_bridge_log.jsonl`
  - Bridge activity log (`ok`, `mode`, `agent_exit`, errors, preview).

- `/home/pproctor/Documents/mma_creation/local_instance/slack_inbox_bridge.lock`
  - Lock file to prevent overlapping oneshot runs.

## 6) Headless Cursor daemon path (PA mode)

- `/home/pproctor/CursorAgent/headless-cursor-agent/bin/agent-prompt`
  - Client used by `slack_inbox_bridge.py` for PA-style message generation.

- `/home/pproctor/CursorAgent/headless-cursor-agent/daemon/agentd.py`
  - Daemon that launches `cursor-agent` with persisted chat state.

- `/home/pproctor/.config/systemd/user/headless-cursor-agent.service`
  - User unit for the daemon.

- `/run/user/1000/headless-cursor-agent/agentd.sock`
  - Unix socket used by `agent-prompt`.

- `/home/pproctor/.local/state/headless-cursor-agent/chat_id`
  - Persisted chat id state for the daemon session.

## 7) Executor-task detection helper

- `/home/pproctor/Documents/mma_creation/local_instance/scripts/slack_executor_task_spec.py`
  - Heuristic parser for structured F-* task blocks and workspace hints.
  - Used by runner/bridge to route to executor behavior.

## 8) Sprint pipeline integration (finance_manager side)

- `/home/pproctor/Documents/python/finance_manager/scripts/sprint_pipeline_emit_ready.py`
  - Appends one `READY_FOR_REVIEW` JSON line to `SPRINT_PIPELINE_LOCAL_INBOX`.

- `/home/pproctor/Documents/python/finance_manager/scripts/sprint_slack_pipeline_bridge.py`
  - Reads sprint-thread JSON and/or local inbox JSONL; posts review requests/verdict flow and optional next queue message.
  - Can be run standalone, or invoked by `slack_socket_runner.py --once` in a loop when enabled.

- `/home/pproctor/agent-workspaces/cursor-executor/sprint_pipeline_local_inbox.jsonl`
  - Current local inbox path for sprint READY lines (if `SPRINT_PIPELINE_LOCAL_INBOX` is set to this path).

- `/home/pproctor/Documents/python/finance_manager/plans/pipeline_queue`
  - Shared directory for next queued sprint message text files across features/phases (used by `next_queue_message_path` under base-dir safety checks).

## 9) Optional legacy/parallel units seen on this host

- `/home/pproctor/.config/systemd/user/cursor-cli-slack-bridge.service`
  - Separate bridge service path in finance_manager tree (only relevant if intentionally enabled).

## 10) Quick operational commands

- Restart socket runner:
  - `systemctl --user restart slack-socket-runner.service`

- Follow socket logs:
  - `journalctl --user -u slack-socket-runner.service -f`

- Follow inbox bridge logs:
  - `journalctl --user -u slack-inbox-bridge.service -f`

- One-shot sprint bridge test with runner env:
  - `python3 /home/pproctor/Documents/mma_creation/local_instance/scripts/slack_socket_runner.py --once-sprint-bridge`

- Check headless daemon status:
  - `/home/pproctor/CursorAgent/headless-cursor-agent/bin/agent-prompt --status`
