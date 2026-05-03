# Server Runtime Handoff (Apr 28, 2026)

## Objective
Capture the current server-beta runtime state after implementing blue/green deploy tooling so execution can continue without rediscovery.

## Implemented Artifacts
- `docker-compose.bluegreen.yml`
- `proxy/nginx.bluegreen.conf`
- `proxy/active_color.conf`
- `scripts/fm_server_beta.sh`
- `deploy/SERVER_BETA_INSTALL.md` (updated runbook)

## Validation Evidence
- Local:
  - `./scripts/fm_server_beta.sh check`
  - `./scripts/fm_server_beta.sh status`
  - `./scripts/fm_server_beta.sh deploy --dry-run green`
  - `./scripts/fm_server_beta.sh switch --dry-run --to green`
  - `./scripts/fm_server_beta.sh rollback --dry-run`
- VM (`dev@192.168.122.41`):
  - `./scripts/fm_server_beta.sh check`
  - `./scripts/fm_server_beta.sh status`
  - `./scripts/fm_server_beta.sh deploy --dry-run green`
  - `./scripts/fm_server_beta.sh switch --dry-run --to green`
  - `./scripts/fm_server_beta.sh rollback --dry-run`

## Redis/Session Decision (Beta)
- Redis is included in blue/green compose and treated as required shared state for cutover continuity.
- API/Reflex services consume shared `REDIS_URL`.
- Cutover should be considered blocked if Redis health checks fail.

## Remaining Manual Runtime Steps
1. Stop any conflicting legacy stack bound to `:8080` / `:8443` before live blue/green deployment.
2. Populate real server env values in `.secrets/server.env` (never commit secrets).
3. Run a non-dry-run candidate deployment and smoke sequence:
   - `./scripts/fm_server_beta.sh deploy green`
   - `./scripts/fm_server_beta.sh smoke --color green`
   - `./scripts/fm_server_beta.sh switch --to green`
   - `./scripts/fm_server_beta.sh smoke --color active`
4. Capture rollback evidence:
   - `./scripts/fm_server_beta.sh rollback`
   - `./scripts/fm_server_beta.sh smoke --color active`
5. Apply Cloudflare tunnel routing to the active proxy hostname(s) after smoke is green.

## Known Risks
- Non-dry-run cutover evidence is still pending.
- DB migration safety remains dependent on expand/contract migration discipline.
- TLS cert management is still external to repo by design.
