---

plan_id: PLAN_OPS_DRIFT_CLEANUP_2026-04-30
status: completed
priority: P0
created: 2026-04-30
updated: 2026-05-01
owner: pproctor

plan_root: plans/cursor/s1b/drift-cleanup/
intended_branch: cursor/s1b/drift-cleanup
parent_plan: plans/cursor/s1b/
target_repos:

- finance_manager (parent)
- finance_manager_api
- finance_manager_web
- finance_manager_reflex
- design_docs

strategic_phase: S1
strategic_link: plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with: []
conflicts_with: []

slack_gates:
  pre_execution: required
  pre_merge: required
  pre_close: required

deployment:
  required: true
  target_services: [api, web, infra]
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - GET /api/health/
    - GET / (web root)
    - GET /api/schema/ (OpenAPI surface intact)
  notes: "Multi-task plan; each task may or may not deploy. See task list."

## standalone: true

standalone_notes: ""

# S1.B Sub-Plan — Drift Cleanup

**Completion note (2026-05-01):** HitM confirmed **W1 drift-cleanup scope delivered**. Evidence in tree: e.g. `finance_manager_api` email uniqueness paths (`EmailUniqueRegisterSerializer`, `UserView.post` duplicate checks, `finance/tests/user_tests/test_email_uniqueness.py`), `finance_manager_reflex/ARCHIVED.md` (Topic 2 archival), and related drift tasks merged per repo history. If any **plan_registry** / **validation_gates** checkboxes still show open, reconcile in a single hygiene pass.

## 0) Strategic Inheritance

- **Wedge respected:** yes — drift cleanup serves the wedge by ensuring product is stable for paying users (S0 email uniqueness blocks any new invitee).
- **Locked decisions touched:**
  - §3.1 Reflex archival (per Topic 2 detailed scope) — full per-file scope already locked at huddle.
  - §3.2 ZK middleware AI-orchestrated (no S5 work in this plan).
  - §3.10 "Worth paying for" S1.C entry trigger (these bug fixes contribute to worth-paying-for product state).
- **Cost cap impact:** none beyond standard development costs.
- **Validation gates affected:**
  - S1.B exit: this plan completion is required.
  - Bug fixes contribute to S1.B exit criteria for Issues #1, #4, #7.
  - Reflex archival contributes to S1.B exit criteria.
  - Email uniqueness S0 fix is a hard prerequisite for any S1.C invitee.

## 1) Objective

Close drift accumulated during S1.A launch sprint. Ship six concrete fixes (`+Bill` retroactive commit, email uniqueness S0, Reflex archival, pre-governance plans formal close, Issues #1/#4/#7 bug fixes) so S1.B can proceed cleanly into research workstreams.

## 2) Scope

### In scope

- `+Bill` quick-action disable retroactively committed to git.
- Email uniqueness DB constraint + validation + UI handling.
- Reflex archival per Topic 2 detailed scope (compose, proxy, scripts, env, settings, archive marker).
- Pre-governance plan registry close-out (formality only; status already captured in registry).
- Bug fix for Issue #1: upcoming expense edit `is_recurring=true` broken.
- Bug fixes for Issues #4 + #7: heatmap intensity + calendar daily-active populate (joint investigation).

### Out of scope

- New features (`worth paying for` work is a separate sub-plan).
- Research workstreams (entity, payments, AI economics, distribution).
- Landing polish (separate workstream).
- Android pull-forward (separate sub-plan).

## 3) Source Evidence

- `plans/archived/post_beta_huddle_2026-04-30/KNOWN_ISSUES.md` — full triage of issues.
- `plans/archived/post_beta_huddle_2026-04-30/DECISIONS.md` — Topic 2 Reflex archival per-file scope.
- `design_docs/10_Current_State/01_Runtime_Validation_Checklist.md` §H — BP7 snapshot showing `+Bill` runtime hotfix.
- `_governance/plan_registry.md` — Recently Completed section showing pre-governance plans pending formal close.

## 4) Task List


| Task                                      | Branch                                                    | Files Touched                                                                                                                               | Severity | Type                       |
| ----------------------------------------- | --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------------------------- |
| `tasks/T01_bill_disable_retro_commit.md`  | `cursor/s1b/drift-cleanup/t01-bill-disable-retro-commit`  | `finance_manager_web/src/components/dashboard/QuickActions.tsx`                                                                             | S2       | Retroactive commit         |
| `tasks/T02_email_uniqueness_s0_fix.md`    | `cursor/s1b/drift-cleanup/t02-email-uniqueness-s0-fix`    | API User model, signup serializer, auth views, UI                                                                                           | **S0**   | Bug — distribution-blocker |
| `tasks/T03_reflex_archival.md`            | `cursor/s1b/drift-cleanup/t03-reflex-archival`            | `docker-compose*.yml`, `proxy/`, `scripts/`, `deploy/`, `finance_manager_api/finance_api/settings.py`, `finance_manager_reflex/ARCHIVED.md` | n/a      | Architectural cleanup      |
| `tasks/T04_pre_governance_plans_close.md` | `cursor/s1b/drift-cleanup/t04-pre-governance-plans-close` | `plans/cursor/api-reflex-beta-readiness-plan-53be/`, etc.                                                                                   | n/a      | Formal registry close-out  |
| `tasks/T05_recurring_expense_edit_fix.md` | `cursor/s1b/drift-cleanup/t05-recurring-expense-edit-fix` | API upcoming expenses serializer + web edit modal                                                                                           | S1       | Bug                        |
| `tasks/T06_heatmap_calendar_joint_fix.md` | `cursor/s1b/drift-cleanup/t06-heatmap-calendar-joint-fix` | Web calendar + heatmap rendering + likely API aggregation                                                                                   | S1/S2    | Bug (joint investigation)  |


## 5) Execution Order

1. **T01** — `+Bill` retroactive commit (5 minutes; small clear win).
2. **T02** — Email uniqueness S0 fix (highest severity; before any new invitee).
3. **T03** — Reflex archival (large surface area; defer until smaller items cleared).
4. **T04** — Pre-governance plans formal close (paperwork; no code).
5. **T05** — Recurring expense edit bug fix.
6. **T06** — Heatmap + calendar joint investigation and fix.

Each task ships via per-feature color cycle per `_governance/branching_guidelines.md`. T01 and T04 ship without color flip (no service code change). T02, T03, T05, T06 ship with `pre_deploy` + `pre_cutover` Slack gates.

## 6) Verification Gates

Per task, plus overall plan-level gate:

- All six tasks status `completed`.
- No regression in production smoke after T03 (Reflex archival shouldn't affect web/API; verify).
- `auth_user` table audited for duplicate emails before T02 deploys (per huddle Topic 1 operational consequence).
- Plan registry reflects all pre-governance plans as `completed` after T04.
- Production state verified post-T06 (heatmap + calendar working end-to-end).

## 7) Documentation Sync Required

- `KNOWN_ISSUES.md` (volatile huddle directory): mark Issues #1, #4, #5, #7 as resolved when respective tasks ship.
- `_governance/plan_registry.md`: update each pre-governance plan to `completed` after T04.
- `design_docs/10_Current_State/01_Runtime_Validation_Checklist.md` §H: update BP7 snapshot to remove the "`+Bill` is a runtime hotfix not in git" note after T01.

## 8) Strategic Phase Impact

When this plan closes, executor must:

- Update `plans/cursor/strategic-roadmap-reframe-53be/validation_gates.md` Phase S1 Stage S1.B exit criteria checkboxes for all completed items.
- Append entry to `plans/cursor/strategic-roadmap-reframe-53be/kill_commit_gates.md` outcomes log noting drift cleanup complete.
- Update `plans/_governance/plan_registry.md` status to `completed`.
- Run `design-docs-sync` per task list above.
- Post completion summary to Slack `#cli-interface` thread.

## 9) Completion Criteria

- All exit criteria in §6 met.
- All required Slack gates authorized.
- All task PRs merged.
- §8 actions complete.
- Strategic context still consistent (no contradictions introduced).

## 10) Risks and Rollback


| Risk                                                            | Trigger                                                  | Rollback action                                                                          | Owner                      |
| --------------------------------------------------------------- | -------------------------------------------------------- | ---------------------------------------------------------------------------------------- | -------------------------- |
| T02 email uniqueness migration corrupts existing user data      | DB migration runs against duplicate emails without dedup | `git revert` migration; restore from pre-migration backup; redo with explicit dedup step | HitM                       |
| T03 Reflex archival breaks something dependent on Reflex routes | post-deploy 502 on web or API                            | Color flip rollback per `deployment_protocol.md` §8                                      | HitM (manual verification) |
| T06 calendar/heatmap shared root not actually shared            | Fixing one breaks the other                              | Roll back; investigate as two separate issues; ship sequentially                         | Agent                      |
| Cumulative deploys deplete Cursor budget                        | Cap hit mid-execution                                    | Pause; resume on cycle reset 2026-05-28; T05/T06 may slip                                | HitM                       |
