# T03 Reflex Runtime Smoke

## Objective
Validate the Reflex frontend can be reached through the intended local container/proxy path and can perform beta-critical interactions against the API runtime.

## Scope Boundary
- Repo/path: `finance_manager_reflex/` plus parent runtime scripts/proxy config as read-only evidence.
- Coordinate runtime checks through the CLI bridge agent/local runtime owner.
- Do not edit API contracts in this task; file API blockers separately.

## Definition of Done
- Reflex service is reachable through the configured local beta path.
- Proxy route to Reflex is verified or blocked with logs.
- At least one beta-critical frontend smoke path is exercised:
  - unauthenticated landing/login route loads
  - authenticated dashboard/profile path if test credentials and runtime data are available
- Logs from Reflex/proxy show no repeating startup crash or routing failure during smoke.

## Required Verification
- Via CLI bridge/local runtime:
  - `scripts/fm_docker.sh status`
  - Reflex direct reachability check
  - Proxy reachability check for frontend route
  - Recent `reflex` and `proxy` logs
- If GUI browser access is available locally, capture a short smoke summary or screenshot path.

## Known Constraints
- Cloud agent does not have Docker/Podman in the current image; local CLI bridge must provide runtime evidence.
- Do not mix local services with containerized mode.
- Reflex has limited visible automated tests; manual smoke evidence is part of the beta gate.

## Branch/PR Expectations
- If code changes are needed, use a feature branch in `finance_manager_reflex/`.
- Update `finance_manager_reflex/CHANGELOG.md` for behavior or deployment changes.
- Open a PR, post to `#pull-requests`, and reconcile Slack/GitHub gates before merge.

## Handoff Output
Use shared handoff format:
- Objective
- Assumptions and Unknowns
- Evidence
- Files
- Risks
- Verification
- Branch/PR Status
- Next Action
