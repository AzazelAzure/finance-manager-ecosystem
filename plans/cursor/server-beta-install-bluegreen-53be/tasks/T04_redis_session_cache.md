# T04 Redis, Session, and Cache Decision

## Objective
Add a deliberate Redis/session/cache plan so two API instances and two Reflex instances can run during updates without avoidable login/session disruption.

## Scope Boundary
- Primary repo: parent runtime/deployment scripts.
- Related repos: `finance_manager_api`, `finance_manager_reflex`.
- Do not add Redis as an ad-hoc runtime dependency without documenting how it is configured, secured, and validated.

## Decision Points
- What Redis is responsible for in beta:
  - Django cache only.
  - Django sessions.
  - SimpleJWT blacklist/token state if needed.
  - Reflex state/cache/pubsub if required by Reflex deployment mode.
- Whether Redis is managed:
  - local container in beta stack
  - server package/service
  - managed provider
- Persistence and backup requirements.
- Authentication/password/TLS exposure.

## Implementation Notes
- Prefer one authoritative environment block:
  - `REDIS_URL`
  - `DJANGO_CACHE_URL` if separate
  - Reflex-specific Redis env vars if Reflex requires them
- Avoid making Redis a single undocumented SPOF; document what happens if it is unavailable.
- Ensure blue and green app instances point at the same intended shared state only where safe.

## Acceptance Criteria
- Redis role is documented before production use.
- Runtime scripts can start/check Redis in the selected mode.
- API/Reflex env examples include required Redis settings.
- Health checks detect Redis unavailability if it is required for the selected beta path.

## Verification
```bash
scripts/fm_server.sh status
scripts/fm_server.sh smoke --target blue
scripts/fm_server.sh smoke --target green
```

Include a test proving login/session behavior survives app instance switch if Redis/session sharing is in scope.

