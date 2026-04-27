# PLAN_API_Password_Change_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_API_Password_Change_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P1`
- Target repos/areas: `finance_manager_api` (Views/Serializers)

## 1) Objective
Enhance the security of the password change endpoint (`UserView.patch`). The endpoint must require and verify the user's current password before accepting a new password to prevent unauthorized account takeovers.

## 2) Scope
### In scope
- Creating a `PasswordChangeSerializer`.
- Modifying `UserView.patch` in `usr_views.py`.
- Implementing `user.check_password()` verification.

### Out of scope
- Reflex frontend changes (handled in separate plan).
- Password reset via email (forgot password).

## 3) Inputs / Source Docs
- `finance_manager_api/finance/views/usr_views.py`
- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails
- **Rule #10 (Fix it Forever):** Do not just patch the view; use a proper DRF Serializer to validate the `old_password` against the current user's hashed password.
- **Rule #4 (Separation of Concerns):** Keep validation logic in the serializer, not the view.

## 5) Execution Breakdown

### Task T1: PasswordChangeSerializer
- **Goal:** Create a serializer to handle `old_password` and `new_password`.
- **Files to edit:** `finance_manager_api/finance/api_tools/serializers/base_serializers.py`
- **Design Fidelity:** N/A (Backend logic).
- **Implementation notes:** 
    - `old_password = serializers.CharField(required=True)`
    - `new_password = serializers.CharField(required=True)`
    - Add a `validate_old_password` method that uses `self.context['request'].user.check_password(value)`.
- **Acceptance criteria:** Serializer rejects invalid old passwords.

### Task T2: Update UserView PATCH
- **Goal:** Wire the new serializer to the existing PATCH endpoint.
- **Files to edit:** `finance_manager_api/finance/views/usr_views.py`
- **Design Fidelity:** N/A.
- **Implementation notes:** 
    - Replace the current manual `set_password` logic.
    - If valid, update the user's password and save.
- **Acceptance criteria:** Endpoint returns 200 on success, 400 on incorrect old password.

## 6) Verification Plan
- Unit tests: Write a DRF APITestCase testing correct and incorrect old password submissions.
- Integration/Reflex Smoke Checks: N/A.

## 7) Documentation & Feature Tracking
- [ ] Update `CHANGELOG.md` for API.
- [ ] Move plan to `plans/archived/` upon completion.
