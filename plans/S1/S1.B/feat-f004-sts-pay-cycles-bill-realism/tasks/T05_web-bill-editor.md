# T05 — Web Bill Editor (Volatile / Rigid + Partial Pay)

## End State

Upcoming expense create/edit modal lets users set bill class and optional partial-payment plan. i18n keys cover all new labels.

## Acceptance Criteria

1. [V1] `npm run build` passes
2. [V3] Create bill with `volatile` + planned partial amount → persists via API; reload shows values
3. [V3] Defaults hidden sensibly for simple users (rigid, full amount)

## Scope Lock

### Files to modify (Web)
- `src/pages/upcoming/UpcomingExpensesPage.tsx`
- `src/api/upcomingExpenses.ts`, `src/api/types.ts`
- `src/lib/i18n.ts`

### Files NOT to touch
- Dashboard STS display (`T06`)
- API

## Depends on

- T03 merged (API contract live)

## Branch

`cur/s1b/feat/f004-sts-pay-cycles-bill-realism/t05-web-bill-editor` (Web repo)
