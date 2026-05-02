# Plan Governance — AI Operations Manual

Primary audience: AI agents (Cursor desktop, Cursor cloud, headless Slack bridge, any future agent).
Secondary audience: HitM (Human in the Middle = `pproctor`) at Slack confirmation gates only.

This manual defines how AI agents author and execute plans **consistently** across runs and across agent types.

## Files in this directory


| File                      | Purpose                                                                    | Read when                                                   |
| ------------------------- | -------------------------------------------------------------------------- | ----------------------------------------------------------- |
| `README.md`               | Router, canonical enums, reading sequences                                 | First, every session                                        |
| `plan_template.md`        | Schema for new plans                                                       | Authoring a plan                                            |
| `plan_registry.md`        | Portfolio status of all plans                                              | Before authoring or executing (conflict + dependency check) |
| `plan_lifecycle.md`       | State machine + transition actions                                         | At every status transition                                  |
| `execution_protocols.md`  | Exact Slack gate + handoff templates                                       | Producing any HitM-facing message                           |
| `deployment_protocol.md`  | CPPR+D cycle, blue-green deploy, SSH rules                                 | Plan has `deployment.required: true`                        |
| `branching_guidelines.md` | Per-feature color-cycle workflow                                           | Producing or executing a feature on inactive color          |
| `glossary.md`             | Canonical vocabulary (Phase/Stage/Sprint, launch states, plan types, etc.) | First, every session                                        |
| `HITM_SCHEDULE_AND_TASKS.md` | khal + todoman paths, sprint/absence workflow, how to refresh agent snapshot | Before dense sprint planning or availability assumptions |
| `HITM_SCHEDULE_SNAPSHOT.md` | **Generated** (`./scripts/schedule_agent_sync.sh`); gitignored | When present locally: calendar window + open tasks for agents |


## Reading sequences

### Sequence A: authoring a new plan

1. `README.md`
2. `plan_registry.md` → list active plans → check conflicts
3. `plans/cursor/strategic-roadmap-reframe-53be/phases/S<n>_*.md` → strategic context for declared phase
4. `plan_template.md` → fill schema
5. `plan_lifecycle.md` §Stage 1 + §Stage 2 → execute Birth + Validation
6. Append registry row → status `draft` or `ready`

### Sequence B: executing an existing plan

1. `README.md`
2. `plan_registry.md` → confirm `status: ready` and all `depends_on` are `completed`
3. `<plan_root>/README.md` → strategic inheritance + tasks
4. `execution_protocols.md` → produce required Slack gate messages
5. `plan_lifecycle.md` §Stage 3..§Stage 5 → execute through to close
6. If `deployment.required: true`: also follow Sequence E
7. Update registry row at every transition

### Sequence C: handing off mid-plan

1. `execution_protocols.md` §2 → use exact handoff template
2. `plan_lifecycle.md` quick reference → confirm status transition
3. Update registry row

### Sequence D: hotfix

1. `plan_lifecycle.md` §Stage 1 hotfix variant
2. `execution_protocols.md` §1.2 (pre_merge gate still applies)
3. If hotfix touches deployed code: `deployment_protocol.md` still applies (skip optional gates only with HitM authorization)
4. Retroactive plan body within 24h of resolution

### Sequence E: deploying a plan to VPS (CPPR+D)

Triggered after PR merge when `deployment.required: true`.

1. `deployment_protocol.md` §1 → understand CPPR+D
2. `deployment_protocol.md` §3 → post `pre_deploy` gate
3. `deployment_protocol.md` §4 → execute deploy actions on inactive color
4. `deployment_protocol.md` §5 → post `pre_cutover` gate after smoke
5. `deployment_protocol.md` §6 → execute cutover
6. `deployment_protocol.md` §7 → monitoring window
7. `deployment_protocol.md` §9 → include deploy evidence in `pre_close` gate
8. Continue Sequence B step 6 → close per `plan_lifecycle.md` §E

## Canonical enums

These values are normative. AI agents must use only these strings. Validation fails if any other value appears.

### `status`


| Value         | Meaning                                      |
| ------------- | -------------------------------------------- |
| `draft`       | Authoring in progress                        |
| `ready`       | Validation passed; can be picked up          |
| `in_progress` | Active work; branch may exist                |
| `paused`      | Voluntary hold                               |
| `blocked`     | External blocker                             |
| `completed`   | Exit criteria met; PR merged; close-out done |
| `abandoned`   | Will not be completed                        |
| `archived`    | Moved to `plans/archived/`                   |


### `priority`


| Value | Meaning                                                       |
| ----- | ------------------------------------------------------------- |
| `P0`  | Strategic blocker or production incident; preempts other work |
| `P1`  | Important; parallelizable                                     |
| `P2`  | Nice to have; low-energy work                                 |


### `strategic_phase`


| Value         | Meaning                                             |
| ------------- | --------------------------------------------------- |
| `S1`          | Public Beta Launch + Position Lock-in               |
| `S2`          | PH Vertical Hardening                               |
| `S3`          | Mobile Offline-First                                |
| `S4`          | Trust & Reputation Building                         |
| `S5`          | ZK Middleware Magnum Opus (conditional)             |
| `S6`          | Sari-Sari B2B Vertical (conditional)                |
| `cross-phase` | Infrastructure / governance serving multiple phases |
| `hotfix`      | Production incident response                        |


### `slack_gates.`*


| Value      | Meaning                                                        |
| ---------- | -------------------------------------------------------------- |
| `required` | Agent must wait for HitM reply before proceeding               |
| `optional` | Agent posts notification; proceeds after timeout (default 24h) |
| `none`     | No HitM interaction at this checkpoint                         |


### Domain prefixes for `plan_id`


| Prefix      | Use for                                                        |
| ----------- | -------------------------------------------------------------- |
| `API`       | `finance_manager_api/`                                         |
| `REFLEX`    | `finance_manager_reflex/`                                      |
| `CLI`       | `finance_manager_cli/`                                         |
| `ANDROID`   | `finance_manager_android/`                                     |
| `RUST`      | Rust middleware/tooling                                        |
| `DOCS`      | `design_docs/` only                                            |
| `OPS`       | Runtime / scripts / deployment                                 |
| `INFRA`     | `docker-compose.yml`, `proxy/`, root config                    |
| `STRATEGIC` | Strategic roadmap or governance changes (HitM-authorized only) |
| `CROSS`     | Multi-domain                                                   |
| `HOTFIX`    | Incident response (any domain)                                 |


## Bidirectional links

- Strategic roadmap: `plans/cursor/strategic-roadmap-reframe-53be/README.md` §8 → references this directory.
- Every tactical plan's `strategic_link` field → references a specific phase doc.
- This `README.md` enums → referenced by `plan_template.md` for validation.
- `deployment_protocol.md` → references `design_docs/40_System_Design/13_Server_Runtime_Agent_Operations_Contract.md` for control-plane / execution-plane operating model.
- `deployment_protocol.md` → references `deploy/SERVER_BETA_INSTALL.md` for runbook commands and `scripts/fm_server_beta.sh` + `scripts/server/`* for execution.

## What this directory does not contain

- Actual plans. **Active tactical plans** live under `plans/cursor/<phase-stage>/<sub-plan>/` (see `branching_guidelines.md`). **Closed or superseded plans** live under `plans/archived/` (flat `PLAN_*.md`, huddle folders like `post_beta_huddle_2026-04-30/`, or nested `archived/feat/`, `archived/fix/`, `archived/volatile/`, `archived/volatile_standby/` from the 2026-05-01 layout consolidation).
- Strategic context. That lives in `plans/cursor/strategic-roadmap-reframe-53be/`.
- Tooling. Governance is documentation, not enforcement code.

## Forbidden actions for agents

- Authoring or modifying files in `_governance/` without explicit HitM authorization.
- Modifying `plans/cursor/strategic-roadmap-reframe-53be/` files except via `plan_lifecycle.md` Stage 5 close-out updates to `validation_gates.md` and `kill_commit_gates.md`.
- Skipping validation (`draft → in_progress` directly) outside hotfix variant.
- Merging without Slack `#pull-requests` authorization (workspace rule, reinforced here).
- Authoring plans without `strategic_phase` and `strategic_link` populated.