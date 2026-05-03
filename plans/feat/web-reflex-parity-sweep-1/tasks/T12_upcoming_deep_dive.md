# T12 — Upcoming expenses deep-dive

**Phase:** P5 — Bills + data hub  
**Skill:** `feature-implementation-loop`  
**Branch:** `feat/web-bills-and-data-hub`

## Reference

Reflex `upcoming_expenses_deep_dive_page` + `_deep_dive_content` (shares
`TransactionsState.load_visualization` shape; payload keys
`upcoming_expenses_*`).

## Objective

KPI row + monthly bar + timeline table on a dedicated page.

## Implementation checklist

- [x] `src/pages/upcoming/UpcomingDeepDivePage.tsx` route
      `/app/upcoming-expenses/deep-dive`.
- [x] KPI tiles: total upcoming this month, total upcoming next month,
      recurring %, overdue amount.
- [x] Monthly bar chart from `upcoming_expenses_*` payload keys.
- [x] Timeline table: rows ordered by due date; pay-by-date highlighting.
- [x] Sidebar item active = `Upcoming` (not a separate item).

## Definition of done

- [ ] Page renders all 3 widgets with real data.
- [ ] Sidebar correctly highlights `Upcoming`.

## Verification

Manual on VPS.

## Progress notes

- 2026-04-29: Implemented initial upcoming deep-dive page route with KPI row,
  monthly chart, and due-date timeline table. Pending VPS verification with
  real account data.
