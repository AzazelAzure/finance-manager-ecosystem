# T03 — parallel deploy implementation (2026-04-29)

## What shipped in the repo

1. **`docker-compose.bluegreen.parallel.yml`** — `redis`, `api-blue`, `api-green`, `reflex-blue`, `reflex-green` on **external** network `FM_STACK_NETWORK_NAME` (default `finance_manager_default`). **No** `db` or `proxy` in this file; `DB_HOST` defaults to `finance-manager-db` (live single-stack Postgres). **No** host port conflicts with legacy `finance_manager` stack.
2. **`scripts/fm_server_beta.sh`**
   - `FM_BG_PARALLEL=1` selects the parallel compose file (override with `FM_BLUEGREEN_COMPOSE_FILE`).
   - **`--env-file`** for podman-compose matches `fm_docker.sh`: `.secrets/server.env` or `.env` or `FM_ENV_FILE` — required for `SECRET_KEY` / DB env interpolation.
   - **`deploy`**: `up -d redis api-<color> reflex-<color>` (no `db`/`proxy` in parallel mode).
   - **`smoke`**: uses `curl` for Reflex (not `wget`). Skips public `curl` to `:8443` in parallel mode (edge is still single-stack).
   - **`switch` / `reload_proxy`**: still **unsupported** in parallel mode until the live proxy uses `nginx.bluegreen.conf` (separate work).
3. **`create_runtime_bundle.sh`**: includes the parallel compose file in VPS bundles.

## VPS verification (host agent)

- With legacy stack up, `FM_BG_PARALLEL=1` and production `FM_PUBLIC_*` / `FM_REFLEX_*` as needed: **`check`**, **`deploy green`**, **`smoke --color inactive`** completed successfully.
- **Breakpoint C** (minimum): `check` + parallel **deploy** + **smoke inactive** path is **achievable** without stopping single-stack.
- **Public URL** for inactive color still uses legacy proxy until edge cutover; parallel mode documents that.

## Next (not in this change)

- Wire **live** `finance-manager-proxy` to blue/green `active_color` + `nginx.bluegreen.conf` when you want **switch** and public traffic to a color.
- **JS web** (`web-blue` / `web-green`): follow `design_docs/40_System_Design/14_...` when ready.
