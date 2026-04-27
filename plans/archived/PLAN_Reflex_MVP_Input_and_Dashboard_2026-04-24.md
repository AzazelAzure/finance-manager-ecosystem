# Gemini Plan Template (for Cursor execution)

## 0) Metadata
- Plan ID: `PLAN_Reflex_MVP_Input_and_Dashboard_2026-04-24`
- Owner: Gemini
- Requested by: User
- Status: `ready_for_cursor`
- Priority: `P0`
- Target repos/areas: `finance_manager_reflex/`

## 1) Objective
Implement the "Intuitive Input" MVP for the Reflex frontend to prepare for a beta launch within one month. This includes connecting the core UI to the Django API, creating a frictionless transaction input form, a digestible dashboard, an onboarding wizard, and basic feature tutorials.

## 2) Scope
### In scope
- **API Integration:** Connect Reflex state to the existing Django API endpoints for core CRUD operations.
- **Quick Entry Form:** Build a keyboard-friendly, highly intuitive transaction input component.
- **Dashboard:** Render the `FinancialSnapshot` data into a clean, easy-to-read view.
- **Onboarding Wizard:** Create a step-by-step flow for new user profile/account setup.
- **Feature Tutorials:** Implement a lightweight tutorial system (e.g., tooltips, guided tours, or help modals) for the onboarding process and core features.

### Out of scope
- Advanced visualizations (Graphing, Calendar view) - These belong in Milestone 2.
- Localization (i18n) - This belongs in Milestone 3.
- Modifying Django API logic or payloads (API should be considered fixed for this MVP unless absolutely blocking).

## 3) Inputs / Source Docs
- `design_docs/20_Roadmap/Reflex_Feature_Roadmap.md` (Milestone 1)
- `design_docs/api_docs/01_Endpoints_and_Contracts.md` (For API payload shapes)

## 4) Constraints & Guardrails
- **Lean Frontend:** Do not perform heavy math or aggregations in Reflex. Rely on the data structures returned by the API.
- **UI/UX Focus:** The design must bridge the gap between "power user" functionality and "non-tech literate" simplicity.
- User instruction overrides all plan details.

## 5) Execution Breakdown (Cursor-facing tasks)

### Task T1: Base API State & Connection
- Goal: Establish the global state connection to the Django API.
- Files to edit: `finance_manager_reflex/state.py` (or equivalent), generic API fetch utilities.
- Implementation notes: Setup base classes for fetching user profiles, accounts, and the latest snapshot. Handle auth/session tokens securely.
- Acceptance criteria: Reflex state correctly hydrates with data from a local running instance of the Django API.

### Task T2: Onboarding Wizard & Tutorials
- Goal: Guide a new user through setup with built-in education.
- Files to edit: `finance_manager_reflex/pages/onboarding.py`, components for tutorials.
- Implementation notes: Create a multi-step form (Profile -> Base Currency -> First Account). Add contextual help/tutorial text explaining *why* they are doing this and *what* the feature does.
- Acceptance criteria: A new user can complete setup without prior knowledge of the system.

### Task T3: Digestible Dashboard
- Goal: Render the Financial Snapshot.
- Files to edit: `finance_manager_reflex/pages/dashboard.py`.
- Implementation notes: Display `total_assets`, `safe_to_spend`, etc., cleanly. Use the pre-calculated API data.
- Acceptance criteria: The dashboard accurately reflects the API's financial snapshot.

### Task T4: Quick Entry Transaction Form
- Goal: Frictionless data entry.
- Files to edit: `finance_manager_reflex/components/transaction_form.py`.
- Implementation notes: Ensure tab-navigation works flawlessly. Auto-focus fields where appropriate. Connect to the API POST endpoint.
- Acceptance criteria: A user can enter a transaction using mostly the keyboard in under 5 seconds.

## 6) Subagent Request Protocol (when needed)
- Subagent type: `explore`
- Purpose: Review the API docs to ensure the frontend state variables perfectly match the backend JSON contracts before building components.

## 7) Verification Plan
- Integration checks: Run both the API and Reflex locally. Walk through the onboarding wizard, view the dashboard, add a transaction, and verify the dashboard updates.
- CLI/manual smoke checks: Visually verify the tutorial components are present and helpful.

## 8) Documentation Updates Required
- Update `design_docs/CHAT_LOG.md` upon completion.
- Note any API payload mismatch issues discovered during implementation in the Sync Log.

## 9) Completion Criteria
Mark plan complete only when:
- The UI components are built and functional.
- The app communicates successfully with the API.
- The Cursor report is logged in `CHAT_LOG.md`.