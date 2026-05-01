# T11 — Upcoming expenses (`/app/upcoming-expenses`)

**Phase:** P5 — Bills + data hub  
**Skill:** `feature-implementation-loop`  
**Branch:** `feat/web-bills-and-data-hub`

## Reference

Reflex `features/upcoming_expenses/` (`view.py`, `view_components.py`,
`state.py`, `models.py`). API: `GET/POST /finance/upcoming_expenses/`,
`GET/PATCH/PUT/DELETE /finance/upcoming_expenses/<name>/`.

## Objective

Ship the bills pipeline: filters (recurring / paid / date), table, modal CRUD.

## Implementation checklist

### Page (`src/pages/upcoming/UpcomingExpensesPage.tsx`)
- [ ] Layout: filter row + table.
- [ ] Filter row: chips Recurring (yes/no/both), Paid (yes/no/both), date
      quick filters (this month / next month / overdue / all).

### Table
- [ ] Columns: name, amount + currency, due date, paid badge, recurring
      badge, source (if any), actions (edit/delete).
- [ ] Below `--bp-md`: stacked cards.
- [ ] Two-step delete (same pattern as transactions).

### Modal (`UpcomingExpenseModal.tsx`)
- [ ] Fields: name (required), amount + currency, due date, "use start" toggle,
      start_date / end_date (when toggled), paid checkbox, recurring checkbox.
- [ ] Inline guardrail callout (amber) when end_date < start_date or amount =
      0.
- [ ] Submit POST/PATCH; on success invalidate upcoming list and dashboard
      snapshot.

## Definition of done

- [ ] CRUD all four mutations end-to-end on VPS.
- [ ] Filters reduce the table; pagination not required (full list).
- [ ] Mobile cards.

## Verification

Manual on VPS; create + edit + delete + paid toggle.
