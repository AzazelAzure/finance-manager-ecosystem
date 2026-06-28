# T06 — Web STS & Upcoming Pay-Period Views

## End State

Dashboard STS KPI and upcoming list reflect pay-cycle window when configured. Partial-pay bills show planned vs remainder clearly.

## Acceptance Criteria

1. [V1] `npm run build` passes
2. [V3] Profile set to biweekly pay cycle → upcoming filter/labels reference pay period, not only "this month"
3. [V3] Partial-pay bill card shows planned amount + remainder due date

## Scope Lock

### Files to modify (Web)
- Dashboard STS widget / snapshot consumers
- `src/pages/upcoming/UpcomingExpensesPage.tsx` (display)
- Settings profile page for pay-cycle editor
- `src/lib/i18n.ts`

## Depends on

- T04 (STS semantics), T05 (bill editor baseline)

## Branch

`cur/s1b/feat/f004-sts-pay-cycles-bill-realism/t06-web-sts-upcoming-views` (Web repo)
