---
task_id: T04
status: pending
owner: pproctor
phase: S1.B
intended_branch: cur/s1b/feat/f001-balance-history/t04-dashboard-balance-chart
last_verification: null
---

# T04 — Dashboard balance history chart

## End state

Dashboard shows a line chart of per-account balance trends with a date-range selector (7d / 30d / 90d / all). Empty, partial, and dense series render correctly without regressing existing KPI/chart load.

## Acceptance criteria

1. [V1] `src/api/balanceHistory.ts` fetches `GET /finance/balance-history/`
2. [V1] `BalanceHistoryChart` component uses Recharts line chart + `ChartFrame` patterns (matches `FlowChart`)
3. [V1] Date range selector wired to API `range` param
4. [V1] i18n keys for title, empty state, range labels (EN + follow existing locale pattern)
5. [V1] Integrated on `DashboardPage` below source balances or in chart column
6. [V2] Deploy to inactive color; smoke confirms endpoint + chart shell loads
7. [V3] Browser-verify chart with seeded data on jsdevtesting; screenshot captured

## Slice decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T04.SL1 | API client + types | V1 | `balanceHistory.ts`, types |
| T04.SL2 | Chart component | V1 | `BalanceHistoryChart.tsx` + CSS |
| T04.SL3 | Dashboard integration + i18n | V1 | Wire into `DashboardPage`; i18n strings |
| T04.SL4 | Staging smoke | V2 | Inactive color deploy smoke |
| T04.SL5 | Browser verify | V3 | Screenshot on jsdevtesting |

## Scope lock

### In scope

- `finance_manager_web/` only (depends on T03 API merged to feature branch)

### Out of scope

- Account detail page chart (dashboard only for F-001)
- Landing page showcase (F-011 T02)

## Evidence

- `evidence/T04.SL1_build.txt` — `npm run build`
- `evidence/T04.SL4_smoke.txt` — smoke log
- `evidence/T04.SL5_browser.png` — chart screenshot

## Anti-patterns

- Do NOT block dashboard render on balance history failure — show error/empty state like other charts
- Do NOT skip i18n for user-visible strings
