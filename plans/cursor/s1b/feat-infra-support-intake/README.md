---
plan_id: PLAN_CROSS_SUPPORT_INTAKE_2026-05-21
status: draft
priority: P2
created: 2026-05-21
updated: 2026-05-21
owner: pproctor

plan_root: plans/cursor/s1b/feat-infra-support-intake/
intended_branch: cursor/s1b/feat/infra-support-intake
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
    - POST intake endpoint returns expected contract (authz, validation errors)
  notes: Outbound email or webhook to ticketing may touch `deploy/` secrets — document in tasks; no secrets in client bundles.

standalone: true
standalone_notes: ""
---

# F-012 — Bug reports & feature requests (support intake)

**Feature idea:** [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) (F-012).

## 0) Strategic Inheritance

- **Wedge respected:** yes — lowers friction for thin-margin users reporting breakage; keeps support humane.
- **Locked decisions touched:** privacy / retention; optional overlap with **F-010** export if attachments allowed.
- **Cost cap impact:** email/API volume bounded (rate limits, size caps).
- **Validation gates affected:** beta / PWA exit support readiness (non-blocking unless gates updated).

## 1) Objective

Ship **first-class in-app intake** for bugs and feature ideas with structured payloads, authenticated user context, and a reliable operator delivery path (mechanism chosen in T01).

## 2) Scope

### In scope

- Web: forms or modal flows; client-side validation; optional screenshot upload with size/type limits.
- API: persistence model (or forward-only queue), auth, rate limiting, redaction of secrets in text fields.
- Operator path: at minimum durable store + notification; optional GitHub Issue creation, Linear, or email — **decide in T01**.

### Out of scope

- Public roadmap voting; full Zendesk-style helpdesk; anonymous submissions without abuse controls.

## 3) Source Evidence

- [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) §F-012.

## 4) Phase Plan or Task List

T01 delivery mechanism + threat model → T02 API + migrations → T03 web UI → T04 operator runbook + smoke.

## 5) Execution Order

T01 before schema to avoid rework on wrong integration.

## 6) Verification Gates

- Authz tests (user A cannot read user B submissions).
- Redaction tests (no raw tokens in stored body).
- Load: rate limit verified under burst.

## 7) Documentation Sync Required

- API + web changelogs; `deploy/` or runbook if new secrets; privacy policy clause if retention stated.

## 8) Strategic Phase Impact

Registry `completed` when intake is live and operators can process tickets on a defined cadence.

## 9) Completion Criteria

- Production path from app → operator queue with documented triage SLA (even if “best effort”).

## 10) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
| ---- | ------- | -------- | ----- |
| PII spill in email body | misconfigured template | Disable outbound; purge queue per policy | ops |
