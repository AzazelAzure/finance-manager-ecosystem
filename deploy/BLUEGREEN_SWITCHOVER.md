# Blue/green switchover: hostnames, active color, and operator checklist

This document aligns **Nginx** (`proxy/nginx.bluegreen.conf`), **`proxy/active_color.conf`**, and **`scripts/fm_server_beta.sh`** so production and pre-cutover traffic behave predictably.

## Terminology

| Term | Meaning |
|------|--------|
| **Active color** | The color **public** hostnames use for **web + API** today. Must be `blue` or `green` in `active_color.conf`. |
| **Inactive color** | The other color. Used for **staging** the next build before you promote it. |

## What each hostname does

| Hostname | Web (React) | API |
|----------|-------------|-----|
| `thehivemanager.com`, `www.thehivemanager.com` | **Active** (`web-{active}`) | (HTML only; API is separate) |
| `api.thehivemanager.com` | — | **Active** (`api-{active}`) |
| `jsdevtesting.thehivemanager.com` | **Inactive** (`web-{inactive}`) | **Inactive** via `api-jsdevtesting.*` (see below) |
| `api-jsdevtesting.thehivemanager.com` | — | **Inactive** (`api-{inactive}`) — pair with the staging web host |

**Rule you asked for:** After a **swap** (e.g. promote `green` → active), **regular traffic** takes the **new** active color, and **`jsdevtesting` automatically points at the new inactive color** (implemented via `$js_devtesting_web_backend` in `nginx.bluegreen.conf`).

## Operator checklist: promote inactive → active

Run from the ecosystem repo root on a host that can drive Compose + proxy (VPS or controlled runner).

1. **Confirm current active color**  
   `./scripts/fm_server_beta.sh status`  
   or read `proxy/active_color.conf` (must contain `default blue;` or `default green;` only).

2. **Ship code to the *inactive* color**  
   - In each sub-repo, checkout the commit you intend to release.  
   - **Preferred (Podman + this repo):** from the ecosystem root, rebuild and recreate **only** that color’s API + web **and** bounce the shared proxy (avoids `depends_on` / `--requires` remove failures):  
     `./scripts/fm_server_beta.sh rebuild-color green`  
     Use `--no-build` if images are already built. The proxy restarts briefly (both colors share one edge).  
   - **First-time / missing containers only:** `./scripts/fm_server_beta.sh deploy green` (no image rebuild).  
   - **Manual:** `podman-compose … build api-green web-green` then the same `rebuild-color` stop/rm/up sequence the script encodes — do not rely on `up -d --force-recreate api-green web-green` alone on Podman while `proxy` is running.

3. **Smoke the candidate (inactive) stack**  
   `./scripts/fm_server_beta.sh smoke --color green` (or `inactive` / the color you will promote).  
   Fix failures before switching.

4. **(Recommended) Open `https://jsdevtesting…` in a browser**  
   You get the **inactive** web bundle **and** (with a current `finance_manager_web` build) the **inactive** API: the SPA calls `https://api-jsdevtesting.thehivemanager.com`, which Nginx maps to `api-{inactive}`. Rebuild `web-*` after adding this behavior.

5. **Promote (atomic routing change)**  
   `./scripts/fm_server_beta.sh switch --to green`  
   This rewrites `proxy/active_color.conf` and **reloads Nginx** in the proxy container. **No image rebuild** is required for the switch itself.

6. **Verify public paths**  
   - Site: `https://thehivemanager.com/` (active web).  
   - API: `https://api.thehivemanager.com/api/health/` (active API).  
   - `./scripts/fm_server_beta.sh smoke --color active`

7. **If something is wrong**  
   `./scripts/fm_server_beta.sh rollback` (restores prior active color from `/.secrets/last_active_color` when available).

8. **Document and monitor**  
   Note which commit is on which color, and watch API/proxy logs after the cut.

## When production should stay on `blue` while you “repair” `green`

- Set **`active_color.conf`** so **`default blue;`** (or run `./scripts/fm_server_beta.sh switch --to blue` if you need a script-driven write + reload).  
- **Public** traffic: `thehivemanager.com` + `api.thehivemanager.com` → **blue**.  
- **`jsdevtesting`** (with current Nginx): → **green** (inactive) so you can validate the next web build without moving users.

If **`jsdevtesting` looks unchanged**, typical causes are:

- **Web image** for the inactive color was not rebuilt after your fix (`web-green:latest` still old). Rebuild and recreate `web-green`.  
- **Browser or CDN cache** on `jsdevtesting` — hard refresh or purge.  
- **Nginx on the server** is an old file (not copied from repo) — copy `proxy/nginx.bluegreen.conf` and reload the proxy.

## Staging API: `api-jsdevtesting` (full-stack validation before cutover)

**Behavior:** Nginx serves **`https://api-jsdevtesting.thehivemanager.com`** → always the **inactive** `api-*` (same `active_color` map inversion as the inactive web on `jsdevtesting`).

**Web app:** `finance_manager_web` uses `resolveApiBaseUrl()` — on hostname `jsdevtesting.thehivemanager.com` only, the Axios base URL is **`VITE_STAGING_API_BASE_URL`** (default `https://api-jsdevtesting.thehivemanager.com`). All other hostnames use **`VITE_API_BASE_URL`**.

**Auth note:** sessions/tokens for `api-jsdevtesting` are **separate** from production (`api.thehivemanager.com`) — you typically **log in again** on the staging site to exercise the inactive stack. Refresh tokens do not move between the two API hostnames.

### DNS and TLS (operator)

1. **DNS** — add `api-jsdevtesting` the same way as `api` (e.g. A/AAAA to the origin or Cloudflare proxy), pointing at the same edge as the rest of the app.  
2. **TLS** — the Nginx `server` block reuses the **same** cert key paths as `api` in the repo examples (`api.financemanager.local.pem`). In production, use a cert whose **SAN** (or wildcard `*.thehivemanager.com`) includes **`api-jsdevtesting.thehivemanager.com`**, or browsers will show certificate errors.  
3. **Django** — ensure `ALLOWED_HOSTS` and `CSRF_TRUSTED_ORIGINS` (see `settings.py` defaults) include the new host; override via env in `.secrets/server.env` if you use a different domain.

## Files involved

| File | Role |
|------|------|
| `proxy/nginx.bluegreen.conf` | Apex + `api` + `api-jsdevtesting` + `jsdevtesting`. |
| `proxy/active_color.conf` | `map $request_uri $fm_active_color { default <blue\|green>; }` — **single source of truth** for which color is active. |
| `finance_manager_web/src/lib/apiBaseUrl.ts` | Picks staging API base URL on `jsdevtesting` host only. |
| `scripts/fm_server_beta.sh` | Updates `active_color.conf`, reloads proxy, `deploy`, **`rebuild-color`**, `smoke` / `switch` / `rollback`. |

## Gaps to avoid next time

1. **Promoted without rebuilding inactive images** — production serves old images with new routes.  
2. **Mismatched `active_color` on the server** vs. what the team believed — always `status` and hit `/api/health/` for the active color after `switch`.  
3. **Stale `web-*` image** on the server without `VITE_STAGING_API_BASE_URL` in the build — `jsdevtesting` will not call `api-jsdevtesting` until you rebuild.  
4. **Editing Nginx on the server but not in Git** — drift. Treat repo as source of truth; copy and reload, then commit.  
5. **Skipping smoke before `switch`** — the script runs a pre-switch smoke, but you should also manually verify critical flows for your release.
6. **Missing `api-jsdevtesting` in DNS or TLS** — the staging hostname will not resolve or will show cert warnings.
7. **Podman + `depends_on` / `--requires` on `proxy`** — do not rely on `podman-compose up --force-recreate api-* web-*` alone; removal often fails while `proxy` exists. Use **`./scripts/fm_server_beta.sh rebuild-color <blue|green>`** (stops proxy + that color’s api/web, `podman rm`s by compose labels, then `up -d` db/redis/api/web/proxy). Expect a **short** interruption on shared proxy ports (`:8443` / `:8080`) during that window. For API-only cache busting, add `--no-build` on web when appropriate, or extend the script pattern as needed.
