# T05 — Dashboard layout + filter row

**Phase:** P3 — Dashboard parity  
**Skill:** `feature-implementation-loop`  
**Branch:** `feat/web-dashboard-parity`

## Reference

Reflex: `features/agentdash/view.py`, `view_components.py`, `state_load.py`,
`state_preferences.py`, `mappers.py`, `models.py`.

## Objective

Restructure `/app/dashboard` into the responsive layout that hosts the widgets
in T06–T07, and ship the **filter row** (basic + advanced).

## Implementation checklist

### Layout (`src/pages/dashboard/DashboardPage.tsx`)
- [ ] Replace existing inline page with a layout that uses CSS grid:
  - **≥ `--bp-lg` (1200 px)**: KPI row across the top, then 2-col main area
    (charts left, side widgets right), then full-width tables row.
  - **`--bp-md..lg`**: KPI 2x4, charts and side widgets stacked.
  - **< `--bp-md`**: single column, widgets in priority order: KPI →
    filter row → flow chart → spend chart → category pie → tag pie → source
    balances → recent transactions → profile overview.
- [ ] Each widget slot is a `<Card>` with heading + actions slot.
- [ ] Provide `<DashboardSection>` helper for consistent margins.

### Filter row (`src/components/dashboard/FilterRow.tsx`)
- [ ] Basic chips: **Current month** (default on), **Last month**, **Previous
  week**, **Custom range** (opens a popover w/ date inputs).
- [ ] Tx type chips: All / Income / Expense / Transfer / Leak.
- [ ] Top tag chips: top 8 by frequency in current period (computed from
  snapshot transactions or a separate `GET /finance/tags/`); clicking toggles.
- [ ] **Advanced** disclosure: tag (autocomplete), category (select), source
  (select), currency (select), explicit start/end date.
- [ ] Buttons: **Apply** (re-fetches snapshot with new params), **Refresh**
  (re-fetch with current params), **Reset** (clear all and refetch current
  month).

### State + data
- [ ] `useDashboardFilters()` Zustand store (or `useReducer` + Context) that
  serializes filters into a URL query string and a query key.
- [ ] React Query key: `['snapshot', filtersSignature]`. Dedup if signature
  unchanged.
- [ ] On filter change, **don't** refetch immediately — only on Apply (mirrors
  Reflex behavior).

## Definition of done

- [ ] Layout renders correctly at 320 / 640 / 900 / 1200 / 1440 / 1920 px.
- [ ] Apply / Refresh trigger one fetch each; same-signature Apply does not
  refetch.
- [ ] Filters survive a hard reload (URL query string is the source of truth).

## Verification

Manual + DevTools Network tab. Throw 5 different filter combinations.
