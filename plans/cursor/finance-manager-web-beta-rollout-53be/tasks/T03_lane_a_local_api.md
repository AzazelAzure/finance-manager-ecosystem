# T03 — Lane A: local API + SQLite (optional)

**Status (2026-04-29):** Done — see `finance_manager_web/README.md` section *Lane A — local API (SQLite) + Vite*; ecosystem `finance_manager_web` submodule at `d9a23c4`+ on branch `cursor/finance-manager-web-beta-rollout-53be`.

## Objective

Document and verify a repeatable local path: Django `runserver` + default SQLite + Vite dev server hitting `http://127.0.0.1:8000` (or chosen port).

## Steps

1. API: from `finance_manager_api`, with no `DB_NAME` / postgres env → SQLite per settings.
2. `python manage.py runserver 0.0.0.0:8000` (or `uv run`).
3. Web: `.env.development.local` with `VITE_API_BASE_URL=http://127.0.0.1:8000`.
4. CORS: include `http://localhost:5173` on API for SimpleJWT POST.

## Handoff output

- Exact commands
- Test user note (non-secret: “create superuser locally” instruction)

## Runtime

Update [Runtime Signup Sheet](../../../../design_docs/30_Releases/Runtime_Signup_Sheet.md) if local API conflicts with another agent.
