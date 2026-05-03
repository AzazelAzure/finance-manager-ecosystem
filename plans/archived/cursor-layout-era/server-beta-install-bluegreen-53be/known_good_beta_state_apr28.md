# Known Good Beta State (Apr 28, 2026)

## Runtime baseline
- VM host: `dev@192.168.122.41`
- Stack mode: containerized (`podman-compose`)
- Core services up:
  - `finance-manager-db`
  - `finance-manager-api`
  - `finance-manager-reflex`
  - `finance-manager-proxy`

## Public routing baseline
- Public hostnames configured:
  - `thehivemanager.com`
  - `www.thehivemanager.com`
  - `api.thehivemanager.com`
  - `reflex-api.thehivemanager.com`
- Tunnel origin expectation per hostname:
  - service: `https://127.0.0.1:8443`
  - origin request: `noTLSVerify=true`

## Data baseline
- Imported DB fixture: `migration_dump_20260428_184832.json`
- Post-import counts (VM Postgres):
  - `auth_user`: 11
  - `finance_transaction`: 20065
  - `finance_category`: 17
  - `finance_paymentsource`: 31
- Backup before import:
  - `/home/dev/finance_manager/pre_import_backup.sql`

## Application fixes applied during stabilization
- Restored missing currency data file:
  - `finance_manager_api/finance/data/exchange_rates.zip`
- Reflex switched to production mode in compose for tunnel stability.
- Proxy hostnames updated to public beta domains.
- Proxy websocket upstream for `reflex-api` mapped to Reflex frontend runtime port (`3000`) in current prod mode.
- API `ALLOWED_HOSTS` updated for public domains in compose runtime env.

## Health checks
- Frontend route:
  - `curl -k -I -H 'Host: thehivemanager.com' https://127.0.0.1:8443/`
- API health:
  - `curl -k -H 'Host: api.thehivemanager.com' https://127.0.0.1:8443/api/health/`
- Tunnel service:
  - `sudo systemctl status cloudflared`
  - `sudo journalctl -u cloudflared -n 120 --no-pager`

## Blue/green rollout status
- Blue/green tooling exists and is validated in dry-run mode:
  - `scripts/fm_server_beta.sh check`
  - `scripts/fm_server_beta.sh deploy --dry-run green`
  - `scripts/fm_server_beta.sh switch --dry-run --to green`
  - `scripts/fm_server_beta.sh rollback --dry-run`
- Live promote/rollback evidence remains intentionally deferred while tunnel login stabilization is active to avoid avoidable downtime on the active beta endpoint.

## Resume commands
```bash
cd /home/dev/finance_manager
./scripts/fm_docker.sh status
./scripts/fm_server_beta.sh check
./scripts/fm_server_beta.sh status
```

When ready for controlled promotion window:
```bash
./scripts/fm_server_beta.sh deploy green
./scripts/fm_server_beta.sh smoke --color green
./scripts/fm_server_beta.sh switch --to green
./scripts/fm_server_beta.sh smoke --color active
./scripts/fm_server_beta.sh rollback
./scripts/fm_server_beta.sh smoke --color active
```
