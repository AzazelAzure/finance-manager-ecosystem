---
plan_id: PLAN_CROSS_SAVINGS_GOALS_F005_2026-05-05
status: completed
priority: P2
created: 2026-05-05
updated: 2026-06-28
owner: pproctor

plan_root: plans/S1/S1.B/feat-f005-savings-goals/
intended_branch: cursor/s1b/feat/f005-savings-goals
parent_plan: plans/S1/S1.B/

target_repos:
  - finance_manager_api
  - finance_manager_web

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with: []
conflicts_with: []

slack_gates:
  pre_execution: none
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [api, js]
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - GET /api/health/
    - Goal CRUD + progress widget smoke
  notes: Coordinate pay-cycle contribution math with F-004 when both exist (`depends_on` optional).

standalone: true
standalone_notes: ""
---

# F-005 — Savings goals with target dates & dynamic recalculation

**Feature idea:** [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) (F-005).

## Task and slice IDs

Per [`governance/plan_template.md`](../../../../governance/plan_template.md) **§1a Task slices (T##.SL#)** and [`governance/branching_guidelines.md`](../../../../governance/branching_guidelines.md): decompose execution into **tasks** (`T##`, with task branch `…/t##-<slug>` when shipping code) and **slices** (`T##.SL#`). **`SL`** avoids collision with Phase/Stage **S** notation (`S1`, `S1.B`). Default one slice per **web route/page** or per **API model/viewset seam**; do not assign whole-product scope to a single agent pass unless the touched surface is trivially small. Executors must **ask clarifying questions** when acceptance criteria or contracts are underspecified instead of guessing.

## 0) Strategic Inheritance

- **Wedge respected:** yes — hopeful pacing for thin-margin savers.
- **Locked decisions touched:** none at open; may use F-004 pay periods for per-cycle contribution.
- **Cost cap impact:** none beyond normal storage.
- **Validation gates affected:** W3 optional differentiator.

## 1) Objective

Goals with target amount + date, per-cycle required savings, live recalculation on progress, multiple concurrent goals, progress UI.

## 2) Scope

### In scope

- Models, API, web progress widget + charts per F-005 notes; link contributions from tagged transactions or manual entries.

### Out of scope

- Investment rate-of-return modeling; joint goal ownership (see F-008).

## 3) Source Evidence

- [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) §F-005.

## 4) Phase Plan or Task List

| Task | Slug | Scope | Repos |
|---|---|---|---|
| T01 | savings-goal-model | `SavingsGoal` model + migration | api |
| T02 | savings-goal-api | CRUD endpoints + per-cycle recalculation logic + tests | api |
| T03 | goals-management-page | `/app/goals` page — full CRUD UI, offline-aware | web |
| T04 | dashboard-goals-widget | `GoalsWidget` on dashboard — top 3 unmet goals, link to goals page | web |

**Execution order:** T01 → T02 (model must exist before API); T03 → T04 (page must exist before widget links to it). Ship as a single branch: api tasks first, then web.

## 5) Execution Order

Schema first; then API; then web.

## 6) Verification Gates

- Recalculation math tests; edge cases (past date, zero periods).

## 7) Documentation Sync Required

- Changelogs; optional design_docs user-journey note.

## 8) Strategic Phase Impact

Registry completion; optional F-011 marketing bullet when shipped.

## 9) Completion Criteria

- Multi-goal CRUD + recalculation + primary UI shipped.

## 10) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
| ---- | ------- | -------- | ----- |
| User confusion on “new pace” copy | negative framing | Copy pass; flag | web |

## 11) Closeout Evidence

Strategic impact:

- F-005 shipped multi-goal savings CRUD, target-date pacing, per-cycle savings guidance, PWA-aware goals page, and dashboard progress widget across API and Web.
- API/Web task PRs landed separately per CPPR task discipline: API #61/#62 and Web #88/#89.

Deployment evidence:

- Active color now: **blue**.
- Cutover timestamp: `2026-06-28T13:16:00+08:00`.
- Post-cutover smoke: pass.
- Monitoring window: 15 minutes complete; 6/6 spaced API health checks returned `200`, `api-blue` stayed healthy, `TOTAL_NON2XX=0`.
- Manifest identity: API `42bfd0e`, Web `8c493b6`.
- Migration: `0016_savings_goal` applied `[X]` on the shared DB; additive table, green rollback safe.
- Smoke targets: `/api/health/` -> `200`; `/finance/savings-goals/` unauth -> `401`; web `/app/goals` -> `200`.
- Rollback fired: no; inactive **green** retained warm.
