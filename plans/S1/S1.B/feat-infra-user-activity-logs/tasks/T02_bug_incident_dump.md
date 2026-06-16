---
task_id: T02
status: pending
owner: pproctor
phase: S1.B
intended_branch: agy/s1b/feat/infra-user-activity-logs
last_verification: null
---

# T02 — Bug Incident Dump Extraction

## Objective
Extract log window entries spanning the 10 minutes preceding a bug ticket submission, format the incident dump, write it to a dedicated incident log file, and store the file reference path in the database as `diagnostic_log_key`.

## Repo scope
- `finance_manager_api/`

## Decomposed Slices
- **T02.SL1: Implement preceding log window extractor**
  - Implement extractor in `finance/utils/incident_extractor.py`.
  - The utility must take a `user_id` (UUID) and a starting `datetime` timestamp.
  - Parse the user's specific diagnostic log file `logs/diagnostic/{user_id}.log`.
  - Filter log entries to only return lines with timestamps falling within the window: `[ticket_creation_time - 10 minutes, ticket_creation_time]`.
  - Address timezone parsing and ISO formats correctly.
- **T02.SL2: Implement incident dump creation on SupportTicket creation**
  - Modify the backend Support API view (`finance/views/support.py`).
  - Upon receiving a ticket of type `bug`:
    - Invoke the window extractor helper.
    - Write the extracted log entries into `logs/incidents/incident_{ticket_id}.log`.
    - Set `SupportTicket.diagnostic_log_key` to the path or file identifier.
- **T02.SL3: Verify incident extraction and database key mapping via tests**
  - Add tests validating that when a bug ticket is saved, the incident log file is populated only with the correct log lines.
  - Verify that if no logs exist, the file is created empty or with a placeholder, and `diagnostic_log_key` is correctly populated.
  - Verify feature requests do not trigger incident file creation.

## Definition of Done
- Extract helper parses timezone-aware logs correctly.
- Incident file is generated at `logs/incidents/incident_{ticket_id}.log` for bug tickets.
- `SupportTicket.diagnostic_log_key` is stored in the database.
- Unit and integration tests pass successfully.

## Verification Tiers
- **V1 (Local tests)**: Run backend tests locally:
  ```bash
  cd finance_manager_api && poetry run pytest finance/tests/test_incident_dump.py
  ```

## Risks
- Giant log files leading to slow parsing / timeouts during ticket creation. Implement a read limit cap (e.g. read only the last N lines or stop reading past 5MB).
- Clock drift or timezone mismatch between the application server and log timestamps.
