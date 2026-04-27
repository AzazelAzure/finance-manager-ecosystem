# Gemini Plan Template (for Cursor execution)

## 0) Metadata
- Plan ID: `PLAN_Reflex_Dockerization_2026-04-24`
- Owner: Gemini
- Requested by: User (with Cursor's suggestion)
- Status: `ready_for_cursor`
- Priority: `P1`
- Target repos/areas: `finance_manager_reflex/`

## 1) Objective
Dockerize the Reflex frontend application so it can be reliably mounted and tested by the user, setting the stage for the "Ready for User Testing" milestone and future deployments.

## 2) Scope
### In scope
- Creating a `Dockerfile` in `finance_manager_reflex/`.
- Creating a `docker-compose.yml` (or similar script) to easily spin up the Reflex container (and optionally link it to the local API for testing).
- Ensuring the Docker build uses the `uv.lock` file to guarantee identical dependency resolution.
- Providing a simple runbook/README instructions on how to build and mount the site locally.

### Out of scope
- Modifying the UI/UX or React components directly (this plan is purely infrastructure).
- Modifying the API's existing Docker setup (unless absolutely necessary for network bridging).

## 3) Inputs / Source Docs
- `finance_manager_reflex/pyproject.toml`
- `finance_manager_reflex/uv.lock`
- `design_docs/20_Roadmap/Phase_1_Alpha_Stabilization.md` (Step 4)

## 4) Constraints & Guardrails
- **Performance:** Keep the Docker image as slim as possible (e.g., multi-stage build, using a slim python base image).
- **Environment variables:** Ensure the Docker container can easily accept the API URL via environment variables so it can talk to the host machine's Django API or a containerized API later.
- User instruction overrides all plan details.

## 5) Execution Breakdown (Cursor-facing tasks)

### Task T1: Create Reflex Dockerfile
- Goal: Build a production-ready image for the Reflex app.
- Files to edit: `finance_manager_reflex/Dockerfile`, `finance_manager_reflex/.dockerignore`
- Implementation notes: Use a modern Python base image. Install `uv`. Copy `pyproject.toml` and `uv.lock`. Run `uv sync --frozen`. Expose the necessary Reflex port (usually 3000 or 8000). Set the command to `reflex run` (or the production equivalent).
- Acceptance criteria: The image builds successfully without dependency errors.

### Task T2: Create Local Mount/Compose Setup
- Goal: Provide a one-click command to run the Reflex UI for testing.
- Files to edit: `finance_manager_reflex/docker-compose.yml` (or add to a workspace-level compose file).
- Implementation notes: Define the service. Map the ports. Set a default `API_URL` environment variable pointing to `host.docker.internal` (or equivalent) so it can reach the local Django API.
- Acceptance criteria: Running `docker compose up` starts the UI and makes it accessible via a local browser.

### Task T3: Update Reflex Runbook
- Goal: Document how to test the UI.
- Files to edit: `finance_manager_reflex/README.md` (or a new `SETUP_RUNBOOK.md`).
- Implementation notes: Add a section "Running via Docker" with the exact commands needed to build and mount the site.
- Acceptance criteria: Clear, copy-pasteable instructions exist.

## 6) Subagent Request Protocol (when needed)
- Subagent type: `shell`
- Purpose: Test the Docker build process locally to ensure it doesn't fail on missing system dependencies.

## 7) Verification Plan
- Integration checks: Build the image locally (`docker build .`).
- CLI/manual smoke checks: Spin up the container and curl `localhost:<port>` to verify the Reflex server is responding.

## 8) Documentation Updates Required
- Update `design_docs/CHAT_LOG.md` upon completion.

## 9) Completion Criteria
Mark plan complete only when:
- The `Dockerfile` is created and optimized.
- The app can be mounted locally via Docker.
- The Cursor report is logged in `CHAT_LOG.md`.