# Ecosystem hostname vhosts (extraction boundary)

Additive nginx configuration for non-HFM hostnames routed through the shared `:8443` proxy on the HFM VPS.

**Deployment status (Slice 6-B):** configuration, certificate SAN coverage, contract tests, and operator documentation only. This slice does **not** deploy, reload the proxy, rotate certificates on a host, mutate DNS/Cloudflare, flip colors, or touch Portfolio/Headquarters/Orchestrator application repos.

## Files

| File | Role |
|---|---|
| `conf.d/ecosystem-hosts.conf.template` | VPS deploy source (per-color Podman DNS upstream maps) |
| `conf.d/ecosystem-hosts.conf` | Tracked local-dev canonical (`127.0.0.1` loopback maps) — **never** overwritten by render |
| `conf.d/ecosystem-hosts.deploy.conf` | Rendered VPS deploy artifact (gitignored; default `render_ecosystem_hosts.sh` output) |
| `scripts/ops/render_ecosystem_hosts.sh` | Copies template → deploy artifact |
| `scripts/ops/attach_orchestrator_proxy_networks.sh` | Idempotently attaches `fm-beta` proxy to `orchestrator-console-{blue,green}` |
| `scripts/ops/ecosystem_hosts_contract_test.sh` | Executable contract test (Portfolio three-host edge + Orchestrator preservation) |
| `certs/thedirectorate.app.pem` | Origin TLS cert (Cloudflare origin or self-signed for smoke) |
| `certs/pproctor.com.pem` | Origin TLS cert for Portfolio hosts (`pproctor.com`, `www`, `preview`) |

## Hostnames

### Orchestrator (unchanged)

| Host | Upstream (VPS) | Service |
|---|---|---|
| `api.thedirectorate.app` | `$orch_active_color` → `orch-api-{color}:8000` | Orchestrator DRF API |
| `www.thedirectorate.app` | `$orch_active_color` → `orch-console-{color}:8081` | Orchestrator ops console |

Orchestrator presentation tiers publish **no host ports** by default. The edge proxy must attach to both `orchestrator-console-blue` and `orchestrator-console-green` Podman networks so nginx can resolve the stable aliases above. Do not use `ORCH_PUBLISH_HOST`, bridge gateway binds, or `host.containers.internal` for Orchestrator API/console ports.

### Portfolio (Slice 6-B three-host contract)

| Host | Behavior | Upstream | Notes |
|---|---|---|---|
| `pproctor.com` | HTTPS proxy | `host.containers.internal:3000` | Canonical public Portfolio host |
| `www.pproctor.com` | Permanent redirect | — | `301` to `https://pproctor.com` with same path and query; **no** application proxy |
| `preview.pproctor.com` | HTTPS proxy | `host.containers.internal:3000` (same as apex) | Defensive `X-Robots-Tag: noindex, nofollow`; Cloudflare Access is an **external** cutover precondition (not implemented in this repo) |

All Portfolio proxy vhosts use the shared `external_adapter_upstream` block and the established header/TLS conventions (`Host`, `X-Real-IP`, `X-Forwarded-For`, `X-Forwarded-Proto`, `X-Forwarded-Host`, `X-Forwarded-Port`).

HTTP port 80:

- `www.pproctor.com` → `301 https://pproctor.com$request_uri`
- `pproctor.com`, `preview.pproctor.com`, and Orchestrator hosts → `301 https://$host$request_uri`

## Certificate SAN coverage

`proxy/certs/generate-ecosystem-certs.sh` generates self-signed origin certs for smoke/staging. The `pproctor.com` cert includes SANs for:

- `pproctor.com` (apex)
- `www.pproctor.com`
- `preview.pproctor.com`

Existing `thedirectorate.app` SANs (`thedirectorate.app`, `api.thedirectorate.app`, `www.thedirectorate.app`) are unchanged. Re-running the script is idempotent (overwrites PEM/key pairs in place).

Replace with Cloudflare origin certs before production Zero Trust cutover.

## VPS deploy order (HFM-owned)

```bash
# After Orchestrator presentation networks/containers exist for both colors:
bash scripts/ops/render_ecosystem_hosts.sh
cp proxy/conf.d/ecosystem-hosts.deploy.conf proxy/conf.d/ecosystem-hosts.conf
bash scripts/ops/attach_orchestrator_proxy_networks.sh attach
./scripts/ops/fm_server_beta.sh check    # nginx -t (fail closed)
./scripts/ops/fm_server_beta.sh reload   # or proxy reload via compose exec
```

`fm_server_beta.sh deploy` runs render + attach + validated reload automatically when the proxy service is (re)started.

Orchestrator `vps_bootstrap.sh` / `orch_color.sh` invoke the installation hook `ORCH_EDGE_PROXY_PRE_RELOAD_CMD` (set in `.env.vps` or this repo's `server.env`) before nginx validation/reload so proxy network attach runs on the standard cross-repo bootstrap path.

**Slice 6-B note:** the steps above are the operator runbook for a future cutover. This slice lands config/docs/tests only — no VPS apply.

## Verification (local / CI)

```bash
./scripts/ops/ecosystem_hosts_contract_test.sh
```

Contract assertions cover: three Portfolio routes, `www` redirect path/query preservation, shared upstream, Orchestrator host preservation, canonical/template Portfolio parity, and certificate SAN inputs.

Post-cutover smoke (operator, not this slice):

```bash
curl -sI -k --resolve pproctor.com:8443:$VPS_ORIGIN_IP https://pproctor.com:8443/
curl -sI -k --resolve www.pproctor.com:8443:$VPS_ORIGIN_IP https://www.pproctor.com:8443/foo?bar=1
# Expect: Location: https://pproctor.com/foo?bar=1
curl -sI -k --resolve preview.pproctor.com:8443:$VPS_ORIGIN_IP https://preview.pproctor.com:8443/
# Expect: X-Robots-Tag: noindex, nofollow
```

## Rollback / detach

```bash
bash scripts/ops/attach_orchestrator_proxy_networks.sh detach
# Restore prior ecosystem-hosts.conf from backup if needed, then:
./scripts/ops/fm_server_beta.sh check && ./scripts/ops/fm_server_beta.sh reload
```

Detach leaves Orchestrator public vhosts unable to reach presentation containers until re-attach. To roll back Portfolio vhosts only, restore the prior `ecosystem-hosts.conf` / deploy artifact from backup before `check` + `reload`.

## Selector semantics

`proxy/conf.d/orch_active_color.conf` (default **blue**) keys the `$orch_active_color` maps in the deploy artifact. Orchestrator `orch_color.sh switch` writes this file; HFM `$fm_active_color` and Portfolio routes are unchanged.

## Local dev

Tracked `ecosystem-hosts.conf` keeps `127.0.0.1` loopback maps for workstation nginx smoke. Render/attach scripts target VPS install paths only.
