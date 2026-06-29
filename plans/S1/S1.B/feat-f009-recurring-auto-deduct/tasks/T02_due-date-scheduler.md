# T02 — Due-Date Evaluation Scheduler (Celery beat)

## End State

A daily Celery beat task evaluates bills that are due (per profile timezone) with `auto_deduct`
on and a `source` set, and posts/stages a transaction drawing that source — idempotently, using
the T01 dedup key. On settlement it advances the bill via the existing cadence-driven recurrence
path. A retry of the same occurrence never double-posts.

## Acceptance Criteria

1. [V1] New `@shared_task` in `finance/tasks/` registered in the beat schedule (`finance_api/celery.py`), following the existing task conventions (balance_snapshots / usage_rollup pattern).
2. [V1] Task selects `UpcomingExpense` where `auto_deduct=True`, `source` not null, and the occurrence is due **today in the profile's timezone** (use profile TZ, not server TZ).
3. [V1] For each due occurrence it creates the transaction via the **standard transaction-create contract** (no bespoke insert path), stamped with the T01 `auto_deduct_key`. A duplicate key is a no-op (caught + logged, not an error).
4. [V1] After posting, the bill's paid-state + next due date advance through the existing `updaters.py` / `bill_recurrence.advance_bill_due_date` path (cadence-driven, shipped 2026-06-29). No new due-date arithmetic.
5. [V1] `test_celery_task_registration` passes with the new task; the registration test is updated to expect it.
6. [V1] Tests: due-today posts once; a second run of the same day is a no-op (idempotent); `auto_deduct=False` bills are skipped; bill with no `source` is skipped (defensive — T01 prevents the state).

## Scope Lock

### Files to modify / create
- `finance_manager_api/finance/tasks/auto_deduct.py` (new `@shared_task`)
- `finance_manager_api/finance_api/celery.py` — beat schedule entry
- `finance_manager_api/finance/tests/test_auto_deduct.py` (new)
- `finance_manager_api/finance/tests/test_celery_task_registration.py` — add the new task

### Files NOT to touch
- Serializer/model (T01), web (T03)

## Slices

### T02.SL1 — Task skeleton + selection query
Write the task; query due-today-in-profile-TZ auto-deduct bills. Reuse profile timezone handling
already used by `_handle_upcoming` / balance snapshots.

### T02.SL2 — Idempotent post + settlement
Post via the standard transaction-create contract with the dedup key; on success run the existing
settlement/advance path. Wrap the post in a try that treats a duplicate-key IntegrityError as a
logged no-op.

### T02.SL3 — Beat registration + tests
Add the beat schedule entry (daily, early in profile-day window); update the registration test;
write the idempotency + boundary tests.

## Notes

- **Reuse, don't reinvent:** the beat infra (`finance/tasks/*`, `celery-worker`/`celery-beat` containers) is live from F-014. Add a task; do not stand up new infrastructure.
- **Double-spend is the headline risk** (plan §10). The T01 unique key is the guard; this task must route every post through it.
- Holidays/skipped-day handling is **T04** — keep this task to the straight due-today path.
- Client-led offline replay (PWA outbox) is **not** this task — server-side beat is the v1 mechanism. If a client path is added later it must reuse the same dedup key (locked decision D2).
