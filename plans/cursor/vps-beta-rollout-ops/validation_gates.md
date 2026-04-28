# Validation Gates

## Current Execution Status (Apr 28, 2026)
- Breakpoint A: **in_progress** (VPS is live; runtime + auth/profile + tunnel checks pass, pending final repeated end-user CRUD/websocket signoff).
- Breakpoint B: **pending** (feedback relay + SMTP fallback not implemented end-to-end).
- Breakpoint C: **deferred** (by design; execute only after baseline traffic stability).
- Breakpoint D: **pending** (Android phase-2 readiness not yet started).
- Final gate: **pending**.

## Breakpoint A: VPS baseline go-live
- Runtime bundle deploy succeeds on VPS with manifest verification output logged.
- `scripts/fm_docker.sh status` shows stable API/Reflex/proxy/db runtime.
- MVP smoke checks pass:
  - auth/login
  - dashboard load
  - transaction CRUD
  - websocket/event flow
- No critical CSRF/origin/host-header regressions in logs.
- Same smoke pass repeats successfully at least once.

## Breakpoint B: Feedback pipeline reliability
- File-based feedback intake contract is defined and append-only.
- Relay process posts new bug/feature events to Slack without duplicate storms.
- Email fallback configured with explicit SMTP env vars and delivery test pass.
- API bug-report endpoint validated in hosted runtime.
- Feature-request pathway validated (API/file path per chosen design).

## Breakpoint C: Dev-host inactive-color lane (deferred)
- Public host remains pinned to active color.
- Dev host routes to inactive color deterministically.
- Cutover script and smoke checks prove no public traffic interruption.
- Access control for dev host is in place (at minimum basic restriction).

## Breakpoint D: Android phase-2 readiness
- Android auth mode for beta is explicitly documented.
- Compatibility matrix includes Android rows for core contracts.
- Minimal runnable Android baseline exists for live API smoke checks.
- Hosted test environment validates auth + snapshot fetch flow.

## Final gate
- Required phase gates passed or explicitly deferred with rationale.
- Docs updated:
  - roadmap/board status
  - runtime/deploy guidance
  - known risks and next actions
- Cross-repo handoffs documented for orchestration continuation.
