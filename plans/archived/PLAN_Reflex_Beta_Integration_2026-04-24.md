# Plan: Reflex Beta Integration & Backend Parity
**Date:** 2026-04-24

## 1. Overview
The goal of this phase is to bring the Reflex frontend into a stable Beta state by resolving UX friction points, eliminating frontend math violations, and achieving full feature parity with the Django REST API backend. The Zero-Knowledge encryption phase is explicitly shelved for later.

## 2. Core Directives
- **Strict Backend-First Math:** The frontend must **not** calculate aggregated metrics, loop over datasets to calculate sums, or compute period-over-period differences. All numbers presented in the dashboard must come directly from the API endpoint (e.g., the `snapshot` or dedicated charting endpoint).
- **Eliminate Free-Text Entry for Relationships:** The user should not have to manually type exact strings for relationships like Categories, Sources, and Currencies.
- **Enable Full CRUD on Core Models:** Users must be able to manage Categories, Sources, and Tags natively within the application.

## 3. Implementation Tasks for Cursor

### Task 1: API Snapshot Adjustments (Backend)
**Files to target:** `finance_manager_api/finance/services/profile_services.py` (or relevant snapshot service/view)
**Action:**
1. Update the snapshot payload generation to include pre-computed structures for `flow_series` (daily sum of incoming, outgoing, and transfer leaks for the month).
2. Ensure `total_leaks_for_month` is always reliably calculated and returned by the API so the frontend never falls back to its own computation.
3. **CRITICAL CONSTRAINT:** The API changes must be logged and must strictly adhere to the database query limit. The maximum allowed is 12 DB hits per request (goal is <= 10). Use efficient ORM aggregations to prevent any N+1 query inflation.

### Task 2: Eliminate Frontend Math (Frontend)
**Files to target:** `finance_manager_reflex/finance_manager_reflex/features/agentdash/mappers.py`
**Action:**
1. Remove all loops and manual calculations inside methods like `build_flow_series_from_transactions` and the fallback calculations in `build_kpis`.
2. Refactor `map_to_view_model` to strictly bind the `DashboardViewModel` properties directly to the new structured data provided by the API snapshot in Task 1.

### Task 3: Transaction Form Dropdowns (Frontend)
**Files to target:** `finance_manager_reflex/finance_manager_reflex/features/transactions/view_components.py` (and associated state modules)
**Action:**
1. Update `quick_entry_form`, `single_form`, and `editor_form`.
2. **Sources Field:** Replace `text_input` with a **strict** HTML `<select>` dropdown (or Reflex equivalent) populated dynamically from the API. Users cannot add new sources here.
3. **Categories Field:** Replace `text_input` with a dropdown. This dropdown **must allow adding a new category**. If the user creates a new category here, the form submission must sequence the API requests: first, send a `POST` to create the category, then upon success, `POST` the transaction.
4. Replace `text_input` for `Currency` with the existing `FormControls.currency_two_code_picker` where applicable or a dropdown bound to supported API currencies.

### Task 4: Remove Hardcoded Demo Data (Frontend)
**Files to target:** `finance_manager_reflex/finance_manager_reflex/features/profile/view.py`
**Action:**
1. In `splash_marketing_content`, remove the hardcoded JSON data used for the demo `recharts.line_chart`.
2. Replace it with either a static visual representation (like an image) or an empty state placeholder that clearly denotes it is a marketing page. Do not leak fake state dictionaries into the codebase.

### Task 5: Build Data Management Hub (Frontend)
**Files to target:** 
- `finance_manager_reflex/finance_manager_reflex/app/routes.py`
- `finance_manager_reflex/finance_manager_reflex/features/data_hub/` (New Module)
**Action:**
1. Create a new Reflex feature module (`data_hub`) containing `api.py`, `models.py`, `state.py`, `view.py`, and `view_components.py`.
2. Implement full CRUD views (List, Create, Update, Delete) for **Categories**, **Sources**, and **Tags** using the existing backend API endpoints.
3. Update `routes.py` to point `DATA_ROUTE` to this new feature view, replacing the static list of links.

## 4. Verification & Testing
- Ensure the API tests still pass and validate the new snapshot structure.
- Build and run the Reflex application. Navigate to the `/data` route and test CRUD operations for a Source and a Category.
- Verify the Transaction creation flow prevents free-text entry errors via dropdowns.
- Confirm the Dashboard loads correctly using strictly backend-provided data.
