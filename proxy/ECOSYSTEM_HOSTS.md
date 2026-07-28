# Ecosystem hostname vhosts (extraction boundary)

Additive nginx configuration for non-HFM hostnames routed through the shared `:8443` proxy on the HFM VPS.

## Files

| File | Role |
|---|---|
| `conf.d/ecosystem-hosts.conf` | `server_name` blocks for ecosystem hostnames only |
| `certs/thedirectorate.dev.pem` | Origin TLS cert (Cloudflare origin or self-signed for smoke) |
| `certs/pproctor.com.pem` | Origin TLS cert for www.pproctor.com |

## Hostnames

| Host | Upstream (host loopback) | Service |
|---|---|---|
| `api.thedirectorate.dev` | `host.containers.internal:8000` | Orchestrator DRF API |
| `www.thedirectorate.dev` | `host.containers.internal:8081` | Orchestrator ops console |
| `www.pproctor.com` | `host.containers.internal:3000` | External adapter status stub |

## Extraction note

During HFM restructure, move `conf.d/ecosystem-hosts.conf` and ecosystem TLS certs to a standalone `edge-proxy` container/repo. Do **not** modify `nginx.bluegreen.conf` HFM blue/green maps or `$js_web_backend` / `$api_backend` variables.

## Smoke verification

```bash
curl -kfsS -H "Host: api.thedirectorate.dev" https://127.0.0.1:8443/health/
curl -kfsS -H "Host: www.thedirectorate.dev" https://127.0.0.1:8443/
curl -kfsS -H "Host: www.pproctor.com" https://127.0.0.1:8443/health
```

After ecosystem cert generation:

```bash
./proxy/certs/generate-ecosystem-certs.sh
```

## Rollback

Remove the `ecosystem-hosts.conf` volume mount and `include` line from `nginx.bluegreen.conf`; reload proxy. HFM production routes unchanged.
