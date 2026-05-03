# T03 Blue/Green Dev-Host Lane (Deferred)

## Objective
Design and later implement host-based validation routing so a non-public dev host can target inactive color without affecting live users.

## Scope Boundary
- Deferred task: do not execute until Breakpoint A and B are stable.
- Areas:
  - `proxy/nginx.bluegreen.conf`
  - DNS/Cloudflare host mapping
  - `scripts/fm_server_beta.sh` smoke/cutover checks

## Required Checks (when activated)
- Public host resolves to active color only.
- Dev host resolves to inactive color only.
- Switch/rollback behavior remains deterministic.
- Session/cookie behavior is verified across host split.

## Acceptance Criteria
- Dev-host validation proves fixes before public cutover.
- No public traffic interruption during inactive-color verification.
- Access control exists for dev host.

## Required Handoff
- Routing design summary.
- DNS/proxy changes.
- Verification evidence for host split.
- Residual risks and rollback steps.
