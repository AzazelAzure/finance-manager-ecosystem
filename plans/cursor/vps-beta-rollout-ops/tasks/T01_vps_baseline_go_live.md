# T01 VPS Baseline Go-Live

## Objective
Deploy the current lean runtime bundle to VPS and validate MVP core flows with repeatable smoke evidence.

## Scope Boundary
- Primary repo/path: parent workspace runtime/deploy scripts.
- Runtime mode: containerized VPS service runtime only.
- No blue/green dev-host routing changes in this task.

## Required Checks
- Bundle deploy with identity verification:
  - `scripts/server/push_runtime_bundle.sh`
  - `scripts/server/verify_release_manifest.sh`
- Prereq + env checks:
  - `scripts/server/install_prereqs.sh`
  - `scripts/server/bootstrap_env.sh --validate-only`
- Runtime checks:
  - `scripts/fm_docker.sh status`
  - health endpoints and websocket flow checks
- Core MVP user smoke:
  - login
  - dashboard
  - transaction create/edit/delete

## Acceptance Criteria
- Two consecutive successful smoke passes on VPS.
- No critical host/CSRF/websocket regressions.
- Release manifest identity recorded in handoff.

## Required Handoff
- Commands executed and results.
- Deployed bundle manifest identity.
- Runtime status snapshot.
- Blockers and recommended next action.
