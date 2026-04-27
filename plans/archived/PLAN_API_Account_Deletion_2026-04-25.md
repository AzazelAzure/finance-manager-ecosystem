# PLAN_API_Account_Deletion_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_API_Account_Deletion_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P1`
- Target repos/areas: `finance_manager_api` (Views/Signals/Models)

## 1) Objective
Ensure that account deletion is a complete and secure process. Verify that deleting a user account cascades to all associated financial data (Zero-Knowledge / Data Privacy compliance) and update the `DELETE` endpoint to require password confirmation.

## 2) Scope
### In scope
- Updating `UserView.delete` to require password verification.
- Reviewing and implementing Django signals or `on_delete` behaviors for models tied to `uid`.
- Writing tests to verify data wipe.

### Out of scope
- Soft deletes (account deletion must be permanent for compliance).
- Reflex frontend changes (handled in separate plan).

## 3) Inputs / Source Docs
- `finance_manager_api/finance/views/usr_views.py`
- `finance_manager_api/finance/models.py`
- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails
- **Rule #10 (Fix it Forever):** Data must be completely wiped. Do not rely solely on the frontend. Implement robust backend checks.
- **Security:** Deletion is a destructive action. Require the current password to authorize it.

## 5) Execution Breakdown

### Task T1: Data Wipe Verification (Signals/Cascade)
- **Goal:** Ensure all related user data is deleted when a `User` instance is deleted.
- **Files to edit:** `finance_manager_api/finance/models.py` or `finance_manager_api/finance/api_tools/signals.py`.
- **Implementation notes:** 
    - Check the TODOs in `models.py` regarding UUID decoupling and `on_delete` signals.
    - If models use a CharField `uid` instead of a ForeignKey, create a `post_delete` signal for the `User` model that deletes all `AppProfile`, `PaymentSource`, `Category`, `Tag`, `UpcomingExpense`, `Transaction`, and `FinancialSnapshot` records where `uid` matches the deleted user's ID.
- **Acceptance criteria:** A test confirms that deleting a User results in 0 records for that user across all financial tables.

### Task T2: Secure Delete Endpoint
- **Goal:** Update the `UserView.delete` endpoint to require password authorization.
- **Files to edit:** `finance_manager_api/finance/views/usr_views.py`
- **Implementation notes:** 
    - Require `password` in the request data.
    - Call `request.user.check_password(request.data['password'])`.
    - If valid, proceed with deletion.
- **Acceptance criteria:** Endpoint returns 403 if password is missing or incorrect.

## 6) Verification Plan
- Unit tests: Write a DRF APITestCase testing account deletion with correct and incorrect passwords, and verifying DB state post-deletion.

## 7) Documentation & Feature Tracking
- [ ] Update `CHANGELOG.md` for API.
- [ ] Move plan to `plans/archived/` upon completion.
