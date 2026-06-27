---
plan_id: PLAN_CROSS_USAGE_MONITORING_NOTIFY_2026-06-26
status: in_progress
priority: P1
created: 2026-06-26
updated: 2026-06-27
owner: pproctor

plan_root: plans/S1/S1.B/feat-f014-usage-monitoring-notify/
intended_branch: cur/s1b/feat/f014-usage-monitoring-notify
target_repos:
  - finance_manager_api

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on:
  - PLAN_CROSS_SUPPORT_INTAKE_2026-05-21
  - PLAN_CROSS_USER_ACTIVITY_LOGS_2026-05-21
blocks: []
parallel_safe_with:
  - PLAN_CROSS_UI_UX_DESIGN_SYSTEM_2026-06-26
  - PLAN_CROSS_API_SECURITY_HARDENING_2026-06-26
conflicts_with: []

manual_gates:
  pre_execution: required
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [api, celery_worker, celery_beat]
  bundle_required: false
  rollback_plan_id: null
  smoke_targets:
    - Celery worker receives and processes notify task within 30s of submission
    - Email arrives in Proton inbox with [FM-NOTIFY] subject prefix
    - GET /api/health/ still passes after Celery wiring
  notes: >-
    Requires Redis to be operational before deploy. Verify `REDIS_URL` env var is set
    in the API container. Proton Bridge SMTP credentials must be in `.secrets/` or
    Django `EMAIL_*` env vars — never committed. HitM must confirm SMTP credentials
    path before T01 starts.

standalone: true
standalone_notes: ""
---

## 0) Strategic Inheritance

- **Wedge respected:** yes — usage data is the signal for when to flip the monetization switch; the pseudo-open beta strategy requires this to be visible
- **Locked decisions touched:** privacy (UUID-only, no PII in any stored or transmitted event); no third-party analytics (trust brand position locked)
- **Cost cap impact:** zero new SaaS — Proton Bridge SMTP is already provisioned; Redis/Celery are in the existing stack
- **Validation gates affected:** Dec 31 2026 pseudo-open beta growth checkpoint requires DAU/MAU data to exist; this plan is on the critical path for that gate

## 1) Objective

Two deliverables, one shared infrastructure layer:

1. **Operator notification channel:** A shared `notify_operator()` dispatcher (Celery async task) that formats and sends structured `[FM-NOTIFY]` emails via Proton Bridge SMTP. Zero PII — UUID references only. Structured plain-text body parseable by the local Cursor CLI agent. This upgrades F-012 bug reports from weekly digest to real-time notification on submission.

2. **Aggregate usage tracking:** Server-side daily rollup of DAU/MAU, invite chain depth, and active account count. No third-party analytics. Operator-only — not user-visible. Provides the data signal for the Dec 31 2026 pseudo-open beta monetization checkpoint.

**Pre-execution gate (required):** Executor must confirm:
- Redis is reachable from the API container (`redis-cli ping` returns PONG)
- Celery worker and beat are defined in `docker-compose.yml` (or confirm service exists)
- Proton Bridge SMTP credentials are available as env vars (ask HitM for `.secrets/` path)

## 2) Scope

### In scope
- Django email backend config (Proton Bridge SMTP: host, port, TLS, credentials)
- Celery task: `notify_operator(event_type, severity, user_ref, file_paths, notes)`
- Email format contract: `[FM-NOTIFY]` subject prefix, structured plain-text body (see §4 spec)
- F-012 integration: real-time notification on bug report POST (trigger `notify_operator` from existing SupportTicket signal or view)
- Aggregate models: `DailyUsageSnapshot` (date, dau_count, mau_count, active_accounts), `InviteChainEvent` (inviter_uuid, invitee_uuid, timestamp)
- Celery beat schedule: daily usage rollup task at UTC 00:05
- Usage threshold alerts: configurable thresholds (10, 50, 100 DAU) → trigger `notify_operator` when crossed

### Out of scope
- Web UI for usage data (ops-only; no user-facing dashboard for analytics)
- Third-party analytics integrations
- Real-time websocket push to operator
- User-visible invite chain UI (future plan)
- Any modification to F-012 intake forms or F-013 log file schema

## 3) Email Format Contract

Every notification sent through this system must conform to this envelope. The Cursor CLI agent on the local machine parses the `[FM-NOTIFY]` subject prefix to identify messages.

```
Subject: [FM-NOTIFY] {event_type} | SEV:{severity} | {ISO8601 timestamp}

Event: {event_type}
Severity: {severity}           # critical | high | medium | low | info
Timestamp: {ISO8601}
User-Ref: {uuid}               # AppProfile UUID — never username or email
Relevant-Files:
  - {file_path_1}              # VPS-absolute path or repo-relative path
  - {file_path_2}
Notes: {one-line human note}
---
Sent by finance_manager_api Celery notify worker.
No PII. User-Ref is pseudonymous UUID only.
```

**Severity mapping:**
| Source event | Severity |
|---|---|
| Bug report — critical flag | `critical` |
| Bug report — high flag | `high` |
| Bug report — medium/low | `medium` |
| Feature request submitted | `info` |
| DAU threshold crossed | `info` |
| Celery task failure | `high` |

**Relevant-Files guidance:** Always include the F-013 per-user log path (`/var/log/fm_api/users/{uuid}.log` or equivalent) when a user UUID is known. Include the affected Django view/model file when derivable from the report type. Do not include source files you are guessing — omit if unknown.

## 4) Phase Plan / Task List

| Task | File | Slices | Surface |
|------|------|--------|---------|
| **T01** | `tasks/T01_celery_email_backend.md` | T01.SL1–SL2 | Redis verify, Celery worker/beat confirm, Django email backend config |
| **T02** | `tasks/T02_notify_dispatcher.md` | T02.SL1–SL2 | `notify_operator()` Celery task, format, send, error handling |
| **T03** | `tasks/T03_f012_realtime_notify.md` | T03.SL1 | Wire dispatcher to F-012 SupportTicket post-save signal |
| **T04** | `tasks/T04_aggregate_usage_models.md` | T04.SL1–SL2 | `DailyUsageSnapshot` + `InviteChainEvent` models, migrations, daily beat task |
| **T05** | `tasks/T05_usage_thresholds.md` | T05.SL1 | Threshold check in daily rollup → `notify_operator` when crossed |

## 5) Execution Order

```
T01 (prerequisite — all other tasks blocked on this)
  → T02 (dispatcher ready — required by T03 and T05)
    → T03 (F-012 real-time notify — standalone once T02 ships)
    → T04 (aggregate models — parallel with T03)
      → T05 (threshold alerts — requires T04 models + T02 dispatcher)
```

T03 and T04 may proceed in parallel after T02 is merged.

**Hard rule:** `python manage.py check --deploy` must pass and all migrations must apply cleanly before any slice is marked PASS. No TS errors (web is not touched), no Django system check warnings.

## 6) Verification Gates

| Slice | Pass condition |
|-------|---------------|
| T01.SL1 | `redis-cli ping` → PONG from within API container; Celery worker process starts without error |
| T01.SL2 | `python manage.py sendtestemail {admin_email}` succeeds via Proton Bridge SMTP; email arrives in Proton inbox |
| T02.SL1 | `notify_operator.delay(...)` enqueues and Celery worker processes it within 30s; no exception in worker log |
| T02.SL2 | Email received with correct `[FM-NOTIFY]` subject prefix and body format matching §3 contract; UUID present, no PII fields |
| T03.SL1 | POST to bug report endpoint → email arrives within 60s; subject contains `BUG_REPORT` and correct severity; F-013 log path in Relevant-Files |
| T04.SL1 | `DailyUsageSnapshot` and `InviteChainEvent` migrations apply on clean DB; admin site shows both models |
| T04.SL2 | Celery beat fires daily rollup task at UTC 00:05; rollup writes one `DailyUsageSnapshot` row per day; no duplicate rows on re-run (idempotent) |
| T05.SL1 | Seeding DB with threshold-crossing DAU count triggers `notify_operator` call with `event_type=DAU_THRESHOLD_CROSSED`; duplicate alert not sent within 24h window |

## 7) Documentation Sync Required

- `governance/plan_registry.md`: move to In Progress on start; Completed on final merge
- `plans/S1/S1.B/feat-infra-support-intake/README.md`: add note that real-time notify is handled by F-014 dispatcher (no change to F-012 model)
- `strategy/current_status.md` §API: update with Celery/email notify operational (admin update — not executor scope)
- `CHANGELOG.md` [Unreleased] — `### Added` block: usage monitoring models, notify dispatcher; `### Changed`: F-012 bug reports now trigger real-time email

## 8) Strategic Phase Impact

When closing this plan, executor must:
- [ ] Confirm `python manage.py check --deploy` clean
- [ ] Confirm at least one real notification received in Proton inbox end-to-end
- [ ] Confirm `DailyUsageSnapshot` has at least one row from Celery beat rollup
- [ ] Update `governance/plan_registry.md` status to `completed`
- [ ] Post completion summary to IDE Chat including: SMTP config path used, Celery service name in docker-compose, sample notify email screenshot

## 9) Completion Criteria

- `[FM-NOTIFY]` emails arrive in Proton inbox on bug report submission (real-time, ≤60s)
- `DailyUsageSnapshot` populates daily via Celery beat; data available for Dec 31 growth checkpoint
- DAU threshold alerts fire once per threshold crossing per 24h window
- Zero PII in any stored model field, email body, or Celery task argument
- `python manage.py check --deploy` clean; all migrations applied
- PR created via `gh pr create`; HitM pre-merge gate cleared (confirm SMTP credentials path and Celery service name)

## 10) Risks and Rollback

| Risk | Trigger | Rollback action | Owner |
|---|---|---|---|
| Redis not operational | Celery task enqueue fails with connection error | Verify `REDIS_URL` env var; ensure Redis container is running; do not proceed until T01.SL1 passes | Cursor executor — stop at T01, ask HitM |
| Proton Bridge SMTP credentials missing | `sendtestemail` fails with auth error | HitM provides credentials path; store in `.secrets/` env file only; never commit | HitM gate at T01.SL2 |
| PII leaked in email body | Username or email appears in notify body | Audit all `notify_operator()` call sites; replace any PII field with UUID reference; purge sent emails | Cursor executor — zero tolerance |
| Celery beat duplicate rollup rows | Beat fires multiple times or task retries | Implement `update_or_create` on `DailyUsageSnapshot` keyed on `date`; verify idempotency in T04.SL2 | Cursor executor |
| F-012 signal fires but notify task fails silently | Bug reported but no email arrives | Celery task must log failure to Django logger; do NOT raise in signal handler (would break bug report submission) | Cursor executor |
