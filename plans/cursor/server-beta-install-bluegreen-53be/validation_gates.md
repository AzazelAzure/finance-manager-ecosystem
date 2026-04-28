# Validation Gates

## Breakpoint A: Server inventory and package design
- Target server assumptions are captured:
  - OS/distribution and package manager
  - container provider (`podman` preferred, Docker acceptable if documented)
  - domain/DNS/TLS approach
  - persistent data paths
  - secrets source
  - backup/restore location
- Existing local scripts are mapped to server equivalents.
- No destructive runtime changes are performed during inventory.
- Output includes whether Redis is required for beta or only for later multi-instance session behavior.

## Breakpoint B: Install package dry run
- Install scripts pass shell syntax checks.
- Compose/proxy config renders or validates without unresolved variables.
- `.env.example` / `.secrets.example` documents all required values without real secrets.
- Scripts are idempotent for directory creation, permissions, env validation, and status checks.
- Dry-run mode prints intended actions without mutating runtime.

## Breakpoint C: Blue/green local validation
- Two API instances can be represented independently (`api_blue`, `api_green` or equivalent).
- Two Reflex instances can be represented independently (`reflex_blue`, `reflex_green` or equivalent).
- Proxy can route active color while standby remains addressable for health checks.
- Health checks prove both current and candidate color before cutover.
- Rollback command switches proxy back to the previous color.

## Breakpoint D: Server readiness package
- Installation runbook covers:
  - bootstrap
  - secrets
  - TLS
  - DB migration
  - static/build steps
  - health checks
  - deploy
  - rollback
  - backup/restore
- Runtime scripts expose `install`, `status`, `deploy`, `switch`, `rollback`, `logs`, and `backup` or equivalent.
- Docs clearly mark remaining beta risks and manual steps.

## Final gate
- Each touched repo has a focused branch/PR.
- PRs are posted to `#pull-requests`.
- Slack automation state is read and reconciled with GitHub mergeability/check status.
- The bridge agent has provided local/server-like runtime evidence or a blocker report.
