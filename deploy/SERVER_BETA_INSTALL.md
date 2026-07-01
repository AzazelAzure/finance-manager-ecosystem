# Server beta install (package layout)

This document describes install scaffolding under `scripts/ops/` plus blue/green runtime operations under `scripts/ops/fm_server_beta.sh`.

**Change protocol:** **CPPR** = commit, push, pull request. For durable accountability in this repo, use **CPPRD** = add **D**ocumentation (subrepo `CHANGELOG`, `deploy/`, or `design_docs` as fit). See [`CPPR_AND_CPPRD.md`](./CPPR_AND_CPPRD.md).

## Layout

| Path | Purpose |
|------|---------|
| `scripts/ops/install_prereqs.sh` | Check host prerequisites (compose, Podman/Docker, `curl`). Does **not** install OS packages. |
| `scripts/ops/create_runtime_bundle.sh` | Build a lean runtime tarball for VPS migration (service-only payload; excludes docs/dev bloat). |
| `scripts/ops/push_runtime_bundle.sh` | Build/upload/extract runtime tarball to VPS over SSH (`scp` + `tar`), no git checkout needed on server. |
| `scripts/ops/verify_release_manifest.sh` | Validate `RELEASE_MANIFEST.txt` and print release identity (bundle, branch, commit) for deploy logs. |
| `scripts/ops/bootstrap_env.sh` | Copy env template (`--from-example`) or validate secrets presence (`--validate-only`). |
| `scripts/ops/render_env_template.sh` | Render `deploy/server.env.example` to `deploy/generated/server.env` (uses `envsubst` when installed). |
| `scripts/ops/verify_install.sh` | Verify checkout layout (`docker-compose.yml`, subtree dirs). Optional HTTP health probe. |
| `scripts/ops/fm_server_beta.sh` | Blue/green runtime operations (`status`, `check`, `deploy`, `smoke`, `switch`, `rollback`). |
| `deploy/server.env.example` | Documented variables; **no real secrets**. |
| `deploy/generated/` | Local render output directory (tracked empty except `.gitignore`). |
| `docker-compose.bluegreen.yml` | Blue/green stack (`api-blue`, `api-green`, `web-blue`, `web-green`) plus shared `db`, `redis`, and `proxy`. |
| `proxy/nginx.bluegreen.conf` | Proxy config that routes to active color using `proxy/active_color.conf`. |
| `.secrets/server.env` | Default local/server env file created from the template; ignored by git. |

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
2. `./scripts/ops/install_prereqs.sh`
3. Copy env template: `./scripts/ops/bootstrap_env.sh --from-example`  
   Edit `.secrets/server.env` (or override `FM_SERVER_ENV_FILE`).
4. `./scripts/ops/bootstrap_env.sh --validate-only`
5. Optional: `./scripts/ops/render_env_template.sh` if you substitute template variables outside manual editing.
6. `./scripts/ops/verify_install.sh`  
   Optionally `FM_VERIFY_HTTP=1` when the stack is up locally or on server.

Dry-run variants: append `--dry-run` where documented on each script.

## Lean VPS package flow (recommended)

When moving from local VM to hosted VPS, package only runtime assets:

1. Build runtime bundle from your dev machine:
   - `./scripts/ops/create_runtime_bundle.sh`
2. Copy the resulting tarball from `dist/runtime/` to the VPS.
3. Extract on VPS into the service workspace (for example `/opt/finance_manager`).
4. Populate secrets (`.secrets/server.env`) and run:
   - `./scripts/ops/install_prereqs.sh`
   - `./scripts/ops/bootstrap_env.sh --validate-only`
   - `./scripts/local-stack/fm_docker.sh start`

The bundle intentionally excludes design docs, workspace metadata, and local development artifacts to keep deploy payloads smaller and production-focused.
Each bundle includes `RELEASE_MANIFEST.txt` with build timestamp, branch, commit SHA, dirty/clean flag, and submodule status for deploy traceability and rollback confidence.

To automate steps 1-3 in one command:

- `./scripts/ops/push_runtime_bundle.sh --host <vps-ip-or-domain> --user <ssh-user> --remote-dir /opt/finance_manager`
- This command also runs remote manifest verification and prints release identity after extraction.

## Blue/green deploy flow

**Canonical runbook (hostnames, active vs inactive, `jsdevtesting`, `api-jsdevtesting`, and API behavior):** see [`deploy/BLUEGREEN_SWITCHOVER.md`](./BLUEGREEN_SWITCHOVER.md).  
**Where builds run and whether to build on the VPS vs CI:** see [`deploy/DEPLOYMENT_VECTORS.md`](./DEPLOYMENT_VECTORS.md).

Use script-first operations from repo root:

1. Validate runtime and proxy configuration:
   - `./scripts/ops/fm_server_beta.sh check`
2. Inspect active/inactive color and runtime status:
   - `./scripts/ops/fm_server_beta.sh status`
3. Deploy candidate color (typically inactive first):
   - `./scripts/ops/fm_server_beta.sh deploy green --dry-run`
   - `./scripts/ops/fm_server_beta.sh deploy green`
3b. **After Dockerfile / app code changes on the host** (rebuild images for one color — especially **Podman**):  
   - `./scripts/ops/fm_server_beta.sh rebuild-color green`  
   Recreates `api-green`, `web-green`, and the shared `proxy` so Podman’s `depends_on` / `--requires` graph does not block container replacement. Omit image build with `rebuild-color --no-build green` if you already ran `podman-compose … build` separately.
4. Smoke-test candidate before cutover:
   - `./scripts/ops/fm_server_beta.sh smoke --color green`
5. Promote by proxy-only switch:
   - `./scripts/ops/fm_server_beta.sh switch --to green`
6. Re-check active route:
   - `./scripts/ops/fm_server_beta.sh smoke --color active`
7. Roll back quickly if required:
   - `./scripts/ops/fm_server_beta.sh rollback`

Switch/rollback rewrites `proxy/active_color.conf` and reloads Nginx in the proxy container.
`switch` performs a pre-cutover smoke check on the target color and aborts on failure.

## Health verification

- Default `verify_install.sh` confirms files and directories only.
- With **`FM_VERIFY_HTTP=1`**, curls `FM_API_HEALTH_URL` (defaults to `http://localhost:8000/api/health/`).

## Secrets and `.secrets/`

- Commit **only** `deploy/server.env.example` style templates — never passwords, PEM material, or live tokens.
- Keep production values in a privileged store or host-managed files under restrictive permissions (`chmod 600`).
- `bootstrap_env.sh --from-example` writes to `.secrets/server.env` by default, which is gitignored.
- `bootstrap_env.sh --validate-only` parses `KEY=VALUE` lines without sourcing the file, so validation does not execute shell code from the env file.

## Redis/session decision (beta)

- Redis is part of the blue/green beta stack and is treated as required shared state for cache/session continuity.
- Both colors consume the same `REDIS_URL` so cutover does not orphan session/cache data between colors.
- Current fallback posture: if Redis is down, smoke/cutover should fail and operator should rollback or hold promotion.

## Server agent pull/deploy model

For the server beta, keep code changes on local/cloud development machines and in GitHub PRs. The server-side CLI/bridge agent should act as an operations runner:

1. Fetch or pull reviewed commits from GitHub.
2. Deploy those commits into the inactive blue/green color.
3. Run health checks and smoke tests.
4. Promote or roll back by switching proxy routing.

The server runtime should not be used for ad-hoc source edits. If a bug is found on the server, record the failing commit, logs, and reproduction details, then fix through a normal branch/PR flow before pulling the new commit to the server.
