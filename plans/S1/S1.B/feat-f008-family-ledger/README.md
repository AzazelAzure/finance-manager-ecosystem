---
plan_id: PLAN_CROSS_FAMILY_LEDGER_F008_2026-05-05
status: draft
priority: P2
created: 2026-05-05
updated: 2026-05-05
owner: pproctor

plan_root: plans/S1/S1.B/feat-f008-family-ledger/
intended_branch: cursor/s1b/feat/f008-family-ledger
parent_plan: plans/S1/S1.B/

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
    - Invite / role smoke when auth model exists
  notes: High privacy / consent / ZK posture risk — early tasks must produce threat model before wide build.

standalone: true
standalone_notes: ""
---

# F-008 — Family ledger (household / multi-person)

**Feature idea:** [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) (F-008).

## 0) Strategic Inheritance

- **Wedge respected:** yes — PH household money pooling.
- **Locked decisions touched:** auth, encryption, data residency assumptions — **design-docs-sync mandatory** before S1.C-scale invite.
- **Cost cap impact:** none if single-tenant DB pattern; avoid new infra.
- **Validation gates affected:** may be post–S1.C depending on scope; note in registry when narrowed.

## 1) Objective

Household-scoped visibility: shared bills/goals, roles (viewer vs editor), audit-friendly activity, starting narrow per F-008 notes.

## 2) Scope

### In scope

- Phased MVP definition in tasks (e.g. invite viewer + shared upcoming list **or** richer model — pick in T01).
- API + web only after auth/permission spec is written.

### Out of scope

- Full joint tax filing; minor accounts without legal review.

## 3) Source Evidence

- [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) §F-008.
- `design_docs/00_Encryption_Strategy.md` and auth docs.

## 4) Phase Plan or Task List

T01 threat model + MVP scope → T02 schema/auth → T03 API → T04 web.

## 5) Execution Order

Security spec before schema.

## 6) Verification Gates

- Permission matrix tests; no leakage across households in integration tests.

## 7) Documentation Sync Required

- design_docs + changelogs; privacy policy touch if invites collect PII.

## 8) Strategic Phase Impact

Registry; may move to S1.C if scope grows.

## 9) Completion Criteria

- MVP shipped per T01 lock-in + tests green.

## 10) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
| ---- | ------- | -------- | ----- |
| AuthZ bug | cross-household read | Disable invites; revoke tokens | api |
