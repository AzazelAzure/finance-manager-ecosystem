# VPS Beta Rollout Ops Plan

## 0) Metadata
- Plan ID: `PLAN_VPS_BETA_ROLLOUT_OPS_2026-04-28`
- Status: `ready_for_execution`
- Priority: `P0` (VPS baseline), `P1` (feedback + Android phase-2 prep)
- Plan root: `plans/archived/cursor-layout-era/vps-beta-rollout-ops/`
- Intended orchestration branch: `cursor/vps-beta-rollout-ops`
- Target repos/areas: parent runtime scripts, `finance_manager_api`, `finance_manager_reflex`, `design_docs`, `finance_manager_android`

## 1) Objective
Stand up a production-style VPS beta baseline with auditable artifact deploys, then add reliable tester feedback operations (file-relay priority, email fallback), and queue blue/green validation-host routing plus Android second-phase beta readiness.

## 2) Scope

### In scope
- VPS-first runtime deployment via lean bundle pipeline.
- Manifest identity verification for every deploy artifact.
- Beta feedback intake planning and implementation packetization.
- Email delivery readiness contract for hosted runtime.
- Deferred design for dev-host to inactive-color validation lane.
- Android second-phase beta readiness planning and contract alignment.

### Out of scope
- Immediate implementation of dev-host inactive-color routing (deferred until VPS baseline stability).
- Full Android app delivery in this wave.
- Production HA claims beyond tested script/runtime behavior.

## 3) Source Evidence
- Runtime bundle pipeline now exists:
  - `scripts/server/create_runtime_bundle.sh`
  - `scripts/server/push_runtime_bundle.sh`
  - `scripts/server/verify_release_manifest.sh`
- Server runbook and script-first operations:
  - `deploy/SERVER_BETA_INSTALL.md`
  - `scripts/fm_docker.sh`
  - `scripts/fm_server_beta.sh`
- Feedback state:
  - Bug-report API endpoint exists: `finance_manager_api/finance/views/report_views.py`
  - Feature-request path missing.
  - Reflex feedback UI not yet implemented.
- Android state:
  - Contract/scaffold-oriented artifacts in `finance_manager_android/`, not full runtime app packaging.

## 4) Phase Plan

### Phase A: VPS baseline go-live and MVP validation
- Goal: Validate VPS runtime baseline with no downtime-intent ops posture.
- Entry criteria: VPS provisioned, SSH reachable, domain/TLS setup available.
- Exit criteria: Core MVP flows pass on VPS twice consecutively.
- Breakpoints: TLS/host header issues, websocket failures, auth/CSRF regressions, healthcheck instability.
- Triggers: Move forward only after repeatable smoke + log sanity pass.
- Dependencies: `scripts/server/*bundle*`, `scripts/fm_docker.sh`, `deploy/server.env.example`.
- Required implementation updates: none required before first baseline run.
- Verification gate: `validation_gates.md` Breakpoint A.
- Risks and mitigations: first-boot false positives; require consecutive successful runs.

### Phase B: Tester feedback operations (file relay first, email fallback)
- Goal: Establish reliable beta tester bug/feature intake and triage visibility.
- Entry criteria: Phase A baseline stable.
- Exit criteria: File-relay path active and email fallback validated.
- Breakpoints: Slack relay misses, SMTP transport misconfiguration, payload schema drift.
- Triggers: If reliability is partial, lock to append-only queue + cursor state.
- Dependencies: API report endpoint, Slack bridge, deploy env contract.
- Required implementation updates: `tasks/T02_feedback_pipeline_file_relay_email.md`.
- Verification gate: Breakpoint B.
- Risks and mitigations: protect sensitive payloads with schema/redaction.

### Phase C: Dev-host to inactive-color validation lane (deferred)
- Goal: Enable safe preview validation on inactive color without public interruption.
- Entry criteria: VPS baseline + feedback path stable.
- Exit criteria: Dev host can validate inactive color while public host remains active.
- Breakpoints: cookie/session domain collisions, accidental public exposure.
- Triggers: execute only after live stability telemetry is acceptable.
- Dependencies: `proxy/nginx.bluegreen.conf`, DNS/Cloudflare host routing.
- Required implementation updates: `tasks/T03_bluegreen_dev_host_lane_deferred.md`.
- Verification gate: Breakpoint C.
- Risks and mitigations: gate via access controls and strict host-based routing tests.

### Phase D: Android phase-2 beta readiness
- Goal: Transition Android from contract fixtures to executable readiness path.
- Entry criteria: API contracts stable for MVP beta.
- Exit criteria: Android auth+snapshot flow readiness tasks defined and started.
- Breakpoints: unresolved auth mode (JWT vs OAuth/PKCE), missing runnable project baseline.
- Triggers: start implementation once matrix/auth decisions are explicit.
- Dependencies: `finance_manager_android/`, API auth contracts, roadmap docs.
- Required implementation updates: `tasks/T04_android_phase2_readiness.md`.
- Verification gate: Breakpoint D.
- Risks and mitigations: prevent fixture/API drift using live contract checks.

## 5) Execution Order
1. `tasks/T01_vps_baseline_go_live.md`
2. `tasks/T02_feedback_pipeline_file_relay_email.md`
3. `tasks/T03_bluegreen_dev_host_lane_deferred.md` (deferred by gate)
4. `tasks/T04_android_phase2_readiness.md`
5. `tasks/T05_docs_sync_and_handoff.md`

## 6) Completion Criteria
- VPS baseline is stable and repeatable for MVP tester traffic.
- Every deploy artifact is identity-verified by release manifest.
- Feedback intake has dependable relay path plus tested fallback.
- Deferred dev-host routing remains queued behind explicit stability gate.
- Android phase-2 readiness has concrete scoped tasks and verification gates.
- Docs reflect real operational posture and known deferred risks.
