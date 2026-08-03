# Ecosystem hostname vhosts (extraction boundary)

Additive nginx configuration for non-HFM hostnames routed through the shared `:8443` proxy on the HFM VPS.

## Files

| File | Role |
|---|---|
| `conf.d/ecosystem-hosts.conf.template` | Source template with `@ORCH_PUBLISH_HOST@` placeholder |
| `conf.d/ecosystem-hosts.conf` | Tracked local-dev canonical (`127.0.0.1`, `$orch_active_color` maps) — **never** overwritten by render |
| `conf.d/ecosystem-hosts.deploy.conf` | Rendered VPS deploy artifact (gitignored; default `render_ecosystem_hosts.sh` output) |
| `scripts/ops/render_ecosystem_hosts.sh` | Renders template from `ORCH_PUBLISH_HOST` |
| `certs/thedirectorate.app.pem` | Origin TLS cert (Cloudflare origin or self-signed for smoke) |
| `certs/pproctor.com.pem` | Origin TLS cert for www.pproctor.com |

## Hostnames

| Host | Upstream | Service |
|---|---|---|
| `api.thedirectorate.app` | `ORCH_PUBLISH_HOST:8000` | Orchestrator DRF API |
| `www.thedirectorate.app` | `ORCH_PUBLISH_HOST:8081` | Orchestrator ops console |
| `www.pproctor.com` | `host.containers.internal:3000` | External adapter status stub |

`ORCH_PUBLISH_HOST` is the installation Podman bridge gateway (reachable from the `fm-beta` proxy container, not routable from the internet). It must match `ORCH_PUBLISH_HOST` in Orchestrator `~/orchestrator/.env.vps`. Do not use `host.containers.internal` for Orchestrator ports — on rootless Podman it may resolve to the public host address and bypass bind restrictions.

Render before deploy:

```bash
export ORCH_PUBLISH_HOST=10.89.1.1   # installation value
bash scripts/ops/render_ecosystem_hosts.sh
```

`deploy/vps/deploy_ecosystem.sh` (Orchestrator repo) renders automatically when `ORCH_PUBLISH_HOST` is set in HFM `.env` or the environment.

## Extraction note

During HFM restructure, move `ecosystem-hosts.conf` and ecosystem TLS certs to a standalone `edge-proxy` container/repo. Do **not** modify `nginx.bluegreen.conf` HFM blue/green maps or `$js_web_backend` / `$api_backend` variables.

## Smoke verification

```bash
curl -kfsS -H "Host: api.thedirectorate.app" https://127.0.0.1:8443/health/
curl -kfsS -H "Host: www.thedirectorate.app" https://127.0.0.1:8443/
curl -kfsS -H "Host: www.pproctor.com" https://127.0.0.1:8443/health
```

After ecosystem cert generation:

```bash
./proxy/certs/generate-ecosystem-certs.sh
```

## Rollback

Remove the `ecosystem-hosts.conf` volume mount and `include` line from `nginx.bluegreen.conf`; reload proxy. HFM production routes unchanged.
