# PLAN_Reflex_Password_Change_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Password_Change_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P1`
- Target repos/areas: `finance_manager_reflex` (Profile Feature)

## 1) Objective
Implement a secure, "Living Design" user interface for changing account passwords within the Profile settings, communicating with the newly hardened API endpoint.

## 2) Scope
### In scope
- Creating a Password Change form component (Current, New, Confirm New).
- Client-side validation (matching new passwords).
- Wiring to the API `PATCH /user/` endpoint.
- Toast notifications for success/failure feedback.

### Out of scope
- API modifications.

## 3) Inputs / Source Docs
- `finance_manager_reflex/features/profile/`
- `finance_manager_reflex/finance_manager_reflex/ui/primitives.py`
- `plans/PLAN_API_Password_Change_2026-04-25.md` (Dependency - API must be updated first)

## 4) Constraints & Guardrails
- **Rule #9 (Feature Tracking):** Ensure this UI requires the updated API payload (`old_password`, `new_password`).
- **Design Fidelity:** Use `surface_card` and `primary_button` with loading states to give tactile feedback during the API call.

## 5) Execution Breakdown

### Task T1: Password Change State
- **Goal:** Add state variables and the API call logic.
- **Files to edit:** `finance_manager_reflex/features/profile/state.py` (or equivalent profile state).
- **Design Fidelity:** Ensure error messages are clear and human-readable.
- **Implementation notes:** 
    - Variables: `current_password`, `new_password`, `confirm_password`.
    - Function: `handle_password_change` that checks if new matches confirm, then sends the payload to the API.

### Task T2: UI Component Implementation
- **Goal:** Build the visual form.
- **Files to edit:** `finance_manager_reflex/features/profile/views.py`.
- **Design Fidelity:** Use standard spacing and `text_input(type="password")` primitives.
- **Implementation notes:** Group the inputs logically within a `surface_card`. Add a submit button that binds to the state handler.

## 6) Verification Plan
- Reflex Smoke Checks: Verify form validation prevents submission if passwords don't match. Verify toast appears on API success/failure.

## 7) Documentation & Feature Tracking
- [ ] Update `CHANGELOG.md` for Reflex.
- [ ] Move plan to `plans/archived/` upon completion.
