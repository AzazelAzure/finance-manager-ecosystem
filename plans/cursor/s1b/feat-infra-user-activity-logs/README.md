---
plan_id: PLAN_CROSS_USER_ACTIVITY_LOGS_2026-05-21
status: draft
priority: P2
created: 2026-05-21
updated: 2026-05-21
owner: pproctor

plan_root: plans/cursor/s1b/feat-infra-user-activity-logs/
intended_branch: cursor/s1b/feat/infra-user-activity-logs
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
    - Activity log list endpoint paginates; only self visible
  notes: Coordinate event emission with PWA/offline flows so client-side failures can be logged when back online without duplicating server rows.

standalone: true
standalone_notes: ""
---

# F-013 — Per-user activity & diagnostic logs (top-level)

**Feature idea:** [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) (F-013).

## 0) Strategic Inheritance

- **Wedge respected:** yes — transparency for “what happened on my account” builds trust during rough beta.
- **Locked decisions touched:** logging redaction policy; alignment with **F-012** if support asks user to paste log IDs.
- **Cost cap impact:** retention TTL + index size; batch prune job.
- **Validation gates affected:** optional PWA D4 support checklist item when logs include offline replay events.

## 1) Objective

Expose a **top-level** (shell) **user-visible** timeline of security-relevant and diagnostic events for **that user only**, complementing—not replacing—transaction and server-only ops logs.

## 2) Scope

### In scope

- Event taxonomy: login/session, settings changes, failed API writes, PWA sync milestones (as defined with PWA owners), explicit “support bundle” correlation id optional.
- API: append-only or insert-only store, pagination, filters; export line items may defer to **F-010**.
- Web: “Activity” or “Security & logs” entry in shell nav; mobile-friendly list.

### Out of scope

- Full SIEM; cross-user admin search (separate future ops tool unless explicitly added later); raw HTTP trace replay.

## 3) Source Evidence

- [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) §F-013.
- Existing API redaction / logging modules.

## 4) Phase Plan or Task List

T01 event schema + privacy review → T02 API + writer hooks from auth/settings/mutation paths → T03 web shell page → T04 retention job + metrics.

## 5) Execution Order

Schema + writer contracts before UI to avoid empty screens changing shape.

## 6) Verification Gates

- Isolation tests: user A never sees user B events.
- Volume test: pagination stable at max retention window.

## 7) Documentation Sync Required

- Changelogs; user-facing help blurb; design_docs if retention affects encryption story.

## 8) Strategic Phase Impact

Registry completion; may reference in support runbook for founding beta.

## 9) Completion Criteria

- Live self-service log view + documented retention; hooks for at least three event categories.

## 10) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
| ---- | ------- | -------- | ----- |
| Accidental PII in event payload | developer logging | Strip field; hotfix writer | api |
