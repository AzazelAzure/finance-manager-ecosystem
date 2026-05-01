# T09 — Transactions calendar (`/app/transactions/calendar`)

**Phase:** P4 — Transactions suite  
**Skill:** `feature-implementation-loop`  
**Branch:** `feat/web-transactions-suite`

## Reference

Reflex `transactions_calendar_page` + `transactions_calendar_stub_content` in
`features/transactions/view_components.py`. API: `GET
/finance/transactions/calendar/` with `start_date`, `end_date`,
`display_currency_mode` (`base|original`), `heat_metric_mode`
(`net|expense_only|count`).

## Objective

Ship a usable calendar view: range picker, calendar bar chart, day grid (heat
0–4 buckets), due events table, day-drill table.

## Implementation checklist

### Page (`src/pages/transactions/CalendarPage.tsx`)
- [ ] Range controls: month-picker + arrow nav (prev/next month), with
      manual `start_date`/`end_date` advanced fields.
- [ ] Toggles: display currency mode, heat metric mode.

### Bar chart (`CalendarBarChart.tsx`)
- [ ] X = day of month, Y = metric. Use `<ChartFrame/>` for empty/loading.

### Day grid (`CalendarMonthGrid.tsx`)
- [ ] 7-col CSS grid; each cell = day button with heat color (5 buckets;
      derive bucket from day metric vs month max). Use `color-mix()` like
      Reflex does, fallback to discrete tokens for old browsers.
- [ ] Click day → loads narrow-range data into the drill table below.

### Tables
- [ ] **Due events** for the range: name, due date, amount, status.
- [ ] **Day drill** when a day is clicked: list of transactions for that day.

### Mobile
- [ ] Below `--bp-md`: month grid keeps 7 columns but cells shrink; bar chart
      reduces to 200 px tall; tables collapse to stacked cards.

## Definition of done

- [ ] Calendar renders for current month; range nav works.
- [ ] Day click loads drill table below.
- [ ] Heat coloring scales with metric mode toggle.

## Verification

Manual on VPS with real data; verify accessibility of the day buttons (keyboard
navigation).
