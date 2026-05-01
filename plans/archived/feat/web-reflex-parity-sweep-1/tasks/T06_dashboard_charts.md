# T06 — Dashboard charts (flow / spend / category pie / tag pie)

**Phase:** P3 — Dashboard parity  
**Skill:** `feature-implementation-loop`  
**Branch:** `feat/web-dashboard-parity`

## Reference

Reflex `view_components.py` chart definitions; data fields on
`SnapshotResponse` (`flow_series`, `daily_spend`, `daily_income`,
`expense_by_category`, plus tag aggregation).

## Objective

Ship the four core dashboard charts inside `<ChartFrame/>` wrappers with
theme-aware colors, accessible labels, and click-to-drillthrough where
applicable.

## Implementation checklist

### Flow chart (`src/components/dashboard/FlowChart.tsx`)
- [ ] Recharts grouped/stacked `BarChart`: x = `flow_series[].label`, three
  series (incoming, outgoing, leaks). Toggle chips above the chart let the
  user hide/show each series (state in `FilterRow` shared store).
- [ ] Tooltip formats currency using base currency from profile.

### Spend chart (`src/components/dashboard/SpendChart.tsx`)
- [ ] BarChart: x = `daily_spend[].date`, y = `amount`. Optional overlay line
  for `daily_income` (toggle).

### Category pie (`src/components/dashboard/CategoryPie.tsx`)
- [ ] PieChart from `expense_by_category`. Color via theme palette (8-color
  cycle from tokens).
- [ ] **Click slice → drillthrough**: dispatch `applyCategorySlice(name)` →
  navigates to `/app/transactions?category=<name>&...currentFilters` and shows
  a success callout on the next page.
- [ ] "Other" slice (sum of the long tail) is **not** clickable.

### Tag pie (`src/components/dashboard/TagPie.tsx`)
- [ ] PieChart from tag aggregation (compute client-side from
  `transactions_for_month` if not present in snapshot; otherwise use API
  field).
- [ ] Same click → drillthrough by tag.

### Shared
- [ ] `<ChartFrame>` shows `<Skeleton>` when `isLoading`, `<EmptyState>` when
  the data array is empty, `<ErrorState>` on `isError`.
- [ ] All charts use `<ResponsiveContainer/>` so they reflow inside their
  cards. Chart card minimum height 240 px.

## Definition of done

- [ ] All four charts render real data on the VPS dashboard.
- [ ] Click a category slice → lands on `/app/transactions` with that
  category filter applied.
- [ ] Charts adapt to dark theme (toggle via DevTools `data-theme="dark"`).
- [ ] Charts have an `aria-label` describing what they show.

## Verification

Manual click + DevTools network for drillthrough; theme toggle in DevTools.
