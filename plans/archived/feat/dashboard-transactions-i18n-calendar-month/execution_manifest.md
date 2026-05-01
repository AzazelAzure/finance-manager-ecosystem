# Execution manifest — dashboard + transactions i18n + calendar month view

## Phase 1 — Navigation and shell strings (goal: every nav label localized)

- **Goal:** Protected sidebar links, page titles where appropriate, and shell chrome strings (“Guide”) use `tr(ProfileState.current_locale, …)` with keys for all `PROTECTED_NAV_ROUTES` entries plus any shell-only labels.
- **Entry criteria:** `main` synced; branch `feat/dashboard-transactions-i18n-calendar-month` created in `finance_manager_reflex`.
- **Exit criteria:**
  - Each `RouteMeta` with `show_in_nav=True` has a stable i18n key (e.g. `nav.dashboard`, `nav.transactions`, `nav.calendar`, `nav.upcoming`, `nav.data`, `nav.profile`, `nav.home` if used).
  - `shell.py` uses `tr(ProfileState.current_locale, key)` for link text; no raw `nav_label` for display.
  - `TL_PH` (and `EN_US`) contain all new keys; switching locale in UI updates sidebar without restart.
- **Breakpoints:** Stop if `tr` cannot be used in static `RouteMeta` construction — then introduce a small `nav_label_for_path(path) -> Var` helper or key map keyed by `nav_route.path`.
- **Triggers:** Phase 2 starts after manual smoke: EN + TL sidebar check on Dashboard, Transactions, Calendar, Upcoming, Data, Profile.
- **Dependencies:** None (Reflex-only).
- **Required implementation updates:**
  - `app/routes.py`: add `nav_i18n_key: str` on `RouteMeta` or derive key from `path` in one module-level dict.
  - `app/shell.py`: replace literal “Guide” with `tr(..., "nav.guide")` or `shell.guide`.
  - `core/i18n.py`: add keys under `nav.*` / `shell.*`.
- **Verification gate:** Logged-in user switches locale; all visible nav items translate.
- **Risks and mitigations:** Reflex `Var` vs static string in `foreach` — test compile; use `rx.match` on path if needed.

---

## Phase 2 — i18n architecture hardening (goal: reusable pattern for future locales)

- **Goal:** Document and implement a **single pattern** for adding strings and locales: key naming (`feature.area.token`), fallback chain (`en-US` → missing key behavior), and where product copy lives (`i18n.py` vs future split files).
- **Entry criteria:** Phase 1 merged or complete on branch.
- **Exit criteria:**
  - Short **developer note** in `reflex_docs/` or `README` snippet (or comment block at top of `i18n.py`) describing: how to add a key, how to add a locale, required parity between `EN_US` and `TL_PH` for shipped keys.
  - Optional (if scope allows): extract `LOCALES: dict[str, dict[str, str]]` or `MESSAGES = {"en-US": EN_US, "tl-PH": TL_PH}` with `tr()` reading from it — without breaking existing imports.
- **Breakpoints:** If refactor balloons, ship documentation + minimal structural change only.
- **Triggers:** Phase 3 after review that new keys follow the convention from Phase 1–2.
- **Dependencies:** Phase 1 strings stable enough to avoid rename churn.
- **Verification gate:** New nav keys added using the documented pattern only.
- **Risks and mitigations:** Large refactor — keep Phase 2 documentation-first if timeboxed.

---

## Phase 3 — Transaction editor modal and quick-add flow (goal: no hardcoded English in modal)

- **Goal:** `editor_modal()` and any shared transaction form headers/placeholders for mode (expense/income/transfer) and type labels use `tr()`.
- **Entry criteria:** Phases 1–2 done or parallelized only if no key conflicts.
- **Exit criteria:**
  - Replace hardcoded `"Transfer"` and `("EXPENSE", "Expense")` style labels with i18n keys (`transactions.mode_expense`, `transactions.type_expense`, etc.).
  - “Set Today” and any remaining literal strings in the editor path covered or tracked as follow-ups.
  - Dashboard flow: open add expense/income/transfer → modal titles and tabs match locale.
- **Breakpoints:** API returns raw enum strings — display layer maps to translated labels only in UI.
- **Dependencies:** None for API contract if only display changes.
- **Verification gate:** Manual: three modes + locale switch on dashboard.
- **Risks and mitigations:** Duplicated modal on transactions page — ensure one `editor_modal` implementation covers both.

---

## Phase 4 — Calendar month grid + heat on days (goal: month view matches user mental model)

- **Goal:** Add a **month view** layout: grid of weeks/days for the selected month (or range), with **heat intensity** (or metric) **per day cell**, consistent with API `calendar_daily` (or aggregated client-side from same source). Existing list/heatmap can remain as secondary or be folded into the grid.
- **Entry criteria:** Confirm `TransactionsState.calendar_daily` shape (`date`, `heat_intensity`, amounts, etc.) and API contract in `features/transactions/` + `TransactionsApi`.
- **Exit criteria:**
  - User can see a **full month** (headers Sun–Sat or locale-aware start from profile) for the focused month.
  - Each day cell shows at least date + visual heat (and optional tooltip/drill to existing day drill).
  - Section titles and buttons (“Current month”, “Load calendar”, empty states) use `tr()`.
- **Breakpoints:** If API lacks per-day data for a month, define minimal backend follow-up in `finance_manager_api` and park UI behind feature flag or phase 4b.
- **Dependencies:** May need `finance_manager_api` for calendar aggregate shape — confirm before building grid.
- **Verification gate:** Manual: switch month, compare heat to list; locale for calendar page strings.
- **Risks and mitigations:** Reflex layout complexity — start with CSS grid; mobile responsive follow-up.

---

## Rollback / mitigations

- i18n: keep old keys as aliases for one release if renaming.
- Calendar: feature-flag month grid or ship behind “View: Month | List” toggle if regression risk is high.

## Orchestration handoff

- **Plan root:** `plans/archived/feat/dashboard-transactions-i18n-calendar-month/`
- **Owner:** Reflex feature track; API only if calendar contract extension required.
- **Next action after plan approval:** create branch, implement Phase 1, then run Reflex compile + targeted manual tests.
