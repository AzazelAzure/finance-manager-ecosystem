---
task_id: T02
status: pending
owner: pproctor
phase: S1.B
intended_branch: cur/s1b/feat/f001-balance-history/t02-snapshot-population
last_verification: null
---

# T02 — Snapshot population (nightly job + backfill)

## End state

Day-end balances are computed from transaction history and persisted to `BalanceSnapshot`. A Celery beat task runs nightly (UTC 00:15) for all active users. A management command backfills historical rows from existing transactions.

## Acceptance criteria

1. [V1] `finance/logic/balance_snapshots.py` computes per-source closing balance as-of a date (sum transactions through that date in source currency)
2. [V1] `capture_balance_snapshots` Celery task writes yesterday's rows idempotently (upsert per uid/source/date)
3. [V1] Beat schedule entry registered and covered by existing `CELERY_BEAT_SCHEDULE` registration test
4. [V1] `python manage.py backfill_balance_snapshots [--uid UID] [--days N]` backfills from transaction history
5. [V1] Tests cover computation, idempotent upsert, and backfill for a seeded user

## Slice decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T02.SL1 | Balance computation helper | V1 | Pure logic: closing balance per source as-of date |
| T02.SL2 | Celery nightly task | V1 | `finance/tasks/balance_snapshots.py`; register in `finance/tasks/__init__.py` and `CELERY_BEAT_SCHEDULE` |
| T02.SL3 | Backfill command | V1 | `finance/management/commands/backfill_balance_snapshots.py` |
| T02.SL4 | Tests | V1 | `finance/tests/balance_tests/test_balance_snapshot_population.py` |

## Scope lock

### In scope

- `finance_manager_api/` only
- Computation, Celery task, management command, tests

### Out of scope

- Read API (T03)
- Web UI (T04)

## Evidence

- `evidence/T02.SL4_pytest.txt` — pytest output

## Anti-patterns

- Do NOT snapshot intraday — one row per calendar day per source
- Do NOT run VPS deploy from this task (V2 is feature-branch closeout)
