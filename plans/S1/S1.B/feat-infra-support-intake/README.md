---
plan_id: PLAN_CROSS_SUPPORT_INTAKE_2026-05-21
status: completed
priority: P2
created: 2026-05-21
updated: 2026-06-28
owner: teamwork_preview_worker_f012

plan_root: plans/S1/S1.B/feat-infra-support-intake/
intended_branch: agy/s1b/feat/infra-support-intake
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
    - POST intake endpoint returns expected contract (authz, validation errors)
  notes: Outbound email or webhook to ticketing may touch `deploy/` secrets — document in tasks; no secrets in client bundles.

standalone: true
standalone_notes: ""
---

# F-012 — Bug reports & feature requests (support intake)

**Feature idea:** [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) (F-012).

## Task and slice IDs

Per [`governance/plan_template.md`](../../../../governance/plan_template.md) **§1a Task slices (T##.SL#)** and [`governance/branching_guidelines.md`](../../../../governance/branching_guidelines.md): decompose execution into **tasks** (`T##`, with task branch `…/t##-<slug>` when shipping code) and **slices** (`T##.SL#`). **`SL`** avoids collision with Phase/Stage **S** notation (`S1`, `S1.B`). Default one slice per **web route/page** or per **API model/viewset seam**; do not assign whole-product scope to a single agent pass unless the touched surface is trivially small. Executors must **ask clarifying questions** when acceptance criteria or contracts are underspecified instead of guessing.

## 0) Strategic Inheritance

- **Wedge respected:** yes — lowers friction for thin-margin users reporting breakage; keeps support humane.
- **Locked decisions touched:** privacy / retention; optional overlap with **F-010** export if attachments allowed.
- **Cost cap impact:** email/API volume bounded (rate limits, size caps).
- **Validation gates affected:** beta / PWA exit support readiness (non-blocking unless gates updated).

## 1) Objective

Ship **first-class in-app intake** for **bugs** (all targeted beta users) and **feature requests** (**beta-only** for now: gated in web + API so production outside tight beta does not expose the feature-request path). Structured payloads, authenticated user context, a **durable API queue** (DB or equivalent) for triage—not email as the only store—and a reliable operator delivery path (mechanism chosen in T01). Each stored row should include **`AppProfile.user_id`** so operators can open **F-013** per-user diagnostic log files on the VPS.

## 2) Scope

### In scope

- Web: forms or modal flows; client-side validation; optional screenshot upload with size/type limits; **feature request UI/API behind a beta flag** (env or server-driven config).
- API: **persistence model** (queue table or forward-only store), auth, rate limiting, redaction of secrets in text fields; fields aligned with `design_docs/.../15_Beta_Week_Incident_Triage...` envelope where practical (`incident_id`, `report_type`, severity, etc.).
- Operator path: durable store + notification; optional GitHub Issue creation, Linear, or email — **decide in T01**.

### Out of scope

- Public roadmap voting; full Zendesk-style helpdesk; anonymous submissions without abuse controls.

**PWA class:** **B** — online-only (support forms require authenticated API POST).

## Verification (2026-06-26)

- Local: 20 API tests pass (`test_support*`, `test_f013_verification`, `test_notify`, `test_usage_rollup`).
- F-014 replaces synchronous bug email with async `[FM-NOTIFY]` dispatcher (UUID-only).

## Live closeout (2026-06-28)

- HitM accepted F-012 as complete for the closed-loop beta.
- VPS promoted latest `main` to active **green** after a blue/green rebuild; public web and API health endpoints returned `200`.
- Shared `celery-worker` and `celery-beat` containers are running in the `fm-beta` stack, resolving the 2026-06-26 VPS gap for support digest / notify execution.
- Secret-redaction follow-up completed before closeout: pre-fix leaked compose output logs were scrubbed, and `scripts/fm_server_beta.sh` now redacts compose output during rebuild/smoke/switch paths.

## 3) Source Evidence

- [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) §F-012.

## 4) Phase Plan or Task List

- `T01`: Support ticket Django model, migrations, API POST view, and validation.
- `T02`: Celery weekly feature request digest task & SMTP config.
- `T03`: Frontend Support navigation & Page implementation.
- `T04`: Docker deployment configurations (Celery services & shared volumes).

## 5) Execution Order

T01 & T02 (Backend features and migrations) and T03 (Frontend UI) can be developed in parallel, but T04 (Docker deployment configurations) must be executed after both backend and frontend are ready.

## 6) Verification Gates

- Authz tests (user A cannot read user B submissions).
- Redaction tests (no raw tokens in stored body).
- Load: rate limit verified under burst.

## 7) Documentation Sync Required

- API + web changelogs; `deploy/` or runbook if new secrets; privacy policy clause if retention stated.

## 8) Strategic Phase Impact

Registry `completed` when intake is live and operators can process tickets on a defined cadence.

## 9) Completion Criteria

- Production path from app → **persisted** operator queue (queryable, not email-only) with documented triage SLA (even if “best effort”); bug path always available to beta cohort; feature-request path only when beta flag is on.

## 10) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
| ---- | ------- | -------- | ----- |
| PII spill in email body | misconfigured template | Disable outbound; purge queue per policy | ops |
