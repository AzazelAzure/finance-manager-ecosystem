# Cursor PA — Slack visibility (out of repo)

*Aligned with 2026-05-04 orchestration huddle reconciliation (2026-05-05).*

## Runtime layout (Cursor PA checkout)

Canonical Socket Mode runner (read this file on the PA host for exact behavior):

**`~/CursorAgent/headless-cursor-agent/scripts/cursor_slack_runner.py`**

Repo root for that install: **`~/CursorAgent/headless-cursor-agent/`** (`ROOT = parent of scripts/` in the runner).

| Artifact | Path (relative to that root) | Role |
|----------|-------------------------------|------|
| **Inbox** | `cursor_slack_inbox.jsonl` | Queued inbound Slack work (legacy / compatibility); runner **drains in-process** after Socket events — see runner docstring. |
| **Outbox** | `cursor_slack_outbox.jsonl` | Outbound lines for Slack; runner drains after agent replies (compatibility / inspection). |
| **Agent** | `bin/agent-prompt` | Invoked by the runner to execute queued tasks. |

Tokens / env file: typically **`~/.secrets/mma_companion/slack.env`** (see runner docstring: `SLACK_BOT_TOKEN`, `SLACK_APP_TOKEN`, optional `SLACK_ENV_FILE`).

Older docs sometimes said `slack_outbox.jsonl` — **Cursor PA headless stack uses the names above** unless your checkout has been customized.

**In-repo sprint bridge:** [`scripts/sprint_slack_pipeline_bridge.py`](../scripts/sprint_slack_pipeline_bridge.py) uses the **same** `SLACK_BOT_TOKEN` family but **polls** `#sprint-queue` / `#review-queue` via Web API — it does **not** replace Socket Mode intake. Run it **alongside** `cursor_slack_runner.py` on the same host when you want automated slice handoffs; keep **channel allowlists** (`CURSOR_PA_CHANNEL_ALLOWLIST` / `CURSOR_PA_BLOCK_CHANNEL_IDS`) coherent so PA and the bridge do not fight over unrelated traffic.

## What is canonical

**Slack status during production and sprint automation** is owned by **Cursor PA** on HitM’s machine (repository is **outside** this monorepo; paths use `~`, not machine-specific absolutes in shared docs).

- **Runner bot** uses Slack **Socket Mode** in `cursor_slack_runner.py` (see table above).
- **Automation and agents** may append lines to **`cursor_slack_outbox.jsonl`** for the runner to post; prefer the runner’s own paths over ad-hoc filenames.

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

## Sprint pipeline: automation vs PA (2026-05-06)

- **`sprint-queue-v1`** ([`sprint_queue_message_spec_v1.md`](./sprint_queue_message_spec_v1.md)) defines **intake** to `#sprint-queue`.
- **In-repo bridge:** [`scripts/sprint_slack_pipeline_bridge.py`](../scripts/sprint_slack_pipeline_bridge.py) polls Slack **and** (optionally) drains **`SPRINT_PIPELINE_LOCAL_INBOX`** JSONL on the same host — **`#sprint-queue` thread or local inbox (READY JSON) → `#review-queue` → (optional) next `#sprint-queue` file or `#hitm-gate`**. Default **`SPRINT_BRIDGE_AUTO_PASS_IF_NON_HITM`** skips manual `#review-queue` PASS when `requires_hitm` is false. Emit READY from tasks with [`scripts/sprint_pipeline_emit_ready.py`](../scripts/sprint_pipeline_emit_ready.py). Run the bridge where `SLACK_BOT_TOKEN` lives; it complements PA intake and does **not** replace PA Socket Mode for executor prompting unless you consolidate hosts.
- **HitM gate:** when `requires_hitm` is true in the machine-readable verdict path, the bridge posts to **`#hitm-gate`** — human verification is **intentionally** not automated.
- **Evolving PA:** logic that mirrors the bridge can move into `cursor_slack_runner.py` / headless repo over time; until then, run **bridge + runner** together per §Runtime layout.
- **`scripts/antigravity_slack_runner.py`** remains **deprecated** for new sprint orchestration.

## Shelved (future versioning)

- **MCP + cursor-agent channel/thread policy:** Allowing cursor-agents to use Slack MCP (or equivalent) so automation can **dictate** target channels and threads (e.g. `#sprint-queue` top-level vs review threads) would simplify orchestration, but needs runner support, auth scope review, and a **`sprint-queue-v2`**-style spec bump. Canonical **v1** queue shape (including `BRANCH: … (already checked out)` / `(checkout required)`): [`sprint_queue_message_spec_v1.md`](./sprint_queue_message_spec_v1.md). F-007 plan holds **worked examples** only: [`plans/S1/S1.B/feat-f007-walkthrough-polish/SLACK_SPRINT_QUEUE.md`](../plans/S1/S1.B/feat-f007-walkthrough-polish/SLACK_SPRINT_QUEUE.md).

## Related governance

- [`agent_workspace_isolation.md`](./agent_workspace_isolation.md) — executor identity and isolation; Antigravity paths are **legacy** for orchestration.
- [`execution_protocols.md`](./execution_protocols.md) — HitM gate templates (Slack wording for human gates still applies).
