# PLAN_Reflex_Dashboard_Data_Wiring_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Dashboard_Data_Wiring_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P1`
- Target repos/areas: `finance_manager_reflex` (AgentDash Feature)

## 1) Objective
Fix the main dashboard widgets to properly consume and display the data provided by the API's snapshot endpoint. Ensure Spend Account Balances, Flow Series, and Category Series correctly populate the UI charts instead of showing "No data".

## 2) Scope
### In scope
- Updating the `agentdash` state to parse `flow_series`, `expense_by_category`, and `source_balances` from the API snapshot payload.
- Mapping parsed data to the Reflex chart components (`rx.recharts`).
- Ensuring charts handle empty data gracefully.

### Out of scope
- API payload adjustments (handled in API plan).

## 3) Inputs / Source Docs
- `finance_manager_reflex/finance_manager_reflex/features/agentdash/state.py`
- `finance_manager_reflex/finance_manager_reflex/features/agentdash/view_components.py`
- `plans/PLAN_API_Dashboard_Data_Payload_2026-04-25.md` (Dependency)

## 4) Constraints & Guardrails
- **Rule #10 (Fix it Forever):** Rely on the API for aggregation; do not implement low-level math on the frontend to calculate category totals from raw transactions.
- **Design Fidelity:** Ensure charts use brand colors and maintain the "Living UI" aesthetic.

## 5) Execution Breakdown

### Task T1: State Parsing
- **Goal:** Update the dashboard state to ingest new payload fields.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/features/agentdash/state.py`.
- **Implementation notes:** 
    - Ensure `load_dashboard_data` captures `source_balances`, `flow_series`, and `expense_by_category` from the JSON response and stores them in state vars.

### Task T2: Chart Data Mapping
- **Goal:** Feed the state variables into the UI components.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/features/agentdash/view_components.py` (or similar chart view file).
- **Implementation notes:** 
    - Update the Spend Accounts card to iterate over `State.source_balances`.
    - Update the Flow chart to use `State.flow_series`.
    - Update the Category chart to use `State.expense_by_category`.

## 6) Verification Plan
- Reflex Smoke Checks: Log in and verify that charts display data corresponding to the current month's transactions, and that "No source balances" is replaced by actual account values.

## 7) Documentation & Feature Tracking
- [ ] Update `CHANGELOG.md` for Reflex.
- [ ] Move plan to `plans/archived/` upon completion.
