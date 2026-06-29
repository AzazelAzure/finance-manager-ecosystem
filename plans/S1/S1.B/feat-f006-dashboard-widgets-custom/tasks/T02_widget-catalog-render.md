# T02 — Widget Catalog + Layout-Driven Render

## End State

The existing dashboard widgets are registered in a catalog with metadata. `DashboardPage` renders
from the persisted layout (T01) instead of a hardcoded order, and the user can show/hide widgets
and add catalog widgets that aren't currently placed.

## Acceptance Criteria

1. [V1] A widget catalog/registry maps `widget_id` → `{component, label (i18n key), defaultSize, category}` for the existing widgets: KPIRow, ProfileOverview, SourceBalances, RecentTransactions, UpcomingBillsWidget, GoalsWidget, BalanceHistoryChart, SpendChart, FlowChart, CategoryPie, TagPie, QuickActions.
2. [V1] `DashboardPage` renders widgets in the order/visibility from the user's saved layout (T01 GET), falling back to the default layout.
3. [V1] A "manage widgets" affordance lets the user toggle visibility and add a catalog widget not currently in the layout; changes persist via the T01 PUT/PATCH.
4. [V1] Hidden/removed widgets stop fetching their data (don't pay for invisible widgets).
5. [V1] i18n keys for catalog labels + the manage-widgets UI; no hardcoded copy.
6. [V1] Single source of truth for `widget_id` strings shared with the API's catalog validation (T01) — values must match exactly.

## Scope Lock

### Files to modify / create
- `finance_manager_web/src/components/dashboard/widgetCatalog.ts` (new registry)
- `finance_manager_web/src/pages/dashboard/DashboardPage.tsx` — render from layout
- a "manage widgets" panel component
- `finance_manager_web/src/api/dashboardLayout.ts` (new) — layout fetch/save
- i18n locale files

### Files NOT to touch
- The individual widget components' internals (only how they're registered/placed)
- DnD/resize (T03), device variants (T04)

## Slices

### T02.SL1 — Catalog registry
Enumerate the existing widgets into `widgetCatalog.ts` with metadata. This is the canonical list T01's validation mirrors.

### T02.SL2 — Layout-driven render
Refactor `DashboardPage` to map over the saved layout → catalog → components, instead of the current fixed JSX order. Default layout when none saved.

### T02.SL3 — Manage-widgets panel
Show/hide + add-from-catalog; persist via the layout API; gate data fetching on visibility.

## Notes

- **Brand/shell icons stay with F-011** (README §2): don't fork the icon pack into widget chrome; reference `resources/hfm_icon_web/`.
- This task delivers a usable feature on its own (selectable + persisted widgets) even before DnD lands — keep it shippable independent of T03.
- Don't introduce a widget marketplace or freeform canvas (plan §2 out-of-scope).
