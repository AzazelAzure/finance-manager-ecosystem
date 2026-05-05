# Governance — AI operations manual

Repo location: **`governance/`** (workspace root, sibling to `plans/` and `strategy/`). Tactical **execution plans** live under `plans/<Phase>/<Stage>/<sub-plan>/` (e.g. `plans/S1/S1.B/`); the **Strategic Plan** lives under `strategy/strategic-roadmap-reframe-53be/`. This directory holds **protocols** (registry, lifecycle, deploy, branching, vocabulary).

Primary audience: AI agents (Cursor desktop, Cursor cloud, headless Slack bridge, any future agent).
Secondary audience: HitM (Human in the Middle = `pproctor`) at Slack confirmation gates only.

This manual defines how AI agents author and execute plans **consistently** across runs and across agent types.

## Files in this directory


| File                         | Purpose                                                                      | Read when                                                     |
| ---------------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------- |
| `README.md`                  | Router, canonical enums, reading sequences                                   | First, every session                                          |
| `orchestration.md`           | Strategy / plans / Cursor / runtime map; multi-agent navigation               | Starting a coordinated or multi-step execution session        |
| `skill_roadmap_rollout_planning.md` | Governance mirror of roadmap-rollout-planning (materialize `plans/<Phase>/<Stage>/`) | Authoring phased plans for disk + registry             |
| `skill_orchestration_manager.md`   | Governance mirror of orchestration-manager (delegate, gates, retask)        | Running execution batches over an active plan root           |
| `plan_template.md`           | Schema for new plans                                                         | Authoring a plan                                              |
| `plan_registry.md`           | Portfolio status of all plans                                                | Before authoring or executing (conflict + dependency check)   |
| `plan_lifecycle.md`          | State machine + transition actions                                           | At every status transition                                    |
| `execution_protocols.md`     | Exact Slack gate + handoff templates                                         | Producing any HitM-facing message                             |
| `deployment_protocol.md`     | CPPR+D cycle, blue-green deploy, SSH rules                                   | Plan has `deployment.required: true`                          |
| `branching_guidelines.md`    | Per-feature color-cycle workflow                                             | Producing or executing a feature on inactive color            |
| `glossary.md`                | Canonical vocabulary (Phase/Stage/Sprint, launch states, plan types, etc.)   | First, every session                                          |
| `HITM_SCHEDULE_AND_TASKS.md` | khal + todoman paths, sprint/absence workflow, how to refresh agent snapshot | Before dense sprint planning or availability assumptions      |
| `HITM_SCHEDULE_SNAPSHOT.md`  | **Generated** (`../scripts/schedule_agent_sync.sh`); gitignored               | When present locally: calendar window + open tasks for agents |
| `runtime_handoff_template.md`| Structured YAML template for feature sprint `runtime_handoff.md` files       | When starting any new feature sprint (copy template to plan root) |
| `agent_workspace_isolation.md`| Directory layout, git identity, and concurrency rules for multi-agent workspaces | Setting up agent workspaces or debugging push/identity issues |
| `cursor_pa_slack_visibility.md` | Cursor PA + JSONL outbox vs IDE Slack MCP; durable automation status to Slack | Wiring sprint/production visibility to HitM without conflating MCP and runner bots |


## Reading sequences

### Sequence A: authoring a new plan

1. `README.md`
2. `plan_registry.md` → list active plans → check conflicts
3. `strategy/strategic-roadmap-reframe-53be/phases/S<n>_*.md` → strategic context for declared phase
4. `plan_template.md` → fill schema (multi-surface plans: add **slices** `T##.SL#` per §1a)
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

### Sequence F: multi-agent orchestration (Cursor or headless)

1. `orchestration.md` → roots, directives snapshot, legacy-path warnings  
2. `plan_registry.md` → status and dependencies for the active plan  
3. `skill_orchestration_manager.md` and/or `skill_roadmap_rollout_planning.md` → delegation and materialization rules  
4. Active plan root under `plans/<Phase>/<Stage>/<sub-plan>/` → `README.md` and tasks  
5. `.cursor/rules/agent-delegation.mdc` when routing from Cursor  

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

- Strategic roadmap: `strategy/strategic-roadmap-reframe-53be/README.md` §8 → references this directory.
- Every tactical plan's `strategic_link` field → references a specific phase doc.
- This `README.md` enums → referenced by `plan_template.md` for validation.
- `deployment_protocol.md` → references `design_docs/40_System_Design/13_Server_Runtime_Agent_Operations_Contract.md` for control-plane / execution-plane operating model.
- `deployment_protocol.md` → references `deploy/SERVER_BETA_INSTALL.md` for runbook commands and `scripts/fm_server_beta.sh` + `scripts/server/`* for execution.
- `orchestration.md` → links `strategy/`, `plans/`, `.cursor/` skills, and `skill_*.md` mirrors.

## What this directory does not contain

- Actual plans. **Active tactical plans** live under `plans/<Phase>/<Stage>/<sub-plan>/` (see `branching_guidelines.md`). **Closed or superseded plans** live under `plans/archived/` (flat `PLAN_*.md`, nested `archived/feat/`, `archived/fix/`, `archived/volatile*`, and **`archived/cursor-layout-era/`** for pre–2026-05-04 `plans/cursor/*` umbrellas).
- Strategic context. That lives in `strategy/strategic-roadmap-reframe-53be/`.
- Huddles. **Huddle artifacts** live in `strategy/huddles/<date>-<topic>/` (not in `governance/`). Decisions from huddles propagate to governance files at huddle exit.
- Tooling. Governance is documentation, not enforcement code.

## Forbidden actions for agents

- Authoring or modifying files in the repo-root `governance/` directory (this manual) without explicit HitM authorization.
- Modifying `strategy/strategic-roadmap-reframe-53be/` files except via `plan_lifecycle.md` Stage 5 close-out updates to `validation_gates.md` and `kill_commit_gates.md`.
- Skipping validation (`draft → in_progress` directly) outside hotfix variant.
- Merging without required HitM authorization surfaces defined in `execution_protocols.md` **and** without reconciling **GitHub** mergeability and required checks. PR links must be posted in **Cursor chat** when an agent opens a PR (`AGENTS.md`); Slack gates apply where the plan or protocol still requires them.
- Authoring plans without `strategic_phase` and `strategic_link` populated.