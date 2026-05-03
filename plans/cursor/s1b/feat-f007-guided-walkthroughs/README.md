---

plan_id: PLAN_CROSS_GUIDED_TOURS_F007_2026-05-05
status: draft
priority: P2
created: 2026-05-05
updated: 2026-05-05
owner: pproctor

plan_root: plans/cursor/s1b/feat-f007-guided-walkthroughs/
intended_branch: cursor/s1b/feat/f007-guided-walkthroughs
parent_plan: plans/cursor/s1b/

target_repos:

- finance_manager_api
- finance_manager_web

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
    - Tour completion API smoke if persisted server-side
  notes: Per-page tours; library choice per F-007 (react-joyride, intro.js, etc.).

## standalone: true

standalone_notes: ""

# F-007 — Guided page walkthroughs

**Feature idea:** `[../../FEATURE_IDEAS.md](../../FEATURE_IDEAS.md)` (F-007).

## 0) Strategic Inheritance

- **Wedge respected:** yes — education reduces support load for thin-margin persona.
- **Locked decisions touched:** none at open.
- **Cost cap impact:** tour content static weight minimal.
- **Validation gates affected:** W3 onboarding quality.

## 1) Objective

Replace single popup with **per-page** and **per-widget** guided tours; persist completion state per user.

## 2) Scope

### In scope

- Tour framework integration; step definitions for dashboard, transactions, upcoming, settings; API for completion flags if not local-only.

### Out of scope

- Full LMS; video hosting (links only v1).

## 3) Source Evidence

- `[../../FEATURE_IDEAS.md](../../FEATURE_IDEAS.md)` §F-007.

## 4) Phase Plan or Task List

Framework → 1–2 pilot pages → expand catalog.

## 5) Execution Order

Framework first; then highest-friction pages (dashboard, transactions).

## 6) Verification Gates

- a11y (focus trap, skip); no tour loop on revisit when completed.

## 7) Documentation Sync Required

- Web changelog; optional help center links.

## 8) Strategic Phase Impact

Registry on completion.

## 9) Completion Criteria

- ≥3 pages with tours + completion persistence policy documented.

## 10) Risks and Rollback


| Risk                  | Trigger           | Rollback               | Owner |
| --------------------- | ----------------- | ---------------------- | ----- |
| Tours block PWA shell | z-index / overlay | Disable tours via flag | web   |
