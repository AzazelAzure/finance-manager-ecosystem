---
plan_id: PLAN_CROSS_PREDICTIVE_BUDGET_F003_2026-05-05
status: draft
priority: P2
created: 2026-05-05
updated: 2026-05-05
owner: pproctor

plan_root: plans/S1/S1.B/feat-f003-predictive-budgeting/
intended_branch: cursor/s1b/feat/f003-predictive-budgeting
parent_plan: plans/S1/S1.B/

target_repos:
  - finance_manager_api
  - finance_manager_web
  - finance_manager_rust_tools

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
    - Projection or burn-rate read path smoke
  notes: Use `finance_manager_rust_tools` `projection` module (mean, sample std, burn-rate summaries) for hot-path or batch consistency with F-002.

standalone: true
standalone_notes: ""
---

# F-003 — Predictive budgeting & spending projections

**Feature idea:** [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) (F-003). **Rust numerics:** [`../../../../finance_manager_rust_tools/README.md`](../../../../finance_manager_rust_tools/README.md).

## 0) Strategic Inheritance

- **Wedge respected:** yes — “where you land before payday” is core wedge.
- **Locked decisions touched:** may intersect STS snapshot fields; coordinate with F-004 sequencing (`depends_on` optional once F-004 data model exists).
- **Cost cap impact:** batch projection jobs must be bounded; reuse rust_tools for statistical core.
- **Validation gates affected:** W3 / Pro differentiation.

## 1) Objective

**Layer 1:** budgets per tag/category (table stakes). **Layer 2:** projections combining velocity, upcoming bills, pay timing — outputs with sane UX for thin-margin users.

## 2) Scope

### In scope

- **rust_tools integration:** e.g. `BurnRateSummary`, `projected_range_std` for bands; extend crate if new formulas are needed before exposing.
- API sources: historical series, upcoming expenses, user pay-cycle settings (may depend on F-004 for cycle truth).
- Web: glance + drill-down; confidence bands per F-003 notes.

### Out of scope

- Full Monte Carlo simulation v1; bank cash-flow import.

## 3) Source Evidence

- [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) §F-003.
- `finance_manager_rust_tools/src/projection.rs`.

## 4) Phase Plan or Task List

Split Layer 1 vs Layer 2 tasks; add explicit coordination task if F-004 must land first for pay-cycle inputs.

## 5) Execution Order

TBD; recommend Layer 1 scaffolding before Layer 2 if no pay-cycle model yet.

## 6) Verification Gates

- Deterministic tests on rust_tools outputs consumed by API.
- UX review for non-alarming copy on “short” scenarios.

## 7) Documentation Sync Required

- API + web changelogs; optional ADR for projection assumptions.

## 8) Strategic Phase Impact

Registry + W3 evidence on completion.

## 9) Completion Criteria

- Shippable Layer 1 + at least one Layer 2 projection path with documented inputs.

## 10) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
| ---- | ------- | -------- | ----- |
| Bad projections erode trust | wrong velocity on sparse data | Hide Layer 2 behind flag; show ranges only | web + api |
