---
plan_id: PLAN_CROSS_SMART_TAG_ESTIMATION_F002_2026-05-05
status: draft
priority: P2
created: 2026-05-05
updated: 2026-05-05
owner: pproctor

plan_root: plans/S1/S1.B/feat-f002-smart-tag-estimation/
intended_branch: cursor/s1b/feat/f002-smart-tag-estimation
parent_plan: plans/S1/S1.B/

target_repos:
  - finance_manager_api
  - finance_manager_web
  - finance_manager_rust_tools

strategic_phase: S1
strategic_link: plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

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
    - Tag reports / allocation endpoint smoke after integration
  notes: Integrate `finance_manager_rust_tools` (proportional allocation, solo-means weights) via FFI/WASM/batch worker — choose binding in T01; do not duplicate matrix logic in Python long-term.

standalone: true
standalone_notes: ""
---

# F-002 — Smart tag value estimation

**Feature idea:** [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) (F-002). **Rust numerics:** [`../../../../finance_manager_rust_tools/README.md`](../../../../finance_manager_rust_tools/README.md) (crate `tag_allocation`, `projection` building blocks).

## 0) Strategic Inheritance

- **Wedge respected:** yes — accurate tag spend supports household truth.
- **Locked decisions touched:** none at open; reporting contracts may extend.
- **Cost cap impact:** batch CPU bounded by rust_tools + job size; avoid unbounded full-history recompute per request.
- **Validation gates affected:** W3 / worth paying for when reports ship.

## 1) Objective

Apportion multi-tagged transaction amounts across tags using **historical signal** (solo-means path v1; richer models later), so tag-level budgets are not double-counted.

## 2) Scope

### In scope

- **Integrate `finance_manager_rust_tools`:** e.g. `proportional_weights_from_solo_means`, `allocate_from_solo_means` (see crate API); expose results via API job or request-scoped compute with data caps.
- Persist or cache per-user statistics inputs required for weights (solo aggregates, co-occurrence counts as later phase).
- Web: display adjusted tag amounts + optional confidence indicator (F-002 notes).

### Out of scope

- Full Bayesian v1; manual split UX (may be follow-on); cross-user learning.

## 3) Source Evidence

- [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) §F-002.
- `finance_manager_rust_tools/src/tag_allocation.rs`, `CHANGELOG.md`.

## 4) Phase Plan or Task List

- T01: Binding strategy (pyo3 / HTTP sidecar / WASM) + security boundary.
- T02: API aggregation pipeline + persistence for solo-means inputs.
- T03: Web reporting surfaces + copy.

## 5) Execution Order

T01 → T02 → T03 (adjust if binding deferred).

## 6) Verification Gates

- Golden tests against fixed rust_tools outputs (no drift between languages).
- API load tests on worst-case history size; feature flag for rollout.
- Web snapshot tests for tag breakdown UI.

## 7) Documentation Sync Required

- All three target repos `CHANGELOG.md`; link rust_tools version in API release notes.

## 8) Strategic Phase Impact

Close updates W3 evidence; registry `completed`.

## 9) Completion Criteria

- Production path uses rust_tools for v1 allocation math; user-visible improvement documented.

## 10) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
| ---- | ------- | -------- | ----- |
| FFI/WASM complexity slips schedule | binding T01 overruns | Ship API-only fallback with caps; schedule binding | cross |
