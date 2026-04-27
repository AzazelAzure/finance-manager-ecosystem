# PLAN_Reflex_QuickEntry_and_Data_Fixes_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_QuickEntry_and_Data_Fixes`
- Owner: Gemini (Agent)
- Status: `ready_for_execution`
- Target: `finance_manager_reflex` (Quick Entry & Data Hub)

## 1) Objective
Refine the data display and validation in the Quick Entry and Data Hub components to ensure a professional, user-friendly interface that prevents invalid data entry and masks system-internal values.

## 2) Scope
- **Quick Entry**: Currency filtering, removal of debug text, capitalization of sources.
- **Data Hub**: Hiding the "UNKNOWN" source, capitalization of source names.
- **General**: Formatting of transaction types (XFER -> Transfer).

## 3) Execution Breakdown

### Task T1: Quick Entry Logic Update
- **Goal:** Filter currencies and capitalize sources.
- **Implementation:** 
    - In `quick_entry/state.py`: Derive the `available_currencies` list from the unique currencies found in `State.source_accounts`.
    - In the view: Apply `.capitalize()` to the labels of the source selection dropdown.
    - **DELETE:** Remove the `rx.text(f"Known spend accounts: {State.known_accounts}")` component.

### Task T2: Data Hub Cleanup
- **Goal:** Hide "UNKNOWN" and capitalize names.
- **Implementation:** 
    - In `data_hub/view.py`: Filter the sources table to exclude any source where name == "unknown".
    - Apply `.capitalize()` to the source name cell.

### Task T3: Transaction Type Mapping
- **Goal:** Human-readable transaction types.
- **Implementation:** 
    - Update the display logic in the Transactions table and Quick Entry type selection.
    - Map `XFER_IN` / `XFER_OUT` to `Transfer`.
    - Ensure all types (Income, Expense, Transfer) are capitalized (first letter only).

## 4) Verification
- Check Quick Entry: Verify "known spend accounts" text is gone. Verify currency list matches your actual sources.
- Check Data Hub: Verify "unknown" source is invisible.
