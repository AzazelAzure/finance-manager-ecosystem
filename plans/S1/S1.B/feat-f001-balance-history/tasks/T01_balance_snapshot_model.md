---
task_id: T01
status: paused
owner: pproctor
phase: S1.B
intended_branch: cur/s1b/feat/f001-balance-history/t01-balance-snapshot-model
last_verification: null
---

# T01 — BalanceSnapshot model & migration

## End state

`BalanceSnapshot` exists in the API schema: one row per user payment source per calendar day, storing the day-end closing balance in the source's native currency. Migrations apply cleanly; model is registered for admin inspection.

## Acceptance criteria

1. [V1] `BalanceSnapshot` model with fields: `uid`, `source`, `snapshot_date`, `closing_balance`, `currency`, `created_at`
2. [V1] Unique constraint on `(uid, source, snapshot_date)`
3. [V1] `BalanceSnapshotManager.for_user(uid)` and `in_date_range(start, end)` queryset helpers
4. [V1] Migration applies on a fresh DB. **Use the next free migration number after F004's** (F004 committed `0012_appprofile_pay_cycle_fields`; F001 must be `0013_*` or later to avoid a duplicate `0012` leaf — confirm the highest migration on the feature branch at implementation time). A merge migration may be required when both features integrate to `main`.
5. [V1] Unit tests cover model creation and unique-constraint enforcement

## Slice decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T01.SL1 | Model + manager | V1 | Add `BalanceSnapshot` to `finance/models.py`; manager in `finance/management/managers.py` |
| T01.SL2 | Migration + admin | V1 | Generate migration (next free number ≥`0013`, after F004); register in `admin.py` |
| T01.SL3 | Model tests | V1 | `finance/tests/balance_tests/test_balance_snapshot_model.py` |

## Scope lock

### In scope

- `finance_manager_api/` only
- Model, manager, migration, admin registration, model-level tests

### Out of scope

- Population/backfill logic (T02)
- Read API endpoint (T03)
- Web chart (T04)

## Evidence

- `evidence/T01.SL3_pytest.txt` — pytest output for model tests

## Anti-patterns

- Do NOT add Celery tasks or API views in this task
- Do NOT store per-transaction rows — day-end granularity only
- Do NOT convert to base currency at write time; store native `currency` + `closing_balance` (conversion at read in T03)
