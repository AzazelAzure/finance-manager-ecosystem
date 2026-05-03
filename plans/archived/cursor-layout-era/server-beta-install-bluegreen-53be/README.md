# Server Beta Install and Blue-Green Runtime Plan

## 0) Metadata
- Plan ID: `PLAN_SERVER_BETA_INSTALL_BLUEGREEN_2026-04-28`
- Status: `ready_for_execution`
- Priority: `P0`
- Plan root: `plans/archived/cursor-layout-era/server-beta-install-bluegreen-53be/`
- Intended orchestration branch: `cursor/server-beta-install-bluegreen-53be`
- Target repos/areas: parent runtime scripts, `finance_manager_api`, `finance_manager_reflex`, `design_docs`, server deployment docs

## 1) Objective
Create a repeatable server installation and runtime package for the API and Reflex frontend that can bootstrap a beta server, configure required environment and secrets, run health checks, and support low-downtime updates with two API instances and two frontend instances behind a controllable proxy/cutover layer.

The goal is not a perfect production platform on the first pass. The goal is a deterministic install/deploy path that gets the beta stack running safely, with enough observability and rollback to make minor bugfixes from the server realistic.

## 2) Scope

### In scope
- Server install/bootstrap scripts for Linux hosts.
- Environment template and `.secrets/` guidance without committing secrets.
- Containerized runtime layout for blue/green API and Reflex pairs.
- Proxy routing/cutover strategy for active and standby instances.
- Redis/session/cache configuration decision and wiring plan.
- Health checks, smoke checks, logs, rollback, and status tooling.
- Documentation updates for server beta operation.
- CLI bridge agent coordination for local/server runtime evidence.

### Out of scope
- Full Kubernetes or managed orchestration.
- Full HA database clustering.
- Final DNS/TLS provider automation if it requires provider-specific credentials.
- Rewriting API/Reflex app features beyond deployment blockers.
- Thread-trigger support in the bridge agent; use top-level Slack tasks until that is fixed.

## 3) Source Evidence
- Current local runtime uses script-first entry points:
  - `scripts/fm_docker.sh`
  - `scripts/fm_services.sh`
- Current container smoke via bridge agent reports API health, Reflex UI, proxy redirect, and no mixed local/container runtime.
- Existing docs require runtime ownership and script-first lifecycle control:
  - `design_docs/30_Releases/Runtime_Signup_Sheet.md`
  - `design_docs/10_Current_State/01_Runtime_Validation_Checklist.md`
  - `design_docs/40_System_Design/12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md`
- Server beta readiness requires hosted test/live workflow, reproducible deploy, HTTPS/OAuth/JWT policy, logging, and smoke evidence.

## 4) Phase Plan

### Phase A: Server/runtime inventory and target architecture
- Goal: Determine what exists today and freeze the minimal beta server topology.
- Entry criteria: Worker can read this plan root and the local/server workspace path.
- Exit criteria: Inventory report covers host assumptions, compose provider, current scripts, ports, domains, TLS approach, secrets, Redis/session needs, and blue/green topology.
- Breakpoints: Breakpoint A inventory complete before implementation.
- Triggers: Proceed only when target runtime mode is containerized and ownership is clear.
- Dependencies: CLI bridge agent for local runtime evidence; human-provided server details if not yet available.
- Required implementation updates: none unless inventory discovers broken scripts.
- Verification gate: `validation_gates.md` Breakpoint A.
- Risks and mitigations: Avoid building scripts around unknown server paths; parameterize workspace and env file locations.

### Phase B: Install package and environment bootstrap
- Goal: Create scripts/templates that install prerequisites, validate host dependencies, configure `.secrets/`, and prepare directories without hard-coded local paths.
- Entry criteria: Phase A topology approved or explicitly accepted.
- Exit criteria: A fresh host can run a dry-run/check script and receive actionable pass/fail output.
- Breakpoints: Breakpoint B install dry-run.
- Triggers: Proceed after install scripts are idempotent and do not expose secrets.
- Dependencies: parent repo scripts and docs.
- Required implementation updates: `tasks/T02_install_package_layout.md`.
- Verification gate: script dry-run, shellcheck-style syntax checks if available, and bridge/local host validation.
- Risks and mitigations: Do not overwrite existing `.secrets/`; generate examples and fail closed when required vars are missing.

### Phase C: Blue-green runtime and proxy cutover
- Goal: Run two API instances and two Reflex instances in active/standby groups with a proxy-controlled switch and health gates.
- Entry criteria: Install package prepares host and env.
- Exit criteria: Active group serves traffic; standby group can be started, health-checked, and promoted; rollback returns traffic to previous group.
- Breakpoints: Breakpoint C blue/green smoke.
- Triggers: Proceed only after proxy cutover and rollback are deterministic.
- Dependencies: Redis/session decision, database migration policy, API/Reflex health endpoints.
- Required implementation updates: `tasks/T03_blue_green_runtime.md`, `tasks/T05_proxy_cutover_tls.md`, `tasks/T06_deploy_rollback_scripts.md`.
- Verification gate: health checks for active and standby API/Reflex, proxy route checks, and rollback proof.
- Risks and mitigations: Running migrations against a shared DB can break old code; require migration compatibility checks before cutover.

### Phase D: Redis/session/cache and deployment readiness
- Goal: Decide and wire the minimal Redis/session/cache strategy needed for two app instances without surprising auth/session behavior.
- Entry criteria: Blue/green topology known.
- Exit criteria: Redis role is documented and configured where needed, or explicitly deferred with a safe reason.
- Breakpoints: Breakpoint D session/cache validation.
- Triggers: Proceed after auth/session smoke validates across active API/Reflex instances.
- Dependencies: API settings and Reflex runtime configuration.
- Required implementation updates: `tasks/T04_redis_session_cache.md`.
- Verification gate: login/session/auth smoke across active group and after cutover.
- Risks and mitigations: JWT-only flows may not require shared server session state today, but Reflex/Redis may still need runtime backend state; document exactly which state is shared.

### Phase E: Closeout and docs
- Goal: Make the server install path usable by humans and future agents.
- Entry criteria: Install, deploy, cutover, rollback, and smoke evidence exist.
- Exit criteria: Docs identify install commands, env vars, rollback procedure, runtime ownership, and known beta risks.
- Breakpoints: Final readiness gate.
- Triggers: Complete only after PRs are posted to `#pull-requests` and GitHub/Slack gates are reconciled.
- Dependencies: `design-docs-sync` and repo-local changelogs.
- Required implementation updates: `tasks/T07_docs_and_handoff.md`.
- Verification gate: docs read-through plus one clean bootstrap/cutover dry run.
- Risks and mitigations: Keep docs evidence-based; do not claim production HA beyond what is actually implemented.

## 5) Execution Order
1. `tasks/T01_runtime_inventory.md`
2. `tasks/T02_install_package_layout.md`
3. `tasks/T03_blue_green_runtime.md`
4. `tasks/T04_redis_session_cache.md`
5. `tasks/T05_proxy_cutover_tls.md`
6. `tasks/T06_deploy_rollback_scripts.md`
7. `tasks/T07_docs_and_handoff.md`

## 6) Completion Criteria
- Install package can validate and prepare a beta server without manual repo spelunking.
- Runtime scripts are parameterized and do not depend on a developer workstation path.
- Two API and two Reflex instances can be represented as active/standby groups.
- Proxy cutover and rollback are scripted and gated by health checks.
- Redis/session/cache stance is documented and validated or explicitly deferred.
- Secrets are loaded from `.secrets/`/environment and never committed.
- Server beta docs include exact commands, smoke checks, rollback, and known limitations.
- Every changed repo has a focused PR, `#pull-requests` announcement, and GitHub mergeability/check reconciliation.
