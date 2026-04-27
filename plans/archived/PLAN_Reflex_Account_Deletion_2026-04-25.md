# PLAN_Reflex_Account_Deletion_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Account_Deletion_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P1`
- Target repos/areas: `finance_manager_reflex` (Profile Feature)

## 1) Objective
Implement a secure, confirmation-gated UI flow for account deletion. This protects the user from accidental deletion by requiring explicit manual input ("DELETE" or "CONFIRM") and their current password.

## 2) Scope
### In scope
- Creating a "Danger Zone" section in the Profile settings.
- Implementing an Account Deletion modal/dialog.
- Adding input fields for password and confirmation text.
- Wiring to the API `DELETE /user/` endpoint.
- Handling post-deletion state (logout and redirect to splash/login).

### Out of scope
- API modifications.

## 3) Inputs / Source Docs
- `finance_manager_reflex/features/profile/`
- `finance_manager_reflex/finance_manager_reflex/ui/primitives.py`
- `plans/PLAN_API_Account_Deletion_2026-04-25.md` (Dependency - API must be updated first)

## 4) Constraints & Guardrails
- **Design Fidelity:** The deletion action must feel serious. Use the `danger` color token for buttons and clear, unambiguous warning text in the modal.

## 5) Execution Breakdown

### Task T1: Account Deletion State
- **Goal:** Add state variables to manage the deletion modal and API call.
- **Files to edit:** `finance_manager_reflex/features/profile/state.py` (or equivalent profile state).
- **Implementation notes:** 
    - Variables: `delete_modal_open`, `delete_password`, `delete_confirm_text`.
    - Function: `handle_account_deletion` that verifies `delete_confirm_text` == "DELETE", sends the password to the API, and on success clears local session state and redirects to `/`.

### Task T2: UI Component Implementation
- **Goal:** Build the visual modal and trigger button.
- **Files to edit:** `finance_manager_reflex/features/profile/views.py`.
- **Implementation notes:** 
    - Add a "Danger Zone" `surface_card` at the bottom of the profile.
    - Create an `rx.dialog` (or equivalent modal primitive) that contains the warning text, the password input, and the confirmation text input.
    - The final "Delete My Account" button should remain disabled until the confirmation text exactly matches "DELETE".

## 6) Verification Plan
- Reflex Smoke Checks: Verify modal opens. Verify final button is disabled until correct text is typed. Verify successful deletion redirects to the login page and clears session.

## 7) Documentation & Feature Tracking
- [ ] Update `CHANGELOG.md` for Reflex.
- [ ] Move plan to `plans/archived/` upon completion.
