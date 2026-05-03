# T02 — CORS + login diagnostics

## Objective

Eliminate “false connectivity” failures: distinguish wrong password, wrong `VITE_API_BASE_URL`, and CORS/preflight failure.

## Steps

1. In browser devtools Network tab: capture failed `POST /api/token/` — status, response body, response headers (`access-control-allow-origin`).
2. Compare browser **Origin** (e.g. `http://localhost:5173`) to API `CORS_ALLOWED_ORIGINS` in [`settings.py`](../../../finance_manager_api/finance_api/settings.py).
3. Add missing origins; redeploy API if testing against VPS API.
4. Optionally: in `LoginPage`, show `error.response?.status` and short message when `import.meta.env.DEV`.

## Handoff output

- Before/after curl: `curl -i -X OPTIONS ...` with `Origin:` header
- PR link for API if changed

Update [../CROSS_AGENT_COORDINATION.md](../CROSS_AGENT_COORDINATION.md) **Last API changes**.
