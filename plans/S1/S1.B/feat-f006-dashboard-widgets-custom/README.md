---
plan_id: PLAN_CROSS_DASHBOARD_WIDGETS_F006_2026-05-05
status: draft
priority: P2
created: 2026-05-05
updated: 2026-05-21
owner: pproctor

plan_root: plans/S1/S1.B/feat-f006-dashboard-widgets-custom/
intended_branch: cursor/s1b/feat/f006-dashboard-widgets-custom
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
    - Dashboard layout persistence smoke
  notes: Layout API must survive PWA offline policy — prefer server-backed layout with cache fallback documented in tasks.

standalone: true
standalone_notes: ""
---

# F-006 — Customizable dashboard widgets

**Feature idea:** [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) (F-006).

## Task and slice IDs

Per [`governance/plan_template.md`](../../../../governance/plan_template.md) **§1a Task slices (T##.SL#)** and [`governance/branching_guidelines.md`](../../../../governance/branching_guidelines.md): decompose execution into **tasks** (`T##`, with task branch `…/t##-<slug>` when shipping code) and **slices** (`T##.SL#`). **`SL`** avoids collision with Phase/Stage **S** notation (`S1`, `S1.B`). Default one slice per **web route/page** or per **API model/viewset seam**; do not assign whole-product scope to a single agent pass unless the touched surface is trivially small. Executors must **ask clarifying questions** when acceptance criteria or contracts are underspecified instead of guessing.

## 0) Strategic Inheritance

- **Wedge respected:** yes — STS-first layout for mobile persona.
- **Locked decisions touched:** none at open.
- **Cost cap impact:** API storage for layout bounded per user.
- **Validation gates affected:** W3 polish.

## 1) Objective

User-selectable widgets, reorder, resize tiers, persist per user (API), optional separate mobile/desktop layouts.

## 2) Scope

### In scope

- Persistence model + API; drag/drop or equivalent; widget catalog.
- **Global brand / shell icons** (favicon, header mark, PWA manifest): follow **F-011** and ecosystem asset path **`resources/hfm_icon_web/`** — F-006 does not own the primary icon pack; avoid diverging copies in widget chrome without updating F-011.

### Out of scope

- Third-party widget marketplace; full Notion-style freeform canvas v1.

## 3) Source Evidence

- [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) §F-006.

## 4) Phase Plan or Task List

TBD: catalog → persistence → DnD → mobile variant.

## 5) Execution Order

Persistence before DnD to avoid lost local-only work.

## 6) Verification Gates

- Migration + API tests; a11y on drag handles; PWA offline read path defined.

## 7) Documentation Sync Required

- Changelogs; i18n for new controls.

## 8) Strategic Phase Impact

Registry on completion.

## 9) Completion Criteria

- Ship with ≥N default widgets + user persistence verified.

## 10) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
| ---- | ------- | -------- | ----- |
| Layout migration breaks dashboard | bad default | Server-side reset endpoint; flag | api |
