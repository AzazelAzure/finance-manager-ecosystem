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

## Closeout addendum — 2026-06-28

HitM accepted F-014 as complete for the closed-loop beta after the VPS was
updated to latest `main`, rebuilt on inactive **green**, smoked, and switched
active `blue -> green`. Public web and API health endpoints returned `200`, and
the `fm-beta` stack now includes shared `celery-worker` and `celery-beat`
containers.

The closeout decision explicitly does not require secret rotation or additional
Proton inbox screenshots during this one-tester beta window. Pre-fix leaked
compose output logs were scrubbed, terminal history was cleared, and
`scripts/fm_server_beta.sh` now redacts compose output across rebuild, smoke,
switch, and log paths.
