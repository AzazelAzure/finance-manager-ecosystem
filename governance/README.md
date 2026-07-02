# Governance — protocols router

Repo location: **`governance/`** (sibling to `plans/` and `strategy/`). Tactical plans: `plans/<Phase>/<Stage>/<sub-plan>/`. Strategic roadmap: `strategy/strategic-roadmap-reframe-53be/`.

**Bootstrap reading order:** `AGENTS.md` §6 (per agent type). This file is a **lookup table**, not a session-start read for executors.

## Active files

Reorganized 2026-07-02 into scope-based buckets (mirrors the `scripts/` taxonomy reorg,
2026-07-01). Full rationale and migration record:
`strategy/meetings/week27/meeting2026-07-02/tp-skill-generation/governance_folder_map.md`.

| Bucket | Purpose |
|---|---|
| `plans/` | Plan lifecycle & schema |
| `execution/` | How work moves through the system |
| `deployment/` | Deploy/runtime |
| `incident/` | Failure/security/DR |
| `coordination/` | Cross-agent/meeting/schedule |
| `reference/` | Cross-cutting shared reference |
| `archived/` | Superseded, kept for history |
| `examples/` | Worked examples (reference only) |

### plans/

| File | Purpose |
|---|---|
| `plan_registry.md` | Portfolio status — check before authoring or executing |
| `plan_lifecycle.md` | Status transitions and close-out |
| `plan_template.md` | Plan schema (authoring new plans) |
| `definition_of_done.md` | PWA / i18n / SEO bars at plan close |

### execution/

| File | Purpose |
|---|---|
| `execution_protocols.md` | HitM gate message templates |
| `branching_guidelines.md` | Per-feature color-cycle workflow |
| `workspace_protocol.md` | Multi-workspace checkout, FIFO dispatch/review pipeline, VPS authority (current) |

### deployment/

| File | Purpose |
|---|---|
| `deployment_protocol.md` | CPPR+D, blue-green deploy, SSH rules |
| `Runtime_Signup_Sheet.md` | Human runtime-ownership log |
| `Runtime_Owner_Handoff_Template.md` | Runtime ownership transfer template |
| `runtime_handoff_template.md` | YAML template for plan `runtime_handoff.md` |
| `Git_Owner_Handoff_Template.md` | Branch ownership transfer template |
| `Server_Runtime_Agent_Operations_Contract.md` | Control vs. execution plane contract |

### incident/

| File | Purpose |
|---|---|
| `security_protocols.md` | Security posture targets |
| `incident_response.md` | Production incident protocol |
| `Beta_Week_Incident_Triage_and_Human_Gated_Autofix_Contract.md` | S0/S1 hotfix triage |
| `disaster_recovery.md` | DR scenarios |
| `rca_template.md` | Root-cause analysis artifact template |

### coordination/

| File | Purpose |
|---|---|
| `meeting_artifact_protocol.md` | Huddle/meeting closeout structure |
| `Inter_Agent_Message_Relay_and_Ownership_Contract.md` | Cross-agent relay |
| `HITM_SCHEDULE_AND_TASKS.md` | Personal ops (khal / todoman) |
| `HITM_SCHEDULE_SNAPSHOT.md` | Generated schedule (gitignored) |

### reference/

| File | Purpose |
|---|---|
| `glossary.md` | Canonical vocabulary |
| `Documentation_Sync_Protocol.md` | `design_docs/` alignment routine |

## Archived

Superseded orchestration and IDE-mirror docs: `governance/archived/` (includes former `orchestration.md`, skill mirrors, `agent_context_delivery.md`, and — as of 2026-07-02 —
`agent_workspace_isolation.md`, superseded by `execution/workspace_protocol.md`). Cursor sprint task spec: `.cursor/rules/sprint-task-specification.mdc`.

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
