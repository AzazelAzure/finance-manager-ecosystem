# T01 inventory results — executed 2026-04-29 (orchestrator)

Source: SSH `dev@159.198.75.194`, workspace `/home/dev/finance_manager`.

## Stack type

**Single-stack runtime** (live traffic) — `podman-compose` project `finance_manager`, `docker-compose.yml`.  
**Update 2026-04-29:** `docker-compose.bluegreen.yml` is now on the VPS via `push_runtime_bundle.sh` (bundle includes it per `create_runtime_bundle.sh`). Earlier inventory noted absence; that gap is closed for tooling validation.

### Re-check — “pseudo” blue-green (2026-04-29)

On disk under `proxy/` the VPS already has **blue-green prep**: `nginx.bluegreen.conf` and `active_color.conf` (`default blue;`).  
**Live** `proxy/nginx.conf` used by the running proxy is still the **single-stack** shape (`server_name thehivemanager.com …`, upstream `http://reflex:3000`), not the blue-green nginx entrypoint. There are **no** `fm-beta` / `api-blue` / `reflex-green` style containers — only `finance-manager-*` from the classic compose project.

So **pseudo blue-green** here means: BG **files** exist for future `fm_server_beta` + nginx `-t` checks, but **orchestration and second color** are not active; `fm_server_beta.sh` remains **blocked** until `docker-compose.bluegreen.yml` is on the server.

## Containers + health

| Name | Image | Status | Ports |
|------|-------|--------|-------|
| finance-manager-db | postgres:15-alpine | Up ~7h | 5432→5432 |
| finance-manager-api | finance_manager_api:latest | Up ~7h (healthy) | (none published in snippet) |
| finance-manager-reflex | finance_manager_reflex:latest | Up ~7h | (internal) |
| finance-manager-proxy | finance_manager_proxy:latest | Up ~7h | 8080→80, **8443→443** |

## `fm_server_beta.sh`

**After sync:** `status` and `check` succeed when run with production host probes, for example:

`FM_PUBLIC_APP_HOST=thehivemanager.com FM_PUBLIC_API_HOST=api.thehivemanager.com FM_PUBLIC_BASE_URL=https://127.0.0.1:8443 ./scripts/fm_server_beta.sh check`

Inactive-color **deploy** / **smoke** are the next Breakpoint C steps (not executed in the sync-only pass).

## Tunnel → proxy port (operator)

Direct read of `/etc/cloudflared` was **not** captured (sudo requires password).  
**Inferred from architecture + curls:** local HTTPS termination on proxy **`127.0.0.1:8443`** matches [known_good_beta_state_apr28.md](../../server-beta-install-bluegreen-53be/known_good_beta_state_apr28.md) (`noTLSVerify` toward tunnel).

## Domains tested (local proxy, `curl -kI`)

| Host header | URL | Result |
|-------------|-----|--------|
| `thehivemanager.com` | `https://127.0.0.1:8443/` | **HTTP/1.1 200 OK**, `text/html`, ~41k |
| `reflex-api.thehivemanager.com` | `https://127.0.0.1:8443/` | **HTTP/1.1 200 OK**, same body size/etag as row above |

**Note:** `reflex-api` vhost returned the same static HTML response as root host in this probe; websocket/API-specific routing was not validated here. Follow T02/B with `_event` or app login if issues persist.

## Drift vs known_good (Apr 28)

| Item | known_good | Observed 2026-04-29 |
|------|------------|---------------------|
| Stack | containerized podman-compose | Same |
| Core four containers | up | Up, api healthy |
| `fm_server_beta.sh check` | documented dry-run path | **Passes** on VPS after bundle sync (compose + nginx `-t`) |
| Public routing | 8443 + hostnames | 200 OK on sampled Host headers |

## Sibling plan

Skimmed expectation: coordinate proxy/DNS with [finance-manager-web-beta-rollout-53be/validation_gates.md](../finance-manager-web-beta-rollout-53be/validation_gates.md) before nginx changes.

## Breakpoint A

**Pass (inventory):** factual map recorded in this file + `runtime_handoff.md` updated.  
**Follow-up for B/C:** T02 env block documented in handoff; run T03 `deploy` + `smoke --color inactive` when runtime owner approves; no `switch` until governance `pre_cutover`.
