---
task_id: T01
status: pending
owner: pproctor
phase: S1.B
intended_branch: agy/s1b/feat/infra-user-activity-logs
last_verification: null
---

# T01 — Loguru Dynamic User Sinks

## Objective
Configure Loguru sinks to dynamically write warning, error, and traceback logs for authenticated users to individual log files keyed by their UUID context.

## Repo scope
- `finance_manager_api/`

## Decomposed Slices
- **T01.SL1: Logs directory path alignment**
  - Ensure logs directory exists at `/app/logs/diagnostic/` inside the running environment or configure relative fallback paths (e.g. `logs/diagnostic/`).
  - Update `finance_manager_api/finance/management/logging_config.py` (or the equivalent logging config file) to ensure consistent base paths.
- **T01.SL2: Authenticated user filter and loguru sink configuration**
  - Build or update the Loguru sink filter. The filter should verify the presence of `extra["uid"]` and ensure it is a valid UUID (not "anonymous" or missing).
  - Register the dynamic log file sink in Loguru configuration using a format like `logs/diagnostic/{extra[uid]}.log`.
  - Set rotation policies (e.g. 10MB or daily), retention TTL (e.g. 14 days), and max total limit (e.g. 5GB total).
- **T01.SL3: Dynamic user log file test cases**
  - Add test suite verifying that authenticated requests write logs to files named after the user UUID.
  - Verify that anonymous requests do not trigger dynamic log file creation.
  - Verify rotation and retention logic (via mocks or programmatic checks).

## Definition of Done
- Loguru config successfully filters and routes authenticated logs to `logs/diagnostic/{user_id}.log`.
- No files are created for anonymous requests.
- All test cases pass.

## Verification Tiers
- **V1 (Local tests)**: Run unit tests locally:
  ```bash
  cd finance_manager_api && poetry run pytest finance/tests/test_loguru_sinks.py
  ```

## Risks
- Path traversal if the UUID format validation is bypassed.
- File handle exhaustion if too many log sinks are left open.
