# F-014 Phase 1 + Implementation Verification — 2026-06-26

## Pre-implementation audit

- No `notify_operator`, usage models, or SMTP settings existed on `main`.
- F-012 already sent synchronous bug emails with PII (username/email) — reframed T03 as migration to async UUID-only notify.

## Implementation (branch `cur/s1b/feat/f014-usage-monitoring-notify`)

| Deliverable | Status |
|-------------|--------|
| `EMAIL_*` + `OPERATOR_NOTIFY_EMAIL` settings | Done |
| `notify_operator` Celery task + `[FM-NOTIFY]` format | Done |
| F-012 bug path → `notify_operator.delay()` | Done |
| `DailyUsageSnapshot` / `InviteChainEvent` / `OperatorAlertState` + migration `0010` | Done |
| Daily rollup beat UTC 00:05 + DAU threshold alerts | Done |
| Tests (`test_notify`, `test_usage_rollup`) | **20 tests OK** (combined suite) |

## VPS / ops (still required for live notify)

1. Start `celery-worker-blue` (or shared worker) + `celery-beat` on VPS.
2. Set `EMAIL_*` + `OPERATOR_NOTIFY_EMAIL` in server env (Proton Bridge).
3. Apply migration `0010_usage_monitoring_f014` on deploy.

## End-to-end email proof

Not run on VPS in this session (no SMTP credentials in agent environment). Use `python manage.py sendtestemail` on VPS after env wiring.
