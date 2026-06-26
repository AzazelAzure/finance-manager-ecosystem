# F-012 Phase 1 Verification — 2026-06-26

## Local (developer workspace)

| Check | Result |
|-------|--------|
| `finance.tests.test_support*` + `test_support_tasks` | **12 tests OK** (`uv run python manage.py test …`) |
| POST `/finance/support/tickets/` bug path | Creates ticket, incident dump, email (locmem) |
| Feature gating | Covered in `test_support.py` |
| Rate limit 20/min | Covered in `test_support.py` |

## VPS production (active **blue**, `api-blue`)

| Check | Result | Notes |
|-------|--------|-------|
| API health | OK | `api-blue` healthy |
| `SupportTicket` row count | **0** | No production intake data yet |
| `logs/diagnostic/` | **empty** | No per-user files on disk |
| `logs/incidents/` | **empty** | No incident dumps |
| Celery worker / beat containers | **not running** | Only `redis` + `api-blue` in `podman ps` grep |

## Gaps found (Phase 2 targets)

1. Celery worker + beat not deployed on VPS — weekly digest and F-014 notify will not run until services are started.
2. SMTP / `BUG_REPORT_TO_EMAIL` env not verified on VPS containers.
3. Duplicate `celery-beat-blue` + `celery-beat-green` in compose (scheduler duplication risk when both run).

## Verdict

**Code path verified locally.** Production ops path **not** fully live until Celery + operator email env are deployed.
