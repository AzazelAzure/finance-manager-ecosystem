# T01 Runtime Inventory and Server Assumptions

## Objective
Collect enough environment facts to design server install scripts without making destructive assumptions.

## Scope Boundary
- Primary executor: local CLI bridge agent on the current workstation or future server.
- Repo/path: parent workspace root.
- Mode: read-only; do not edit files or run lifecycle commands.

## Required Checks
- Current OS and architecture.
- Available runtimes:
  - `podman --version`
  - `docker --version`
  - compose provider/version
  - `systemctl --version` if systemd is intended.
- Current repo path and submodule status.
- Current runtime mode and owner from `design_docs/30_Releases/Runtime_Signup_Sheet.md`.
- Current `scripts/` entrypoints and hard-coded path assumptions.
- Current `docker-compose.yml`, proxy config, and service names.
- Current exposed ports and local hostnames.

## Acceptance Criteria
- Handoff names the preferred server runtime: Podman, Docker, or other.
- Handoff lists required host packages.
- Handoff identifies path assumptions that install scripts must parameterize.
- No lifecycle commands were run.

## Suggested Bridge Task
```text
!cursor
REPO: finance_manager_api
WORKSPACE_PATH: /home/pproctor/Documents/python/finance_manager
RUNTIME: local
TASK: |
  Read-only server install inventory for plans/cursor/server-beta-install-bluegreen-53be/tasks/T01_runtime_inventory.md.
  Reply with OS, container runtime, compose provider, systemd availability, repo/submodule status, script path assumptions, current ports/hostnames, and no file edits/lifecycle actions.
```

## Required Handoff
Use shared handoff format and include:
- Commands run.
- Runtime package requirements.
- Script assumptions that need refactor.
- Blockers before server install scripting.
