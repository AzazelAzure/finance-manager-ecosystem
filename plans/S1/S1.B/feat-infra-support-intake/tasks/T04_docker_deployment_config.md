---
task_id: T04
status: completed
owner: pproctor
phase: S1.B
intended_branch: agy/s1b/feat/infra-support-intake
last_verification: null
---

# T04 — Docker Deployment Configuration

## Objective
Define Celery worker, Celery beat, and Redis services in local and production compose configurations, and mount shared logs volumes to support per-user diagnostic logging.

## Repo scope
- Repository root config files (`docker-compose.yml`, `docker-compose.bluegreen.yml`, etc.)

## Decomposed Slices
- **T04.SL1: Local Compose configuration**
  - Add Celery worker and Celery beat services to local `docker-compose.yml`.
  - Link services to the existing Redis instance.
  - Set appropriate environment variables (DB credentials, timezone, etc.).
- **T04.SL2: Bluegreen Compose configuration**
  - Integrate Celery worker, Celery beat services into the blue/green container definitions inside `docker-compose.bluegreen.yml`.
  - Maintain color separation for the background workers (e.g. `celery_worker_blue`, `celery_worker_green`).
- **T04.SL3: Shared logs volume configuration**
  - Mount a shared logs volume directory (e.g. `logs:/app/logs`) between the Django API container, Celery worker/beat containers, and the host machine.
  - Verify container file system permissions allow writing logs to the mounted volume directory.

## Definition of Done
- Celery services successfully boot up under Docker Compose.
- Redis serves as the broker for local and bluegreen worker runs.
- Shared log volume is configured and logs from containers write successfully to the host directory.

## Verification Tiers
- **V2 (Integration / Deployment)**: Deploy services and verify log writing and task execution:
  ```bash
  docker compose up -d --build
  docker compose logs worker
  ```

## Risks
- Celery worker starting before DB migrations complete.
- Race conditions or permissions mismatches on the mounted shared volume directory.
