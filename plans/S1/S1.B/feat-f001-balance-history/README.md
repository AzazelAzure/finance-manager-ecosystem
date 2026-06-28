---
plan_id: PLAN_CROSS_BALANCE_HISTORY_F001_2026-05-05
status: completed
priority: P2
created: 2026-05-05
updated: 2026-06-28
owner: pproctor

plan_root: plans/S1/S1.B/feat-f001-balance-history/
intended_branch: cur/s1b/feat/f001-balance-history
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
    - Dashboard loads; balance history endpoint or widget smoke per implementation
  notes: Ships schema + API + web visualization; follow CPPR+D on inactive color per branching_guidelines.

standalone: true
standalone_notes: ""
---

# F-001 — Balance history & trend tracking

**Feature idea:** [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) (F-001). **Backlog index:** [`../../PRODUCT_FEATURE_BACKLOG_INDEX.md`](../../PRODUCT_FEATURE_BACKLOG_INDEX.md).

## Task and slice IDs

Per [`governance/plan_template.md`](../../../../governance/plan_template.md) **§1a Task slices (T##.SL#)** and [`governance/branching_guidelines.md`](../../../../governance/branching_guidelines.md): decompose execution into **tasks** (`T##`, with task branch `…/t##-<slug>` when shipping code) and **slices** (`T##.SL#`). **`SL`** avoids collision with Phase/Stage **S** notation (`S1`, `S1.B`). Default one slice per **web route/page** or per **API model/viewset seam**; do not assign whole-product scope to a single agent pass unless the touched surface is trivially small. Executors must **ask clarifying questions** when acceptance criteria or contracts are underspecified instead of guessing.

## 0) Strategic Inheritance

- **Wedge respected:** yes — trajectory visibility supports “safe to spend” and thin-margin clarity.
- **Locked decisions touched:** none at open; may touch snapshot/KPI contracts when wired to dashboard.
- **Cost cap impact:** bounded storage (day-end snapshots, not per-tx rows) per F-001 notes.
- **Validation gates affected:** contributes to S1.B “worth paying for” / W3 when chart ships.

## 1) Objective

Persist and expose **per-account day-end closing balances** so users see balance **trends** (7d/30d/90d/all) instead of a single current number.

## 2) Scope

### In scope

- Backend model + population strategy (batch nightly and/or backfill from ledger).
- API for querying series by account and date range.
- Web chart(s) on dashboard or account detail; base-currency rules aligned with existing profile logic.

### Out of scope

- Intraday balance streaming; investment performance analytics; third-party bank aggregation.

## 3) Source Evidence

- [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) §F-001.
- Existing transaction + source models; snapshot handler patterns in API.

## 4) Phase Plan or Task List

| Task | File | Repo | Summary |
| ---- | ---- | ---- | ------- |
| T01 | [`tasks/T01_balance_snapshot_model.md`](./tasks/T01_balance_snapshot_model.md) | API | `BalanceSnapshot` model + migration |
| T02 | [`tasks/T02_snapshot_population.md`](./tasks/T02_snapshot_population.md) | API | Nightly Celery job + backfill command |
| T03 | [`tasks/T03_balance_history_api.md`](./tasks/T03_balance_history_api.md) | API | Read endpoint with date-range presets |
| T04 | [`tasks/T04_dashboard_balance_chart.md`](./tasks/T04_dashboard_balance_chart.md) | Web | Dashboard line chart + range selector |

## 5) Execution Order

T01 → T02 → T03 → T04 (API tasks sequential; web T04 after T03 API is on the feature branch).

> **Historical coordination hold (2026-06-28):** F001 was briefly paused and serialized behind F004 (STS pay cycles / bill realism) because two agents shared the `finance_manager_api/` working tree. Ownership transferred cleanly before implementation resumed. See `DECISION_LOG.md` and `runtime_handoff.md`.

> **Closeout (2026-06-28):** F001 shipped via API PR #56 and Web PR #84. VPS rebuilt inactive **blue**, applied migration `0014_balance_snapshot_f001`, backfilled snapshots, passed inactive and active smoke, and promoted **blue** active. See `runtime_handoff.md`.

## 6) Verification Gates

- Migrations apply cleanly; API contract tests for new read endpoints.
- Web: chart renders with empty, partial, and dense series; no regression to dashboard KPI load.
- Manual smoke on `:8443` after deploy.

## 7) Documentation Sync Required

- `finance_manager_api/CHANGELOG.md`, `finance_manager_web/CHANGELOG.md` on ship.
- Optional `design_docs` data model note if new tables affect encryption or retention story.

## 8) Strategic Phase Impact

On close: tick W3 / “worth paying for” alignment in stage review; update `plan_registry.md` to `completed`.

## 9) Completion Criteria

- Day-end series persisted per agreed schema; UI shipped behind feature flag or GA per HitM call.
- §6 gates green; CPPRD satisfied.

## 10) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
| ---- | ------- | ---------- | ----- |
| Snapshot drift vs recomputed balance | Clock/timezone skew | Recompute job; feature flag off | api |
