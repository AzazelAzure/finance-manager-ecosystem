# T06 Deploy and Rollback Scripts

## Objective
Create script-first deployment operations that build or pull a candidate release, start it on the inactive color, verify health, switch traffic, and roll back quickly if health fails.

## Scope Boundary
- Primary repo/path: parent `scripts/` and deployment package files.
- Related repos: API and Reflex only if app-level env knobs are required.
- Do not implement auto-merge or destructive data migrations in this task.

## Required Capabilities
- `install` or `bootstrap` command:
  - validates OS/runtime prerequisites
  - creates expected directories
  - installs service/unit files only when explicitly requested
  - creates `.env.example` or validates `.secrets` files without printing secrets
- `status` command:
  - reports active color, inactive color, service health, DB/Redis/proxy status
- `deploy <color>` command:
  - updates inactive color image/source
  - starts inactive API + Reflex pair
  - runs migrations in the agreed safe order
  - performs API and Reflex health checks
- `promote <color>` command:
  - changes proxy upstream to the verified color
  - reloads proxy
  - confirms active route health
- `rollback` command:
  - re-points proxy to previous known-good color
  - leaves failed candidate running only if useful for debugging, otherwise documents cleanup command

## Acceptance Criteria
- Scripts are idempotent where practical.
- Scripts fail fast on missing secrets, missing runtime, or mixed local/container mode.
- No script prints secret values.
- Dry-run or `--check` mode exists for server prep if feasible.
- README documents exact operator commands.

## Verification
On local bridge/runtime host:

```bash
scripts/fm_server_beta.sh status
scripts/fm_server_beta.sh check
scripts/fm_server_beta.sh deploy --dry-run green
```

If script names differ, update this task and docs before completion.

## Required Handoff
- Script names and commands.
- Dry-run/status output.
- Rollback behavior.
- Known manual steps that remain.
