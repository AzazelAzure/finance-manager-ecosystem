# T02 — Recurrence Engine Rework (cadence-driven)

## End State

`finance/logic/bill_recurrence.py` advances bill due dates from the explicit `cadence` field,
not from `start_date`/`due_date` deltas. The `relativedelta(months=1)` inference fallback is
gone. `advance_bill_due_date(bill, periods)` and `periods_behind(bill, today)` keep their
signatures so `updaters.py` does not change in this task.

## Acceptance Criteria

1. [V1] `bill_interval_step(bill)` returns the interval for the bill's cadence: weekly=+7d, biweekly=+14d, monthly=+1 calendar month, quarterly=+3 calendar months, annual=+1 calendar year, custom=+`custom_interval_days`.
2. [V1] `semimonthly` advances to the next half-month anchor (e.g. 1st ↔ 15th), not a fixed 15-day step. A bill due the 15th rolls to the 1st of next month; due the 3rd rolls to the ~18th, preserving a stable two-per-month rhythm.
3. [V1] `advance_bill_due_date` and `periods_behind` keep their current signatures and the `MAX_CATCH_UP_PERIODS` cap.
4. [V1] No code path reads `start_date`/`due_date` deltas to determine cadence.
5. [V1] Unit tests cover each cadence including semimonthly edge cases (month-end, Feb, leap year) and `custom`.

## Scope Lock

### Files to modify
- `finance_manager_api/finance/logic/bill_recurrence.py`

### Files to create
- `finance_manager_api/finance/tests/test_bill_recurrence.py` (or extend existing recurrence test module if present)

### Files NOT to touch
- `updaters.py` (its call site is unchanged; wiring/validation belongs to T03)
- `models.py` (done in T01)

## Slices

### T02.SL1 — Cadence → step resolution

Replace `bill_interval_timedelta` with cadence-driven logic:

```python
def bill_interval_step(bill):
    c = bill.cadence
    if c == "weekly":      return timedelta(days=7)
    if c == "biweekly":    return timedelta(days=14)
    if c == "monthly":     return relativedelta(months=1)
    if c == "quarterly":   return relativedelta(months=3)
    if c == "annual":      return relativedelta(years=1)
    if c == "custom":      return timedelta(days=bill.custom_interval_days or 30)
    # semimonthly handled separately — see SL2
    raise ValueError(f"unknown cadence {c!r}")
```

### T02.SL2 — Semimonthly advance

Semimonthly is not a fixed delta. Implement `_advance_semimonthly(due)`:
- If day ≤ 15 → move to day 15 of the same month (if currently <15) or to day 1 of next month (if currently 15).
- Anchor pair defaults to {1, 15}; if the bill's `due_date` day is neither, snap to the nearest of the two anchors on first advance, then alternate.
- Clamp for short months (no 30th/31st issues since anchors are 1 and 15).

Document the chosen anchor rule in a docstring — this is the one place the behavior is a product decision.

### T02.SL3 — advance + catch-up

`advance_bill_due_date(bill, periods)` applies the cadence step `periods` times (calling the
semimonthly path when `cadence == semimonthly`). `periods_behind(bill, today)` walks forward
in cadence steps until `due_date >= today` or the cap is hit. Remove the old
`add_interval_to_date` delta loop or refactor it to call `bill_interval_step`.

### T02.SL4 — Tests

Cover: each cadence's single advance; multi-period catch-up; the cap; month-end and leap-year
for monthly/quarterly/annual; semimonthly 1↔15 alternation and a non-anchor start day; custom
with a valid and a missing `custom_interval_days` (missing → defensive default, but T03
validation should prevent missing in practice).

## Notes

- Keep `relativedelta` for monthly/quarterly/annual (correct calendar math); use `timedelta` only for fixed-day cadences.
- The function name change (`bill_interval_timedelta` → `bill_interval_step`) is internal; grep for other callers before renaming and update them, but the public `advance_bill_due_date`/`periods_behind` API is frozen for this task.
