# Gemini Plan: Reflex Docker Stability & Performance Fix

## 0) Metadata
- Plan ID: `PLAN_Reflex_Docker_Stability_Fix_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P1`
- Target repos/areas: `finance_manager_reflex`, `docker-compose.yml`

## 1) Objective
Diagnose and resolve the "hang" and "stall" issues during the Reflex frontend Docker container startup. Optimize the build process to minimize runtime initialization delays.

## 2) Scope
### In scope
- Dockerfile optimizations for `finance_manager_reflex`.
- Environment variable tuning for Reflex.
- Docker Compose healthcheck implementations.
### Out of scope
- Changes to the Reflex application UI or logic.
- Production Kubernetes deployment.

## 3) Inputs / Source Docs
- `finance_manager_reflex/Dockerfile`
- `docker-compose.yml`
- [Reflex Self-Hosting Docs](https://reflex.dev/docs/hosting/self-hosting/)

## 4) Constraints & Guardrails
- **Golden Rule 10 (Fix it Forever)**: We need a structural fix for the initialization hang, not just a longer timeout.
- **Maintain Dev/Prod Parity**: The fix should work in the current local development simulation.

## 5) Execution Breakdown

### Task T1: Dockerfile Optimization (Pre-Initialization)
- **Problem**: Reflex downloads Node.js and NPM during the first `reflex run` if not present. In a Docker container, this happens at runtime, causing a significant hang.
- **Goal**: Move Node/NPM initialization to the **build phase**.
- **Actions**:
    - Update `Dockerfile` to run `reflex init` or a dummy run during build to populate the `.reflex` directory.
    - Set `REFLEX_TELEMETRY_ENABLED=0` to prevent external network calls during startup.
    - Ensure `uv` cache is utilized effectively.

### Task T2: Docker Compose Health & Dependency Tuning
- **Problem**: Reflex starts as soon as the `api` container is created, but it may hang if it tries to connect before the Django server is actually listening.
- **Goal**: Ensure the API is healthy before Reflex starts.
- **Actions**:
    - Add a `healthcheck` to the `api` service (e.g., checking `/api/schema/`).
    - Update `reflex` service `depends_on` to use the `service_healthy` condition.

### Task T3: Environment Variable & Config Audit
- **Goal**: Ensure Reflex backend and frontend URLs are correctly resolved within the Docker network.
- **Actions**:
    - Verify `REFLEX_API_URL` and `REFLEX_DEPLOY_URL` mapping in `docker-compose.yml`.

## 6) Verification Plan

### Automated Tests
- `docker-compose up --build reflex`: Verify that the container starts up significantly faster and reaches the "listening" state without manual intervention.

### Manual Verification
- Access `https://financemanager.local:8443` and verify the dashboard loads data correctly.
