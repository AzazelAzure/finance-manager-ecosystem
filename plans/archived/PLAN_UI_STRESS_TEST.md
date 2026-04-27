# PLAN: UI Stress Test & Fixes

This plan contains 4 tasks to test the newly upgraded `hive_worker.py` script while resolving several UI and API bugs across the application.

### Task T1: Dashboard Series Force Fallback
- **Goal:** Force the dashboard series widgets (Spend, Flow, Category) to ALWAYS populate from the `transactions` payload instead of relying on the backend `snapshot` data, resolving the issue where they remain empty.
- **Files to edit:**
  - `finance_manager_reflex/finance_manager_reflex/features/agentdash/mappers.py`
- **Implementation notes:** 
  - Update `build_spend_series`, `build_income_series`, `build_category_series`, and `build_flow_series`.
  - Remove the logic that checks `snapshot.get(...)` for the series data.
  - Return early with `[]` if `transactions` is None or empty.
  - Leave the existing transaction calculation loops intact, ensuring that Pydantic properly casts the calculated Decimals to floats in the returning `DashboardChartPoint`, `DashboardCategoryPoint`, and `DashboardFlowPoint`.
- **Verification commands:** 
  - `docker compose exec reflex python -m pytest` (if available, otherwise rely on manual UI review)

### Task T2: Dashboard Monthly Activity Layout
- **Goal:** Fix the "Monthly Activity" table layout so it spans the full width of the dashboard rather than being compressed in a 2-column grid next to account balances.
- **Files to edit:**
  - `finance_manager_reflex/finance_manager_reflex/features/agentdash/view_components.py`
- **Implementation notes:** 
  - In `dashboard_content()`, locate the `rx.grid(..., columns="2")` that contains `AgentDashState.show_balances` and `AgentDashState.show_recent_tx`.
  - Remove `recent_transactions()` from this grid.
  - Place `rx.cond(AgentDashState.show_recent_tx, recent_transactions())` outside and directly below the grid so it renders full width.
- **Verification commands:** 
  - `echo "Layout updated."`

### Task T3: Transactions Page Table Badges
- **Goal:** Make the Transactions page table match the Dashboard table by adding `tx_type` badges and a Category column.
- **Files to edit:**
  - `finance_manager_reflex/finance_manager_reflex/features/transactions/view_components.py`
- **Implementation notes:** 
  - In `transactions_table()`, update the `headers` list to include "Category" before "Actions".
  - In the `rx.table.row` loop, replace the `tx_type` string output with an `rx.badge` component matching the logic from the dashboard (e.g., color_scheme mapping "EXPENSE" to "red", "INCOME" to "green", "XFER_IN" / "XFER_OUT" to "blue").
  - Add `rx.table.cell(tx["category"])` before the Actions cell.
- **Verification commands:** 
  - `echo "Transactions table updated."`

### Task T4: Upcoming Expenses Filters & UI
- **Goal:** Fix the API `for_month` filter to actually filter by the requested YYYY-MM instead of always forcing `get_current_month()`, and fix the UI filter button styling.
- **Files to edit:**
  - `finance_manager_api/finance/services/expense_services.py`
  - `finance_manager_reflex/finance_manager_reflex/features/upcoming_expenses/view_components.py`
- **Implementation notes:** 
  - In `expense_services.py` inside `get_expenses`, modify the `if kwargs.get('for_month'):` block. Instead of calling `get_current_month()`, parse the string (e.g., `"2026-04"`) into year and month integers and use `get_by_month(month, year)` if it exists, OR manually create a date range and use `get_expenses_by_period`. Example: `from datetime import datetime`, parse `kwargs['for_month']` to get start/end dates for that month, and filter.
  - In `view_components.py`, in `filters()`, move the `secondary_button("Month: current")` down next to the `text_input` for `For month (YYYY-MM)`.
  - Change the "Any recurring", "Recurring only", "Non-recurring" buttons (and the paid flag ones) to use `variant="surface"` or `variant="outline"` instead of being flat, and use a condition on `UpcomingExpensesState.filter_recurring` to set `variant="solid"` if they are currently active (e.g., `rx.cond(UpcomingExpensesState.filter_recurring == "true", "solid", "surface")`).
- **Verification commands:** 
  - `echo "Filters and UI updated."`
