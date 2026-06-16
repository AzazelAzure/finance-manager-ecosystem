---
task_id: T02
status: completed
owner: pproctor
phase: S1.B
intended_branch: agy/s1b/feat/infra-support-intake
last_verification: null
---

# T02 — Celery digest task and SMTP config

## Objective
Configure Celery, initialize the Celery app, set up the beat schedule, implement a weekly Celery task to gather and send feature requests via SMTP email, and write test cases.

## Repo scope
- `finance_manager_api/`

## Decomposed Slices
- **T02.SL1: Add Celery and Redis Dependencies**
  - Add `celery` and `redis` dependencies to `finance_manager_api/pyproject.toml` (if not already present).
  - Run package installation update.
- **T02.SL2: Configure Celery App and Settings**
  - Initialize the Celery application (e.g., `finance_manager_api/celery.py`).
  - Configure Django settings with Celery settings (`CELERY_BROKER_URL`, `CELERY_RESULT_BACKEND`, SMTP settings).
  - Configure the Celery beat scheduler to run the weekly task (e.g. every Monday at 08:00 UTC).
- **T02.SL3: Implement send_weekly_feature_requests_email Task**
  - Implement task in `finance/tasks/support_digest.py` or similar location.
  - Query database for `SupportTicket` instances of type `feature_request` created in the past 7 days.
  - Format list of feature requests into an HTML/text template.
  - Send email using Django `send_mail` or `EmailMultiAlternatives` to designated operator address (using SMTP configured through env vars).
- **T02.SL4: Celery Task Tests**
  - Add unit/integration tests to verify task querying logic, formatting, and correct invocation of `django.core.mail.outbox`.

## Definition of Done
- Celery worker/beat and Redis are configured in Django.
- Celery task queries the database correctly and targets only feature requests from the past 7 days.
- Weekly scheduler triggers the task at the designated schedule.
- Task tests run and pass locally.

## Verification Tiers
- **V1 (Local tests)**: Run task tests locally:
  ```bash
  cd finance_manager_api && poetry run pytest finance/tests/test_support_digest.py
  ```

## Risks
- SMTP credentials leak (ensure passwords/host are injected via ENV vars).
- SMTP connection timeouts block Celery worker threads.
