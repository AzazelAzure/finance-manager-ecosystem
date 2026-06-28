# T04 — Dashboard Goals Widget

## End State

The dashboard gains a `GoalsWidget` component showing up to 3 active (unmet) goals with progress bars and per-cycle amounts. Goals are read via the same `readOptsFromQuery` pattern as other dashboard data, so they degrade gracefully offline. A "Manage goals" link navigates to `/app/goals`.

## Acceptance Criteria

1. [V3] `GoalsWidget` renders on `DashboardPage` showing up to 3 unmet goals
2. [V3] Each row shows: goal name, compact progress bar, "X / Y" amounts, "per cycle" figure
3. [V3] If 0 goals exist: widget shows "No goals yet" with a link to `/app/goals`
4. [V3] "Manage goals" link at widget footer navigates to `/app/goals`
5. [V1] Widget uses `readOptsFromQuery` — shows stale cached data when offline (no spinner failure)
6. [V1] Widget only shows unmet goals (`current_amount < target_amount`) — met goals excluded (they're noise on the dashboard)
7. [V1] `npm run build` zero errors; no new lint errors

## Scope Lock

### Files to create
- `src/components/dashboard/GoalsWidget.tsx`

### Files to modify
- `src/pages/dashboard/DashboardPage.tsx` — import and place `<GoalsWidget />` after `KPIRow` or before `RecentTransactions` (your judgment on visual placement)

### Files NOT to touch
- `GoalsPage.tsx` from T03
- `goals.ts` API client — use it as-is
- Any API view

## Slices

### T04.SL1 — GoalsWidget component
`src/components/dashboard/GoalsWidget.tsx`:
- `useQuery` with key `['goals']`, query fn `listGoals(readOptsFromQuery(ctx))`
- Filter to unmet: `goal.current_amount < goal.target_amount`
- Sort by `target_date` ascending (soonest first)
- Slice first 3
- Each row:
  - Goal name (truncate at ~30 chars with ellipsis if needed)
  - Progress bar: `(current / target) * 100`%
  - Amount line: `{formatMoney(current, currency)} / {formatMoney(target, currency)}`
  - Pace line: `{formatMoney(per_cycle_required, currency)} {tr('goals.perCycle', locale)}`
- Footer: link to `/app/goals` — `{tr('goals.manageLink', locale)}`
- Loading state: show existing `LoadingState` component
- Error state: show existing `ErrorState` component
- Empty (0 unmet): single-line prompt + link

### T04.SL2 — Dashboard integration
In `DashboardPage.tsx`:
```tsx
import { GoalsWidget } from "../../components/dashboard/GoalsWidget";
// Place in JSX — after KPIRow, before SpendChart or RecentTransactions
<GoalsWidget />
```
No props required — widget self-fetches.

### T04.SL3 — i18n additions
Add to `en-US.json` (merge with existing `goals.*` from T03 — do not duplicate):
```
goals.manageLink: "Manage goals →"
goals.widgetEmpty: "No active goals. Add one to start tracking your savings."
```
Mirror in `tl-PH.json`.

### T04.SL4 — Browser verification
On the dashboard:
- With 0 goals: widget shows empty prompt
- After creating 1+ goals via `/app/goals`: widget shows them on next dashboard load (or after React Query cache refresh)
- With 3+ goals: only first 3 visible; "Manage goals" links correctly
- Simulate offline: widget shows last cached goals, no broken spinner

## Notes

- The widget shares the `['goals']` query key with `GoalsPage` — if the user navigates goals → dashboard, they'll see fresh data from the React Query cache with no extra fetch
- `formatMoney` is already imported in `DashboardPage.tsx` — use the same utility in `GoalsWidget`
- Do not show met goals (current >= target) on the dashboard — they clutter the "what do I need to do" view; the full list (including met) is at `/app/goals`
- Widget does not need its own loading skeleton — the shared `LoadingState` is sufficient for beta
