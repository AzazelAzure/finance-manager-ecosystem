# T02 Feedback Pipeline (File Relay First, Email Fallback)

## Objective
Implement and validate a dependable tester feedback path prioritizing file-relay-to-Slack, with email as fallback.

## Scope Boundary
- Areas:
  - `finance_manager_api/` (report endpoints + env contract)
  - bridge/ops scripts (`scripts/cursor_headless_slack_agent.py` or wrapper path)
  - optional Reflex feedback entry UI in safe MVP scope
- Security: no secrets in git; redact sensitive fields.

## Required Checks
- Define file intake contract (append-only format for bug/feature records).
- Relay implementation posts new records to Slack channel/thread with dedupe state.
- API bug report email path validated in hosted runtime.
- Add feature-request pathway (API and/or file queue contract) and verify.
- Add SMTP contract keys to deployment templates/docs.

## Acceptance Criteria
- End-to-end for bug and feature events:
  - input record created
  - relay posts to Slack reliably
  - email fallback works when relay path is unavailable
- No duplicate flood on restart (cursor/state-based dedupe).

## Required Handoff
- Chosen architecture (wrapper vs in-bridge extension) and why.
- Schema/examples for feedback records.
- Verification logs/screenshots and failure modes.
- Ops runbook for recovery/replay.
