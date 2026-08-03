# Ecosystem hostname vhosts (extraction boundary)

Additive nginx configuration for non-HFM hostnames routed through the shared `:8443` proxy on the HFM VPS.

## Files

| File | Role |
|---|---|
| `conf.d/ecosystem-hosts.conf.template` | VPS deploy source (per-color Podman DNS upstream maps) |
| `conf.d/ecosystem-hosts.conf` | Tracked local-dev canonical (`127.0.0.1` loopback maps) — **never** overwritten by render |
| `conf.d/ecosystem-hosts.deploy.conf` | Rendered VPS deploy artifact (gitignored; default `render_ecosystem_hosts.sh` output) |
| `scripts/ops/render_ecosystem_hosts.sh` | Copies template → deploy artifact |
| `scripts/ops/attach_orchestrator_proxy_networks.sh` | Idempotently attaches `fm-beta` proxy to `orchestrator-console-{blue,green}` |
| `certs/thedirectorate.app.pem` | Origin TLS cert (Cloudflare origin or self-signed for smoke) |
| `certs/pproctor.com.pem` | Origin TLS cert for www.pproctor.com |

## Hostnames

| Host | Upstream (VPS) | Service |
|---|---|---|
| `api.thedirectorate.app` | `$orch_active_color` → `orch-api-{color}:8000` | Orchestrator DRF API |
| `www.thedirectorate.app` | `$orch_active_color` → `orch-console-{color}:8081` | Orchestrator ops console |
| `www.pproctor.com` | `host.containers.internal:3000` | External adapter status stub |

Orchestrator presentation tiers publish **no host ports** by default. The edge proxy must attach to both `orchestrator-console-blue` and `orchestrator-console-green` Podman networks so nginx can resolve the stable aliases above. Do not use `ORCH_PUBLISH_HOST`, bridge gateway binds, or `host.containers.internal` for Orchestrator API/console ports.

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

## Rollback / detach

```bash
bash scripts/ops/attach_orchestrator_proxy_networks.sh detach
# Restore prior ecosystem-hosts.conf from backup if needed, then:
./scripts/ops/fm_server_beta.sh check && ./scripts/ops/fm_server_beta.sh reload
```

Detach leaves Orchestrator public vhosts unable to reach presentation containers until re-attach.

## Selector semantics

`proxy/conf.d/orch_active_color.conf` (default **blue**) keys the `$orch_active_color` maps in the deploy artifact. Orchestrator `orch_color.sh switch` writes this file; HFM `$fm_active_color` and Portfolio routes are unchanged.

## Local dev

Tracked `ecosystem-hosts.conf` keeps `127.0.0.1` loopback maps for workstation nginx smoke. Render/attach scripts target VPS install paths only.
