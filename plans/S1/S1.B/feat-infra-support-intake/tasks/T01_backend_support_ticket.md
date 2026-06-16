---
task_id: T01
status: completed
owner: pproctor
phase: S1.B
intended_branch: agy/s1b/feat/infra-support-intake
last_verification: null
---

# T01 — Backend Support Ticket

## Objective
Implement Django model, migrations, API view, validation, permission check, feature gating, and tests for the support ticket intake.

## Repo scope
- `finance_manager_api/`

## Decomposed Slices
- **T01.SL1: Django SupportTicket Model and Migration**
  - Create the `SupportTicket` model under `finance/models.py`.
  - Fields: `id` (UUID), `user` (ForeignKey to `AppProfile`), `ticket_type` (ChoiceField: bug/feature_request), `subject` (CharField, max 150), `description` (TextField, min 10), `metadata` (JSONField, optional), `diagnostic_log_key` (CharField, max 255, optional), `created_at` (DateTimeField).
  - Generate database migrations.
- **T01.SL2: API Serializer and Validation**
  - Implement the serializer in `finance/serializers/support.py` or `finance/api_tools/serializers.py`.
  - Validate that `ticket_type` is one of `bug` or `feature_request`.
  - Validate that if `ticket_type` is `feature_request`, the user's profile has `feature_requests_enabled` set to `True`.
- **T01.SL3: Create View and Endpoint Routing**
  - Add API view at `finance/views/support.py` handling `POST` requests.
  - Authenticate the user and associate the user context with the ticket.
  - Expose routing at `/finance/support/tickets/` in `finance/urls.py`.
  - Ensure the serializer returns the created ticket database record.
- **T01.SL4: Backend Tests Verification**
  - Add test suite under `finance/tests/test_support.py` validating correct schema generation, authentication permissions, serializer validation rules (gated feature request tabs, string lengths, empty check), view response codes (`201` for success, `400` for failed validations).

## Definition of Done
- Database migrations generated and run successfully.
- Code style is compliant.
- API validation and permission logic fully implemented.
- Verification passes on local pytest suite.

## Verification Tiers
- **V1 (Local tests)**: Run backend tests locally:
  ```bash
  cd finance_manager_api && poetry run pytest finance/tests/test_support.py
  ```

## Risks
- Django database lock during migration deployment.
- PII validation constraints to ensure no secrets or sensitive payment info is exposed in the ticket fields.
