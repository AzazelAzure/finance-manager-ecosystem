# Dashboard navigation i18n, transaction editor i18n, and calendar month view

Execution branch (proposed): `feat/dashboard-transactions-i18n-calendar-month`  
Primary repo: `finance_manager_reflex/`  
Supporting docs (optional): `design_docs/reflex_docs/` via `design-docs-sync` after behavior stabilizes.

## Goals (from product)

1. **Navigation:** All sidebar / protected nav labels (including “submenu” destinations that use the same shell) must respect `ProfileState.current_locale` and have translations (e.g. `en-US`, `tl-PH`).
2. **i18n architecture:** Move from one-off `tr(locale, key)` calls toward a **consistent, extensible pattern** (single source of keys, naming, fallback, and a clear place to add locales).
3. **Calendar:** Keep current heat/visual strengths; add a **real month calendar grid** where per-day intensity maps to days in the grid (not only list/row views).
4. **Quick add / editor:** Dashboard “Add expense / income / transfer” already use `tr()` on the primary buttons; the **editor modal** and related controls still contain **hardcoded English** (e.g. mode toggles, type labels)—these must translate.

## Evidence (current code)

| Area | Finding |
|------|-----------|
| Sidebar | `app/shell.py` renders `nav_route.nav_label or nav_route.title` as raw strings. `RouteMeta` in `app/routes.py` holds English `nav_label`/`title`. `tr` is imported but not used for nav text. |
| Guide | Sidebar “Guide” is literal English in `shell.py`. |
| Dashboard quick actions | `view_components.py` dashboard primary buttons use `tr(ProfileState.current_locale, "dashboard.add_*")`. |
| Editor modal | `transactions/view_components.py` `editor_modal()` includes hardcoded `"Transfer"` and English type pairs (e.g. `("EXPENSE", "Expense")`). |
| Calendar page | `transactions_calendar_stub_content()` uses English section titles, buttons (“Current month”, “Load calendar”), and `empty_state` strings; layout is not a conventional month grid with cells per day. |

## Phase map (order matters)

See `execution_manifest.md` for phase objects with full exit criteria and gates.
