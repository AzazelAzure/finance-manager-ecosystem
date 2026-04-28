# Server beta install (package layout)

This document describes the **initial** install scaffolding under `scripts/server/` and `deploy/`. Full blue-green runtime, proxy cutover, and deploy automation are tracked in later plan tasks (`T03` onward).

## Layout

| Path | Purpose |
|------|---------|
| `scripts/server/install_prereqs.sh` | Check host prerequisites (compose, Podman/Docker, `curl`). Does **not** install OS packages. |
| `scripts/server/bootstrap_env.sh` | Copy env template (`--from-example`) or validate secrets presence (`--validate-only`). |
| `scripts/server/render_env_template.sh` | Render `deploy/server.env.example` to `deploy/generated/server.env` (uses `envsubst` when installed). |
| `scripts/server/verify_install.sh` | Verify checkout layout (`docker-compose.yml`, subtree dirs). Optional HTTP health probe. |
| `deploy/server.env.example` | Documented variables; **no real secrets**. |
| `deploy/generated/` | Local render output directory (tracked empty except `.gitignore`). |

## Parameterizing workspace path

Scripts resolve the ecosystem repo root in this order:

1. **`FM_WORKSPACE`** or **`FM_WORKSPACE_ROOT`** if set (absolute path to the checkout root).
2. Otherwise inferred from script location (`scripts/server` → two levels up to repo root).

Do not rely on developer-specific home paths inside these scripts.

## Required OS tooling

Targets **Linux** with either **Podman** or **Docker** and a Compose implementation (`podman-compose`, `docker-compose`, or `docker compose`). `curl` is required for scripted checks.

## Podman versus Docker

The ecosystem supports both; prerequisite checks pass if at least one runtime and one compose pathway are present. Prefer Podman-aligned workflows where project scripts default to Compose files at repo root (`docker-compose.yml`).

## First install (conceptual flow)

1. Clone the repo and checkout the intended branch.
2. `./scripts/server/install_prereqs.sh`
3. Copy env template: `./scripts/server/bootstrap_env.sh --from-example`  
   Edit `deploy/server.env` (or override `FM_SERVER_ENV_FILE`).
4. `./scripts/server/bootstrap_env.sh --validate-only`
5. Optional: `./scripts/server/render_env_template.sh` if you substitute template variables outside manual editing.
6. `./scripts/server/verify_install.sh`  
   Optionally `FM_VERIFY_HTTP=1` when the stack is up locally or on server.

Dry-run variants: append `--dry-run` where documented on each script.

## Health verification

- Default `verify_install.sh` confirms files and directories only.
- With **`FM_VERIFY_HTTP=1`**, curls `FM_API_HEALTH_URL` (defaults to `http://localhost:8000/api/health/`).

## Secrets and `.secrets/`

- Commit **only** `deploy/server.env.example` style templates — never passwords, PEM material, or live tokens.
- Keep production values in a privileged store or host-managed files under restrictive permissions (`chmod 600`).
- Scripts do not automatically populate `.secrets/`; follow Phase B guidance in `plans/cursor/server-beta-install-bluegreen-53be/README.md`.
