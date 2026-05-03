# Validation Gates

## Current Execution Status (Apr 28, 2026)
- Breakpoint A: **pass** (runtime inventory + VM accessibility + script ownership flow established).
- Breakpoint B: **pass** (install/bootstrap/verify scripts and dry-run checks pass locally and on VM).
- Breakpoint C: **pass (dry-run evidence)** for blue/green compose/proxy validation; live cutover still pending real candidate deploy.
- Breakpoint D: **partial** (`status/check/deploy --dry-run/switch --dry-run/rollback --dry-run` implemented and validated; non-dry-run promote/rollback evidence pending).
- Final gate: **pending** (feature branch changes not yet committed/PR'd in this execution pass).

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
