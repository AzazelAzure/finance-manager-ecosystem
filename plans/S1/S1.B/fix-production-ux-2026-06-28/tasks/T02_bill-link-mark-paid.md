# T02 — Bill Linking: Mark Paid + Overdue Recovery

## ⚠️ HitM Gate — Required Before T02.SL3

**Question:** How should recurring bill due dates advance during catch-up?

- **Option A:** Calendar month — always advance by 1 month per period
- **Option B:** Original interval — advance by the number of days between `start_date` and `due_date`
- **Option C:** Next 1st or 15th of month — snap to nearest semi-monthly anchor

Post answer in Cursor chat before starting T02.SL3. Default to **Option A** if no answer received within 24h.

---

## End State

**Bug A resolved:** Selecting an upcoming bill in the quick add expense form and submitting marks that bill's `paid_flag = True` in the database.

**Bug B resolved:** An overdue recurring `UpcomingExpense` record shows a "Mark paid + advance" action. Confirming it marks the bill paid and advances `due_date` to the next period. If multiple periods are missed, a bulk catch-up option appears (max 24 periods).

## Acceptance Criteria

**Bug A:**
1. [V1] POST to transaction endpoint with `upcoming_expense_id` param → `UpcomingExpense.paid_flag` is `True` in DB
2. [V1] API test asserts the above; test is part of the existing test suite and passes in CI
3. [V3] Quick add form — select a bill, submit → bill disappears from upcoming expenses list (marked paid)

**Bug B:**
4. [V3] Bill whose `due_date` is in the past shows "Mark paid + advance" button on the bill card
5. [V3] Confirming single mark-paid → bill's `paid_flag = True`; new `due_date` advanced to next period
6. [V3] Bill with 2+ missed periods shows bulk catch-up option with period count displayed
7. [V3] Bulk catch-up with 3 missed periods → all 3 created/marked paid; `due_date` advances to current/next period
8. [V1] Bulk catch-up hard-capped at 24 periods — confirmed in API logic, not just frontend

## Scope Lock

### Files to modify (API)
- Transaction create/update view or serializer — accept optional `upcoming_expense_id`; mark bill paid on save
- `UpcomingExpense` model or manager — add `advance_due_date(periods: int)` or equivalent helper
- New API endpoint or action for bill catch-up (if catch-up logic is complex, a dedicated action on UpcomingExpense viewset is cleaner than stuffing it in the transaction endpoint)
- Test file for the above

### Files to modify (Web)
- Quick add form — ensure bill selection sends `upcoming_expense_id` in POST body
- Upcoming expenses list/card component — add "Mark paid + advance" action for overdue bills
- Bulk catch-up modal/confirmation — period count, confirm button, max 24 cap display

### Files NOT to touch
- `UpcomingExpense.is_recurring` business logic beyond `due_date` advancement
- Any unrelated transaction logic
- Calendar or scheduling views

## Slices

### T02.SL1 — Audit: where does bill ID get dropped?
- Trace the quick add form submit: does it send `upcoming_expense_id` in the request body?
- Trace the API transaction endpoint: does it accept and act on `upcoming_expense_id`?
- Output: a clear statement of which side is the bug (or both). Confirm in T02.SL1 evidence note before proceeding.

### T02.SL2 — API fix: mark bill paid on transaction create
- Add `upcoming_expense_id` (optional) to transaction create serializer
- On create: if present, fetch `UpcomingExpense` by ID and set `paid_flag = True`
- Add API test: `POST /finance/transactions/ {upcoming_expense_id: X}` → `UpcomingExpense(id=X).paid_flag == True`
- CPPR (api only)

### T02.SL3 — Web fix: send bill ID from quick add (requires T02.SL1 findings)
- Ensure quick add form sends `upcoming_expense_id` when a bill is selected
- Update after linked bill submit: remove/update bill from upcoming list optimistically or refetch
- Evidence: [V3] screenshot of quick add submit → bill marked paid in upcoming expenses list

### T02.SL4 — Overdue bill recovery UI
- Add "overdue" detection to bill card: `due_date < today && paid_flag == false`
- Overdue card shows: "Mark paid + advance" button
- On confirm (single): mark paid, advance due date per HitM's recurrence answer (gate above)
- If `due_date` is >1 month behind: show "X periods missed" with "Catch up" option
- Catch-up: loop up to 24 periods, create/mark paid records for each missed period, advance to current
- i18n keys needed: `upcoming.overdue_label`, `upcoming.mark_paid_advance`, `upcoming.catch_up_periods`, `upcoming.catch_up_confirm`

### T02.SL5 — V2 smoke on inactive color
- Deploy T02 changes (API + web) to inactive color
- Smoke: submit quick add with linked bill → verify paid_flag in DB
- Smoke: advance an overdue bill → verify new due_date
- Evidence: smoke log

## Notes

- Check existing `UpcomingExpense` manager for any `get_current_month()` or similar — use it rather than raw queryset filtering
- The bulk catch-up 24-period cap must be enforced in API logic (not just frontend) — a direct API call could skip the frontend guard
