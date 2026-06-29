---
logged: 2026-06-29
agent: cursor
plan_context: PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29 / full-suite verification
status: unreviewed
severity_guess: medium
---

## What was found

A subset of support-ticket tests fail locally with
`RuntimeError: Retry limit exceeded while trying to reconnect to the Celery result
store backend` whenever Redis is not running. 24 tests failed in a full local
`uv run pytest` run (318 passed); all 24 are in the four support test modules below.

Root cause is **not** the observability middleware (its Redis error is caught and
logged at `observability.py:35`). It is the support view calling
`notify_operator.delay(...)` and `send_user_support_confirmation.delay(...)` during the
request. With Redis down, Celery's **result backend** runs `consume_from(task_id)` and
raises after exceeding its reconnect retry limit, which bubbles into the HTTP response
and turns an expected `201` into a failure.

The project already ships `finance/tests/support_test_helpers.py`
(`patch_all_support_delays` / `patch_support_notify_delay`) precisely to run notify
synchronously without a broker — but these four modules do **not** use it and do not
enable eager Celery. `conftest.py` only seeds RNG; it does not set
`CELERY_TASK_ALWAYS_EAGER`. CI passes because `api-ci.yml` provides a `redis:7` service
container, so the gap is invisible there and only bites local (no-Redis) runs.

Failing modules:
- `finance/tests/test_support_adversarial.py`
- `finance/tests/test_support_logs.py`
- `finance/tests/test_support_simulator.py`
- `finance/tests/test_support_stress.py`

## Where

- `finance/views/support_views.py:52` and `:62` — `notify_operator.delay(...)` (and
  `send_user_support_confirmation.delay(...)` at `:75`) reached during the request.
- `finance/utils/observability_store.py:8-15` — module-level `import redis` + cached
  `redis.from_url(...)` client (separate, swallowed failure path).
- `conftest.py` — seeds RNG only; no `CELERY_TASK_ALWAYS_EAGER` / eager-propagates.
- `finance_api/settings.py:87,420-421` — broker + result backend default to
  `redis://localhost:6379/0`.
- `.github/workflows/api-ci.yml:19-28` — CI `redis:7` service masks the gap.

## What agent was doing

Running the full API test suite as part of bill-recurrence-engine (T01–T03)
verification. The bill-recurrence and expense tests themselves pass (37 expense + 19
recurrence green); these support failures are pre-existing and unrelated to the cadence
work.

## Why outside scope

Out of scope for the bill-recurrence cadence plan (support/notify + test-infra), and
HitM directed parking the repair: not relevant to today's dev cycle.

## Possible owner

Cursor (API test-infra / support-notify hardening) — schedule as its own small chore
branch/PR, not folded into the bill-recurrence plan.

## Notes

Recommended repair when picked up (two parts):
1. **Test infra:** set eager Celery suite-wide in `conftest.py`
   (`settings.CELERY_TASK_ALWAYS_EAGER = True`, `CELERY_TASK_EAGER_PROPAGATES = False`),
   or retrofit the four modules to use `patch_all_support_delays`. This removes the live
   Redis dependency from request-path tests (matches the existing helper's intent).
2. **Production hardening (optional but recommended):** wrap the support-view
   `.delay(...)` calls so a Redis/broker outage cannot 500 a user's bug/feature
   submission — a transient broker blip should not fail support intake (F-012 durable
   queue intent).

Local note: `redis-cli` is not installed and nothing listens on `:6379` on this dev
box; for ad-hoc local full-suite runs, `podman run -d -p 6379:6379 redis:7` (or the
project `scripts/fm_docker.sh`) unblocks without code changes.
