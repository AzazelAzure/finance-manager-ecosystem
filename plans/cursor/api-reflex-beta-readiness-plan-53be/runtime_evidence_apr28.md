# API + Reflex Runtime Evidence (Apr 28, 2026)

## Objective
Capture concrete execution evidence for API production hardening, API test status, and Reflex/proxy smoke checks for beta readiness.

## Breakpoint A Evidence (Runtime baseline)
- Local runtime (`scripts/fm_docker.sh status`) shows:
  - `finance-manager-db` up
  - `finance-manager-api` up (healthy)
  - `finance-manager-reflex` up
  - `finance-manager-proxy` up
- VM runtime (`dev@192.168.122.41`) shows the same stack state and healthy API.
- Proxy frontend reachability:
  - local: `curl -k -H 'Host: financemanager.local' https://localhost:8443/` -> `200`
  - VM: same command -> `200`

## Breakpoint B Evidence (API hardening + tests)
- Deploy check command:
  - `SECRET_KEY=... DEBUG=False ALLOWED_HOSTS=... SECURE_SSL_REDIRECT=True SESSION_COOKIE_SECURE=True CSRF_COOKIE_SECURE=True SECURE_HSTS_SECONDS=3600 SECURE_HSTS_INCLUDE_SUBDOMAINS=True SECURE_HSTS_PRELOAD=True uv run python manage.py check --deploy`
- Result:
  - `System check identified no issues (0 silenced).`
- Full API suite:
  - `SECRET_KEY=... uv run pytest -q`
  - result: `171 passed, 4 skipped` (plus warnings/subtests)

## Breakpoint C Evidence (Reflex smoke)
- Reflex proxy route reachable on local + VM (`200` from frontend route).
- Recent Reflex logs show normal compile/startup with no crash loop.
- Recent proxy logs show expected frontend/API health traffic and websocket upgrades.

## Changes made during this execution phase
- In `finance_manager_api` feature branch `cursor/api-beta-hardening-hsts-53be`:
  - Added env-driven settings:
    - `SECURE_HSTS_INCLUDE_SUBDOMAINS`
    - `SECURE_HSTS_PRELOAD`
  - Updated API `.env.example` with deploy-hardening flags.
  - Updated API changelog with HSTS flag support notes.

## Remaining work for final readiness gate
1. Open API PR for branch `cursor/api-beta-hardening-hsts-53be` and complete review/merge flow.
2. Sync design docs (`T05`) with pass/partial/blocked status and unresolved launch risks.
3. Reconcile PR automation + GitHub mergeability before completion declaration.
