# PLAN_API_DB_Migration_Verification_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_API_DB_Migration_Verification_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P0` (Critical for data safety)
- Target repos/areas: `finance_manager_api` (Database/Scripts)

## 1) Objective
Verify that the existing SQLite-to-PostgreSQL migration scripts are fully compatible with the current project architecture, Docker orchestration, and data models (specifically JSONField mappings).

## 2) Scope
### In scope
- Auditing `scripts/db_export.sh`, `scripts/db_import.sh`, and `scripts/db_migrate.sh`.
- Running a test migration from a populated SQLite DB to a containerized Postgres instance.
- Verifying data integrity for complex models (`Transaction`, `AppProfile`).
- Checking JSONField compatibility between SQLite and Postgres.

### Out of scope
- Implementation of new database features.
- Performance tuning of the Postgres instance.

## 3) Inputs / Source Docs
- `finance_manager_api/finance/models.py`
- `scripts/db_migrate.sh`
- `docker-compose.yml`
- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails
- **Rule #10 (Fix it Forever):** If a script fails, don't just patch the data—fix the script's logic to handle the edge case permanently.
- **Rule #6 (DB Hits):** Verify that the migration itself doesn't cause excessive hits or timeouts.

## 5) Execution Breakdown

### Task T1: Script Audit
- **Goal:** Review the current migration scripts for hardcoded paths or outdated environment variables.
- **Files to edit:** `scripts/db_*.sh`.
- **Implementation notes:** Ensure they respect the new `.env` based DB configuration.

### Task T2: Sandbox Migration Test
- **Goal:** Populate a local SQLite DB with fake data and run the migration script into a temporary Postgres container.
- **Verification commands:** `bash scripts/db_migrate.sh`.
- **Acceptance criteria:** All records transferred; no JSON decoding errors in Postgres.

### Task T3: Data Integrity Pass
- **Goal:** Manually/programmatically verify that complex fields (like tags and spend_accounts) remain intact.
- **Files to edit:** Use a temporary verification script in `scratch/`.

## 6) Verification Plan
- **Migration Log Audit:** Check for any "Skipping" or "Error" messages during import.
- **API Check:** Run the API against the newly migrated Postgres DB and verify that a standard `GET /transactions` returns the correct data.

## 7) Documentation & Feature Tracking
- [ ] Update `finance_manager_api/CHANGELOG.md`.
- [ ] Document the "Certified Migration Path" for users.
- [ ] Archive plan upon completion.
