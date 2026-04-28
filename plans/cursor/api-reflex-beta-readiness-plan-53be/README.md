# API + Reflex Beta Readiness Plan

## 0) Metadata
- Plan ID: `PLAN_API_REFLEX_BETA_READINESS_2026-04-28`
- Status: `ready_for_execution`
- Priority: `P0`
- Plan root: `plans/cursor/api-reflex-beta-readiness-plan-53be/`
- Intended orchestration branch: `cursor/api-reflex-beta-readiness-plan-53be`
- Target repos/areas: `finance_manager_api`, `finance_manager_reflex`, parent runtime/bridge docs as needed

## 1) Objective
Prepare the API and Reflex frontend for a small server beta by closing production-config blockers, triaging the current API test failures, validating the containerized runtime through the local CLI bridge agent, and producing clear handoffs for any remaining launch risks.

## 2) Scope

### In scope
- API production-readiness configuration and deployment checks.
- API automated test failure triage and minimal root-cause fixes.
- Reflex runtime smoke validation through the local containerized stack.
- CLI bridge-agent task/reply refinements needed for reliable cloud-to-local runtime coordination.
- Beta readiness documentation updates after behavior or operational assumptions change.

### Out of scope
- Android implementation.
- New product features beyond what is needed to reach beta readiness.
- Broad UI redesigns.
- Merge actions before Slack `#pull-requests` authorization and GitHub mergeability/check reconciliation.

## 3) Source Evidence
- `design_docs/40_System_Design/12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md`
- `design_docs/20_Roadmap/Beta_Execution_Board.md`
- `design_docs/20_Roadmap/Beta_Launch_Cutline_and_SPA_Transition.md`
- `design_docs/20_Roadmap/Phase_2_Beta_Preparation.md`
- `design_docs/20_Roadmap/Beta_Contract_Compatibility_Matrix.md`
- `design_docs/10_Current_State/01_Runtime_Validation_Checklist.md`
- `design_docs/30_Releases/Runtime_Signup_Sheet.md`
- Observed cloud check: API `manage.py check --deploy` emits security warnings.
- Observed cloud check: API suite currently reports `94 failed, 65 passed, 4 skipped`.
- Observed bridge stress test: `!cursor` prefix works; long Slack replies can clip output; threaded follow-up retasks did not reliably produce a second response.

## 4) Phase Plan

### Phase A: Runtime and command-channel baseline
- Goal: Establish reliable CLI bridge communication and local runtime evidence for API + Reflex.
- Entry criteria: Bridge contract is readable; `#cli-interface` can trigger the local agent.
- Exit criteria: Runtime mode, owner, status, API health, Reflex reachability, and proxy findings are reported in short chunked Slack replies.
- Breakpoints: Breakpoint A baseline spin-up and smoke checks.
- Triggers: Continue only after local runtime owner/mode is clear and non-mixed.
- Dependencies: CLI bridge agent on the local PC; container runtime available locally.
- Required implementation updates: May include bridge output chunking/short-summary changes if the runner is in scope.
- Verification gate: `tasks/T04_cli_bridge_reply_refinement.md` plus `validation_gates.md`.
- Risks and mitigations: Slack clipping can hide findings; require sub-2500-character chunked replies.

### Phase B: API production hardening and tests
- Goal: Remove API beta blockers that can be verified in cloud or local runtime.
- Entry criteria: API branch is clean and feature branch is created in `finance_manager_api`.
- Exit criteria: Production settings parse env booleans correctly, deploy check is intentionally clean or documented, and API tests are green or failures are explicitly triaged with follow-up tasks.
- Breakpoints: Breakpoint B post-fix validation.
- Triggers: Continue only after targeted API tests pass and full suite is either green or failure categories are documented.
- Dependencies: API repo test env; local runtime may be needed for Postgres/container-only checks.
- Required implementation updates: See `tasks/T01_api_production_settings.md` and `tasks/T02_api_test_triage.md`.
- Verification gate: API tests, deploy check, and local container API health.
- Risks and mitigations: Test failures may reveal contract drift; split unrelated failures into follow-up PRs rather than masking them.

### Phase C: Reflex beta smoke and API integration
- Goal: Validate Reflex can serve beta-critical flows against the API runtime.
- Entry criteria: API runtime health is confirmed.
- Exit criteria: Reflex route is reachable through the intended beta path and smoke flows are either passing or documented as blockers.
- Breakpoints: Breakpoint C regression sanity pass.
- Triggers: Continue only after API health and proxy routing are stable.
- Dependencies: Local CLI bridge for browser/container smoke evidence.
- Required implementation updates: See `tasks/T03_reflex_runtime_smoke.md`.
- Verification gate: CLI bridge reports Reflex reachability, proxy status, and any frontend logs/errors.
- Risks and mitigations: Reflex lacks broad automated tests; rely on concise manual/browser smoke artifacts until tests are added.

### Phase D: Readiness closeout
- Goal: Convert validation evidence into actionable launch status.
- Entry criteria: API and Reflex checks have explicit pass/fail evidence.
- Exit criteria: Changelogs/docs updated where behavior changed; PRs posted to `#pull-requests`; unresolved launch risks captured.
- Breakpoints: Final readiness gate.
- Triggers: Close only after Slack authorization and GitHub mergeability/check state are reconciled per repo.
- Dependencies: PR automation and design-docs sync.
- Required implementation updates: See `tasks/T05_beta_readiness_docs_sync.md`.
- Verification gate: PR descriptions include validation; docs reflect latest state.
- Risks and mitigations: Avoid marking beta ready if hosted test-server evidence remains missing.

## 5) Execution Order
1. `tasks/T04_cli_bridge_reply_refinement.md`
2. `tasks/T01_api_production_settings.md`
3. `tasks/T02_api_test_triage.md`
4. `tasks/T03_reflex_runtime_smoke.md`
5. `tasks/T05_beta_readiness_docs_sync.md`

## 6) Completion Criteria
- API production settings are safe for beta configuration.
- API tests are passing or explicitly triaged with bounded follow-up tasks.
- Local container runtime evidence covers API health, Reflex reachability, and proxy routing.
- CLI bridge can return non-clipped runtime handoffs.
- Any changed sub-repo has a focused feature branch, changelog/docs impact assessment, pushed commits, and draft PR.
- Every PR is posted to `#pull-requests`; Slack automation state and GitHub mergeability/check state are reconciled before merge.
