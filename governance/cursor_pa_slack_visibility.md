# Cursor PA — Slack visibility (out of repo)

*Aligned with 2026-05-04 orchestration huddle reconciliation (2026-05-05).*

## What is canonical

**Slack status during production and sprint automation** is owned by **Cursor PA** on HitM’s machine (repository is **outside** this monorepo; paths use `~`, not machine-specific absolutes in shared docs).

- **Runner bot** uses the Slack Web API with a bot token (long-lived process).
- **Automation and agents** append **structured JSON lines** to the runner’s **outbox JSONL file** (commonly named `slack_outbox.jsonl` — confirm the exact filename in your Cursor PA checkout). The runner **drains** that file and **posts to Slack** so HitM stays in the loop without opening the IDE.

## What is not the same thing

- **Slack MCP inside Cursor IDE** is for **interactive** agent sessions. It does **not** replace the runner outbox for unattended pipeline status.
- **`cursor agent` CLI** may support MCP-related flags; HitM’s Slack MCP registration today is **IDE-only**. Treat **CLI + outbox** as the durable path for “post where we are in automation.”

## Message shape (recommended)

Each outbox line (or Slack post derived from it) should be easy to grep:

- `T##.SL#` (or plan id)
- Git branch / short SHA
- V-tier reached (V0–V3)
- Link or path to **evidence** (e.g. `sprint_verify` log under `plans/.../evidence/`)
- `PASS` | `FAIL` | `BLOCKER` + one-line summary

## In-repo references (optional)

[`scripts/cursor_headless_slack_agent.py`](../scripts/cursor_headless_slack_agent.py) is a **separate** Web-API poller pattern in this workspace. It is **not** required when Cursor PA + outbox is the operational standard.

## Related governance

- [`agent_workspace_isolation.md`](./agent_workspace_isolation.md) — executor identity and isolation; Antigravity paths are **legacy** for orchestration.
- [`execution_protocols.md`](./execution_protocols.md) — HitM gate templates (Slack wording for human gates still applies).
