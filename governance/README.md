# Governance — protocols router

Repo location: **`governance/`** (sibling to `plans/` and `strategy/`). Tactical plans: `plans/<Phase>/<Stage>/<sub-plan>/`. Strategic roadmap: `strategy/strategic-roadmap-reframe-53be/`.

**Bootstrap reading order:** `AGENTS.md` §6 (per agent type). This file is a **lookup table**, not a session-start read for executors.

## Active files

| File | Purpose |
|---|---|
| `plan_registry.md` | Portfolio status — check before authoring or executing |
| `plan_lifecycle.md` | Status transitions and close-out |
| `plan_template.md` | Plan schema (authoring new plans) |
| `definition_of_done.md` | PWA / i18n / SEO bars at plan close |
| `deployment_protocol.md` | CPPR+D, blue-green deploy, SSH rules |
| `execution_protocols.md` | HitM gate message templates |
| `branching_guidelines.md` | Per-feature color-cycle workflow |
| `glossary.md` | Canonical vocabulary |
| `runtime_handoff_template.md` | YAML template for plan `runtime_handoff.md` |
| `workspace_protocol.md` | Multi-workspace checkout, FIFO dispatch/review pipeline, VPS authority (current) |
| `agent_workspace_isolation.md` | Multi-agent git identity and workspace layout (superseded by `workspace_protocol.md`; kept for history) |
| `security_protocols.md` | Security posture targets |
| `HITM_SCHEDULE_AND_TASKS.md` | Personal ops (khal / todoman) |
| `examples/` | Worked examples (reference only) |

## Archived

Superseded orchestration and IDE-mirror docs: `governance/archived/` (includes former `orchestration.md`, skill mirrors, `agent_context_delivery.md`). Cursor sprint task spec: `.cursor/rules/sprint-task-specification.mdc`.

## Canonical enums

Normative strings for plan metadata and gates:

| Field | Values |
|---|---|
| `status` | `draft`, `ready`, `in_progress`, `paused`, `blocked`, `completed`, `abandoned`, `archived` |
| `priority` | `P0`, `P1`, `P2` |
| `manual_gates.*` | `required`, `optional`, `none` |
| `strategic_phase` | `S1` … `S6`, `cross-phase`, `hotfix` |

Full enum tables and `plan_id` domain prefixes remain in git history of this file pre-2026-06-26 overhaul; see `plan_template.md` for validation rules.

## Links

- Agent rules: [`../AGENTS.md`](../AGENTS.md)
- Admin status (Antigravity): [`../strategy/current_status.md`](../strategy/current_status.md)
- Deploy runbook: [`../deploy/SERVER_BETA_INSTALL.md`](../deploy/SERVER_BETA_INSTALL.md)

## Agent restrictions

- Do not modify `governance/` without HitM authorization (except during an approved governance overhaul).
- Do not skip `draft → ready → in_progress` validation outside hotfix paths.
- PR links in chat when an agent opens a PR; reconcile GitHub mergeability before merge.
