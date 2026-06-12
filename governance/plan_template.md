# Plan Template — Schema and Validation

Copy verbatim. Fill all fields. Validate against rules below before transitioning `draft → ready`.

For surgical single-file fixes, still use **this** document: copy the **metadata header** (YAML between `---` fences) from §2 into the plan’s `README.md`, keep `plan_root` / `strategic_link` accurate, and use shorter body sections if appropriate — do not skip registry-required fields or `plan_registry.md` updates.

## 1) Required directory layout

```
plans/<Phase>/<Stage>/<sub-plan>/   # e.g. plans/S1/S1.B/drift-cleanup/
├── README.md            ← contains metadata header + body sections
├── tasks/               ← optional, for multi-task plans
│   ├── T01_<slug>.md
│   └── T02_<slug>.md
└── validation_gates.md  ← optional; inline if simple plan
```

## 1a) Task slices (`T##.SL#`) — execution decomposition

**Why:** Whole-feature or whole-site tasks cause large regressions and unreviewable diffs. Execution plans must decompose work so each agent turn has **tight scope**.

| ID | Meaning |
| --- | --- |
| **`T##`** | Task — a numbered unit in the plan (often one `tasks/T##_<slug>.md` file). Maps to a **task branch** when code ships: `cursor/<phase-stage>/feat/<feature-name>/t##-<slug>` per `branching_guidelines.md` (or the sub-plan’s equivalent). |
| **`T##.SL#`** | **Slice** (sub-step within a task). **`SL`** = slice — use this form so **`S`** is never confused with **Phase/Stage** notation (`S1`, `S1.B`). Sequential per task: `T01.SL1`, `T01.SL2`, … |

**Default slice granularity (pick one primary surface per slice):**

- **Web:** one **route/page** (or a single shared shell + one child), not “the entire SPA.”
- **API:** one **model/viewset family** or one **integration seam**, not every endpoint at once.
- **Cross-repo:** still one slice per side when possible; state ordering in the plan README.

**Where to author slices:** In the plan `README.md` (table under each task), and/or inside `tasks/T##_<slug>.md` as an explicit checklist. PR titles or descriptions should name the slice when work is slice-scoped.

**Clarifying questions (mandatory behavior):** If acceptance criteria, API contracts, UX, data shapes, or sequencing are **not** explicit in this plan or linked authoritative docs, **executors must ask HitM (or the orchestrator relays questions)** before implementing. Prefer a **short numbered question list** over guessing product intent.

### Verification tiers (mandatory per slice checklist item)

*Locked 2026-05-04 — Emergency Orchestration Huddle (D1).*

Every checklist item in a slice file must declare its **verification tier**. Agents **cannot mark a slice PASS** without meeting the tier requirement and linking evidence.

| Tier | Name | What counts as PASS | When to use |
|------|------|---------------------|-------------|
| `V0` | **Code audit** | Agent reads source, confirms logic. | Pure docs, governance, plan authoring |
| `V1` | **Local build** | `npm run build` / `pytest` passes locally. Evidence: build log. | API logic, type-safety, unit tests |
| `V2` | **Staging deploy** | Deployed to inactive color; smoke script passes. Evidence: smoke log. | Any user-visible behavior change |
| `V3` | **Browser verify** | Agent opens app in browser (or HitM confirms on device); screenshot/recording captured. | Interactive UI, tours, offline behavior, forms |

**Checklist format** — from:
```
- [ ] Verify X
```
to:
```
- [ ] [V2] Deploy to inactive color and confirm X via smoke script
- [ ] [V3] Browser-verify X on jsdevtesting; capture screenshot
```

**Evidence linking:** Each V1+ item must reference an evidence artifact (log, screenshot, or recording) in an `evidence/` directory within the plan root. Format: `evidence/T##.SL#_<descriptor>.<ext>`.

**Role separation (locked 2026-05-04, D5):** The agent that **writes** code (Executor) may run V0/V1 checks but **must not** self-certify V2/V3. A separate **Reviewer** (or HitM) runs V2+. See `strategy/huddles/2026-05-04-orchestration-overhaul/DECISIONS.md` D5.

### 1b) Interconnected rollout bars (PWA, i18n, SEO, beta surfaces)

Slice V-tiers above are **necessary but not sufficient** for “done” in this ecosystem. Authors must read and apply **[`governance/definition_of_done.md`](./definition_of_done.md)** when writing **§2 Scope** and **§9 Completion Criteria**: PWA non-regression / **online-only** class **B**, **localization** requirements (or explicit shelved follow-up), **SEO** alignment with [`plans/S1/S1.B/distribution-channel-research/SEO_PRIORITY_MATRIX.md`](../plans/S1/S1.B/distribution-channel-research/SEO_PRIORITY_MATRIX.md), and **F-011** beta-comms obligations when user-facing promises change.


## 2) Metadata header (YAML, mandatory)

Place at top of `README.md` between `---` fences.

```yaml
---
plan_id: PLAN_<DOMAIN>_<TOPIC>_<YYYY-MM-DD>
status: draft
priority: P0
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
owner: pproctor

plan_root: plans/<Phase>/<Stage>/<sub-plan>/
intended_branch: agy/<branch>
target_repos:
  - <repo-path>

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with: []
conflicts_with: []

manual_gates:
  pre_execution: required
  pre_merge: required
  pre_close: optional

deployment:
  required: false                  # true if plan ships code to VPS
  target_services: []              # [api] | [reflex] | [js] | [api, reflex] | [infra]
  bundle_required: false           # true if scripts/server/create_runtime_bundle.sh must run
  rollback_plan_id: null           # optional explicit rollback plan_id
  smoke_targets: []                # paths/endpoints validated post-deploy
  notes: ""

standalone: true
standalone_notes: ""
---
```

## 3) Field reference

All enum values are defined in `README.md` §"Canonical enums". Use only those exact strings.


| Field                         | Type          | Enum                       | Required                                | Notes                                                                             |
| ----------------------------- | ------------- | -------------------------- | --------------------------------------- | --------------------------------------------------------------------------------- |
| `plan_id`                     | string        | —                          | yes                                     | Format `PLAN_<DOMAIN>_<TOPIC>_<YYYY-MM-DD>`, DOMAIN from §"Domain prefixes"       |
| `status`                      | enum          | `status`                   | yes                                     | Start as `draft` (or `in_progress` for hotfix only)                               |
| `priority`                    | enum          | `priority`                 | yes                                     | Sets default `manual_gates` (see §6)                                               |
| `created`                     | date          | —                          | yes                                     | ISO `YYYY-MM-DD`                                                                  |
| `updated`                     | date          | —                          | yes                                     | Update on every status change                                                     |
| `owner`                       | string        | —                          | yes                                     | `pproctor` or specific agent id                                                   |
| `plan_root`                   | path          | —                          | yes                                     | Must match actual directory                                                       |
| `intended_branch`             | string        | —                          | yes                                     | Must match `plan_root` last segment                                               |
| `target_repos`                | list          | —                          | yes                                     | Sub-repo paths; empty if pure docs/governance                                     |
| `strategic_phase`             | enum          | `strategic_phase`          | yes                                     | Required even for hotfix (`hotfix`)                                               |
| `strategic_link`              | path          | —                          | yes                                     | Must point to specific phase doc, not strategic README                            |
| `depends_on`                  | list[plan_id] | —                          | yes                                     | May be `[]`                                                                       |
| `blocks`                      | list[plan_id] | —                          | yes                                     | May be `[]`                                                                       |
| `parallel_safe_with`          | list[plan_id] | —                          | yes                                     | May be `[]`                                                                       |
| `conflicts_with`              | list[plan_id] | —                          | yes                                     | May be `[]`                                                                       |
| `manual_gates.pre_execution`  | enum          | `manual_gates.*`           | yes                                     | Default per priority (see §6)                                                     |
| `manual_gates.pre_merge`      | enum          | `manual_gates.*`           | yes                                     | Always `required` per workspace rule                                              |
| `manual_gates.pre_close`      | enum          | `manual_gates.*`           | yes                                     | `required` if plan may meet a strategic exit trigger                              |
| `deployment.required`         | bool          | —                          | yes                                     | `true` if plan ships code to VPS; `false` for docs/governance/local-only changes  |
| `deployment.target_services`  | list          | `[api, reflex, js, infra]` | required if `deployment.required: true` | Which services this plan deploys                                                  |
| `deployment.bundle_required`  | bool          | —                          | required if `deployment.required: true` | `true` if runtime bundle must rebuild; `false` for proxy-only/config-only changes |
| `deployment.rollback_plan_id` | string|null   | —                          | optional                                | Explicit rollback plan if non-trivial                                             |
| `deployment.smoke_targets`    | list          | —                          | required if `deployment.required: true` | Endpoints/paths exercised post-deploy                                             |
| `deployment.notes`            | string        | —                          | optional                                | Free-form deployment context                                                      |
| `standalone`                  | bool          | —                          | yes                                     | `true` unless plan must run alongside another                                     |
| `standalone_notes`            | string        | —                          | required if `standalone: false`         | Explain coupling                                                                  |


## 4) Required body sections (in order)

```markdown
## 0) Strategic Inheritance

- Wedge respected: yes | no | n/a
- Locked decisions touched: <list specific entries from 00_strategic_context.md §3, or "none">
- Cost cap impact: <relevant entries from 01_unit_economics_and_costs.md, or "none">
- Validation gates affected: <specific entries from validation_gates.md, or "none">

## 1) Objective

<2-4 lines, business/engineering goal>

## 2) Scope

### In scope
- <bullet>

### Out of scope
- <bullet>  ← must not be empty

## 3) Source Evidence

- design_docs/...
- plans/...
- <observed log/test output>
- <external refs>

## 4) Phase Plan or Task List

<For multi-phase: phase blocks per strategic-roadmap README>
<For single-batch: task file references; include **slice** rows `T##.SL#` when a task spans multiple pages or API seams — see §1a>

## 5) Execution Order

1. tasks/T01_<slug>.md — slices e.g. `T01.SL1` → `T01.SL2` (order explicit in task file or README table)
2. tasks/T02_<slug>.md

## 6) Verification Gates

<Inline criteria, or reference to validation_gates.md in plan_root>

## 7) Documentation Sync Required

- design_docs/<file>: <what changes>

## 8) Strategic Phase Impact

When closing this plan, executor must:
- [ ] Update strategic-roadmap/validation_gates.md if <specific trigger> met
- [ ] Update strategic-roadmap/kill_commit_gates.md if <specific gate> evaluated
- [ ] Update plan_registry.md status to completed
- [ ] Run design-docs-sync per section 7
- [ ] Post completion summary to IDE Chat

## 9) Completion Criteria

- All exit criteria in §6 met.
- All required manual gates authorized.
- PR merged or stamped docs-only.
- §8 actions complete.

## 10) Risks and Rollback

| Risk | Trigger | Rollback action | Owner |
|---|---|---|---|
| <risk> | <condition> | <action> | <agent or HitM> |
```

## 5) Default `manual_gates` by priority

If author does not override, use:


| priority | pre_execution | pre_merge  | pre_close                                                                  |
| -------- | ------------- | ---------- | -------------------------------------------------------------------------- |
| `P0`     | `required`    | `required` | `required` if `standalone: false` OR plan may meet S exit, else `optional` |
| `P1`     | `optional`    | `required` | `optional`                                                                 |
| `P2`     | `none`        | `required` | `none`                                                                     |
| hotfix   | `none`        | `required` | `none`                                                                     |


## 6) Validation rules (run before `draft → ready`)

Validator (agent) must verify all of:

```
[ ] YAML header parses
[ ] All required fields present (see §3 "Required: yes")
[ ] All enum fields use only canonical values from README.md
[ ] plan_id format matches PLAN_<DOMAIN>_<TOPIC>_<YYYY-MM-DD>
[ ] DOMAIN is one of canonical prefixes
[ ] strategic_link file exists
[ ] strategic_link points to a phase doc (path matches phases/S<n>_*.md), not the strategic README
[ ] All depends_on plan_ids exist in plan_registry.md
[ ] All depends_on plans currently have status: completed (else stay in draft)
[ ] No cycle in depends_on (transitively)
[ ] All conflicts_with plans have been notified or sequenced (cross-referenced in their metadata or merged)
[ ] standalone: false implies standalone_notes is non-empty
[ ] deployment.required: true implies target_services, bundle_required, smoke_targets are populated
[ ] deployment.target_services contains only allowed values [api, reflex, js, infra]
[ ] Body §0 Strategic Inheritance has all four bullets answered
[ ] Body §2 Out of scope is non-empty
[ ] Body §6 Verification Gates is testable (no aspirational language)
[ ] Multi-surface plans: body §4 or task files name **slices** `T##.SL#` per §1a (or justify single-slice tasks)
[ ] Plan is registered in plan_registry.md
```

If any check fails: status stays `draft`, fix issue, re-validate.

## 7) Conflict-detection heuristics (for authoring)

When evaluating `conflicts_with` and `parallel_safe_with`:


| Two plans share                                           | Result                                      |
| --------------------------------------------------------- | ------------------------------------------- |
| Same files modified                                       | `conflicts_with`                            |
| Same Django app                                           | `conflicts_with`                            |
| Same migration sequence                                   | `conflicts_with`                            |
| `docker-compose.yml`, `proxy/`, `.secrets/`, root scripts | `conflicts_with`                            |
| Settings module (`settings.py`)                           | `conflicts_with`                            |
| API contract (one provides, other consumes)               | `depends_on` (consumer depends on provider) |
| Disjoint sub-repos AND no contract changes                | `parallel_safe_with`                        |
| Read-only vs implementation                               | `parallel_safe_with`                        |
| Disjoint Django apps with no shared models                | `parallel_safe_with`                        |


If unsure: ask HitM via IDE Chat before transitioning to `ready`.

## 8) Authoring checklist (`draft → ready` gate)

Run §6 validator. Then:

```
[ ] Strategic Inheritance section is concrete (cites specific lines, not vague)
[ ] Conflict heuristics from §7 applied
[ ] manual_gates match defaults from §5 OR override is justified in body §1
[ ] plan_registry.md row is added
[ ] If priority=P0 and pre_execution=required: ready to post manual gate at execution time
```

When all checks pass: set `status: ready`, update `updated:` field, move registry row to "Ready for Execution".

## 9) Hotfix variant deltas

Hotfix differences from this template:

```
plan_id: PLAN_HOTFIX_<TOPIC>_<YYYY-MM-DD>
status: in_progress           ← starts here, skips draft and ready
priority: P0
strategic_phase: hotfix
manual_gates.pre_execution: none
manual_gates.pre_merge: required   ← still required
manual_gates.pre_close: none
```

Body sections may be filled retroactively within 24h of resolution. Validator §6 is deferred until retroactive fill.