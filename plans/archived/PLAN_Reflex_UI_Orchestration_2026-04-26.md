# PLAN_Reflex_UI_Orchestration_2026-04-26

## 1) Objective
Resolve data population and UI behavior issues across the Reflex frontend, specifically targeting Dashboard data binding, Transactions tag selection, Upcoming Expenses data propagation, and Profile auto-loading. Additionally, migrate the Monthly Activity to a dashboard widget, standardize all application tables to a clean, modern aesthetic with striped rows, and ensure Golden Rule consistency across all documentation. 

## User Review Required
Please review the addition of the "Golden Rule Alignment" task and provide final approval to begin execution.

## 2) Scope
### In scope
- **Dashboard Data Binding**: Fixing sub-series (Flow, Spend, Category) and source balances.
- **Transactions Tags**: Implementing a custom tag input that displays tags as "pill" icons with an "x" to remove, and an input field to create/select tags.
- **Upcoming Expenses**: Fixing data fetching and population on load.
- **Profile Page**: Removing the Monthly Activity completely (as data is redundant) and ensuring profile preferences load automatically on page load.
- **Monthly Activity**: Migrating to the Dashboard.
- **Table Aesthetics**: Creating a `standard_data_table` primitive with striped rows (not columns) to standardize table designs across the app.
- **API Investigation**: Investigating current API payloads for the dashboard/expenses to ensure no backend restructuring is needed; if it is, a subsequent API plan will be created.
- **Golden Rule Alignment**: Updating `design_docs` and `plan templates` to consistently reflect all 15 Golden Rules, ensuring future agents have accurate knowledge.

### Out of scope
- Backend API restructuring (If needed, this will be handled in a separate, dedicated plan after investigation).

## 3) Constraints & Guardrails (The 15 Golden Rules)
As verified in `GEMINI.md`, all 15 rules apply. Key rules for this execution:
- **1-4. Efficiency, Readability, Lean Files, Separation of Concerns**: Maintain 300-500 lines per file; keep routing, logic, and UI separate.
- **5. Tools**: Build reusable primitives (`standard_data_table`, `tag_pill_input`).
- **6. DB Hits**: Ensure any API calls we inspect or adjust adhere to the 10-12 limit.
- **7-10. Professionalism, Logging, Tracking, Root Cause**: No bandaids. Log to `CHANGELOG.md`. Fix state propagation correctly.
- **11-15. Collaboration, Git First, Plans, KIs, Hive Protocol**: Execution will proceed atomically following this approved plan.

## 4) Proposed Changes

### Golden Rule Alignment
#### [MODIFY] `finance_manager_reflex/design_docs/00_Coding_Guidelines.md` (or equivalent workspace docs)
- Ensure all 15 rules from `GEMINI.md` are documented perfectly for the system's Knowledge Items (KIs) to digest.
#### [MODIFY] `finance_manager_reflex/plans/templates/GEMINI_PLAN_TEMPLATE_V2.md`
- Update the constraints section to reflect 15 rules instead of 11.

### UI & Primitives Layer
#### [MODIFY] `finance_manager_reflex/finance_manager_reflex/ui/primitives.py` (or `patterns.py`)
- Create a `standard_data_table` component to unify the aesthetic (striped rows).
- Create a `tag_input_pill` component that allows adding/removing tags visually.

### Dashboard (Agentdash)
#### [MODIFY] `finance_manager_reflex/finance_manager_reflex/features/agentdash/state_load.py`
- Ensure data is parsed and mapped to the UI variables correctly. Investigate API responses.
#### [MODIFY] `finance_manager_reflex/finance_manager_reflex/features/agentdash/view_components.py`
- Add the Monthly Activity widget to the layout. Fix sub-series empty states.

### Transactions
#### [MODIFY] `finance_manager_reflex/finance_manager_reflex/features/transactions/view_components.py`
- Replace current tag input with the new custom tag pill component.
#### [MODIFY] `finance_manager_reflex/finance_manager_reflex/features/transactions/state_form.py`
- Wire the new tag component to add/remove tags in the transaction state.

### Upcoming Expenses
#### [MODIFY] `finance_manager_reflex/finance_manager_reflex/features/upcoming_expenses/view.py` & `state.py`
- Verify `on_load` data fetching mechanism.
#### [MODIFY] `finance_manager_reflex/finance_manager_reflex/features/upcoming_expenses/view_components.py`
- Replace existing table with the new `standard_data_table` primitive.

### Profile
#### [MODIFY] `finance_manager_reflex/finance_manager_reflex/features/profile/view.py`
- Add `on_load` data fetching.
#### [MODIFY] `finance_manager_reflex/finance_manager_reflex/features/profile/view_components.py`
- Remove the Monthly Activity table component completely.

## 5) Verification Plan
### Automated Tests
- Reflex compilation check (`rx export` or local run).
- Verify API payloads for Dashboard and Upcoming Expenses data completeness.

### Manual Verification
- **Documentation**: Check that KIs and design docs accurately reflect the 15 rules.
- **Dashboard**: Confirm charts and balances display correct aggregations.
- **Transactions**: Create a transaction, verifying tag pills are visually added/removed.
- **Upcoming Expenses**: Confirm table shows expenses and updates upon edits.
- **Profile**: Ensure data loads seamlessly and Monthly Activity is removed.
- **Aesthetics**: Visually verify all tables look clean, human, and have striped rows.
