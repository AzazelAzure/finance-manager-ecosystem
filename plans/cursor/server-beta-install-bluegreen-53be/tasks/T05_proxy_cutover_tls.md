# T05 Proxy Cutover and TLS

## Objective
Implement proxy configuration that can route beta traffic to blue or green API/Reflex instances, enforce HTTPS, and enable quick rollback by switching upstream targets.

## Scope Boundary
- Primary repo/path: parent `proxy/` and `scripts/`.
- Coordinate with API/Reflex env variables.
- Do not store real certificate private keys in git.

## Requirements
- Support public hostnames for:
  - frontend UI
  - API
  - Reflex backend/websocket/SSE path if separate
- Route to blue or green upstreams via a single active color variable or generated config.
- Preserve HTTP -> HTTPS redirects.
- Include websocket/SSE headers required by Reflex if applicable.
- Keep local `*.local` development mode supported or clearly separated from server mode.

## Acceptance Criteria
- Proxy config can be validated before reload.
- Active color can switch from blue to green and back with a script.
- Failed health checks block cutover.
- TLS paths are configurable through env or a secrets directory.

## Verification
Use local runtime first:

```bash
scripts/fm_docker.sh status
curl -kI https://financemanager.local:8443/
curl -k https://api.financemanager.local:8443/api/health/
```

Server verification must use the real beta hostnames.

## Handoff Output
- Proxy files changed.
- Cutover command.
- Rollback command.
- TLS assumptions and unresolved cert tasks.
