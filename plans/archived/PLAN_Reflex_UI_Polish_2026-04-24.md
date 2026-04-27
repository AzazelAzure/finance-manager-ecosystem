# PLAN: Reflex UI Polish and Dashboard Fixes
**Date**: 2026-04-24
**Objective**: Fix the dashboard spend account balances, replace the debug payloads card with a scrollable recent transactions list, and modernize the frontend layout (including a new sidebar menu) to feel premium and user-friendly.

## Context & Diagnosed Issues
1. **Spend Accounts Bug**: The "Spend account balances" table is rendering empty or breaking because of Reflex's compilation of Python f-strings `f"{row['amount']} {row['currency']}"` inside `rx.foreach`. Reflex requires `rx.Var` concatenation using explicit Reflex components (like `rx.hstack(rx.text(amount), ...)` or `.to(str)` concatenation) since f-strings evaluate at compile time.
2. **Missing Transactions**: The backend sends `rows` inside `AgentDashApi().get_dashboard_source_data` but they are never mapped to the `DashboardViewModel` to be displayed.
3. **Outdated Layouts**: Menus are currently a flat top-stack in `shell.py`, and the dashboard is a single stack of cards. The UI requires a rich aesthetics overhaul (e.g. sidebar navigation, grid layouts, glassmorphism, hover states).

## Task List for Cursor (Implementation)

### Phase 1: State and Mappers Fixes
- [ ] **`agentdash/state.py`**: Add `transactions_for_month: list[dict[str, str]] = []`. Explicitly type `spend_account_balances` as `list[dict[str, str]]` so Reflex serializes it properly without generic dict ambiguity.
- [ ] **`agentdash/models.py`**: Update `DashboardViewModel` to include `transactions_for_month: list[dict[str, str]] = Field(default_factory=list)` and update `spend_account_balances` type.
- [ ] **`agentdash/mappers.py`**: In `map_to_view_model`, extract the transactions from `transactions_payload`. Map each to a flat dict with string values (Date, Description, Category, Amount) and assign to `transactions_for_month`.

### Phase 2: Dashboard UI Components
- [ ] **`agentdash/view_components.py` - Fix Table**: In `spend_account_balances()`, replace the Python f-string logic inside `rx.table.cell` with `rx.hstack(rx.text(row["amount"]), rx.text(" "), rx.text(row["currency"]))`.
- [ ] **`agentdash/view_components.py` - Remove Debug**: Delete `debug_payloads_card()`.
- [ ] **`agentdash/view_components.py` - Add Transactions**: Create a new `recent_transactions()` component. Use `rx.scroll_area` containing an `rx.table.root` (headers: Date, Description, Category, Amount). Iterate over `AgentDashState.transactions_for_month`.
- [ ] **`agentdash/view_components.py` - Modernize Layout**: Wrap `dashboard_content()` components in a responsive `rx.grid`. Place KPI cards in a top row, followed by side-by-side charts (Flow vs Spend), then the Spend Accounts and Recent Transactions tables.

### Phase 3: Shell and Navigation Overhaul
- [ ] **`app/shell.py`**: Redesign `protected_app_shell()`. Replace the top horizontal stack with a fixed Sidebar navigation.
- [ ] Add `lucide` icons to menu links, and implement active route highlighting (using `color_scheme` and `variant="soft"` for active links). Ensure it's responsive.
- [ ] **`ui/tokens.py` & `ui/styles.py`**: Adjust `surface_card` styles to use a modern aesthetic (e.g., `box_shadow="md"`, `radius="large"`, padding adjustments) to give a richer, more vibrant appearance.

## Notes for Cursor
- **Rule reminder**: Do not alter backend logic. The data is available in the payload. Simply map it securely in `mappers.py` and display it.
- **Rule reminder**: Ensure all changes are documented in `design_docs/CHAT_LOG.md` when completed.
