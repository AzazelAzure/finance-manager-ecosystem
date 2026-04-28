# T03 Blue/Green Runtime Layout

## Objective
Add a blue/green runtime layout that can run two API instances and two Reflex instances, then route traffic through the active color while the inactive color is updated and smoke-tested.

## Scope Boundary
- Repo/path: parent workspace runtime scripts and proxy config.
- Do not change application code unless a deployment contract gap is discovered and documented.

## Design Requirements
- Two independently addressable API services:
  - `api-blue`
  - `api-green`
- Two independently addressable Reflex services:
  - `reflex-blue`
  - `reflex-green`
- Shared backing services where appropriate:
  - Postgres
  - Redis, once configured
  - proxy/load balancer
- Active color selection must be explicit and observable.
- Inactive color must be deployable and health-checkable before cutover.
- Cutover should be proxy reload/switch only, not a full stack restart.

## Implementation Notes
- Prefer separate compose files or profiles over copy-pasted ad-hoc commands:
  - `compose.base.yml`
  - `compose.bluegreen.yml`
  - `compose.redis.yml`
  - or equivalent project-consistent names
- Add scripts for:
  - active color status
  - deploy inactive color
  - smoke inactive color
  - switch active color
  - rollback to previous color
- Ensure health checks use container-internal and proxy routes.
- Plan for shared migrations carefully:
  - migrations run once before cutover
  - avoid deploying code that requires irreversible schema changes without a rollback note

## Acceptance Criteria
- Operator can run both colors at the same time.
- Operator can identify active and inactive colors.
- Inactive color can pass API and Reflex health/smoke checks before cutover.
- Switching active color does not stop the whole runtime.
- Rollback path is documented and tested with no destructive data changes.

## Verification Commands / Checks
Through the bridge/local runtime:

```bash
scripts/fm_deploy.sh status
scripts/fm_deploy.sh deploy --color inactive --no-cutover
scripts/fm_deploy.sh smoke --color inactive
scripts/fm_deploy.sh switch --to green
scripts/fm_deploy.sh smoke --color active
scripts/fm_deploy.sh switch --to blue
```

Names are placeholders; worker may choose final script names if documented.

## Risks
- Database migrations can break rollback if not designed as expand/contract migrations.
- Reflex state/websocket routes may need proxy-specific handling.
- Redis/session cache must be shared across colors before cutover is considered low-downtime.

## Required Handoff
- Compose/profile files changed.
- Proxy switch mechanism.
- Active/inactive smoke evidence.
- Rollback evidence.
- Branch/PR status.
