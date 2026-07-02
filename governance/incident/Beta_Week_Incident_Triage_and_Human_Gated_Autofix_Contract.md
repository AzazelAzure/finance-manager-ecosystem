# Beta Week Incident Triage and Human-Gated Autofix Contract

## Purpose

Define the operational contract for beta-week bug/feature intake, triage, and response so automation accelerates delivery without bypassing human verification.

This document is optimized for the current pre-production state where blue/green runtime exists but is not yet operated as full autonomous deployment infrastructure.

## Scope

- Runtime: VPS + current beta stack
- Intake: in-app reports, **Slack** (or other webhook) notifications to operators, and companion workflow channels; **transactional email on the VPS is not assumed** for beta.
- Delivery: branch + PR based fixes with explicit approval gates

## Operating Principle (Beta Week)

Automation is allowed to:

- ingest and classify reports
- dedupe and prioritize incidents
- produce diagnosis and patch proposals
- open/update draft PRs

Automation is **not** allowed to:

- merge to production branch autonomously
- cut traffic between colors autonomously
- deploy without explicit human approval

## Intake Pipeline (Target for beta)

1. User submits bug/feature request from app entrypoint.
2. API persists report and emits a **normalized incident event** (durable store — see F-012 plans when implemented).
3. Runtime notifies operators via **Slack** (recommended: dedicated incidents channel; Incoming Webhook or bot post with structured summary). Email remains optional later; do not block intake on SMTP.
4. Human or headless companion ingests the Slack message (or queue row) and updates the **execution queue** / triage thread.
5. Incident is routed into a triage lane with severity assignment per rubric below.

**Control plane:** gate templates live in `governance/execution/execution_protocols.md`. (The legacy Slack CLI-bridge design doc was retired 2026-06-30; scheduled automation is now Antigravity-native per `AGENTS.md` §0.) Keep **PR authorization** in `#pull-requests`; use a **separate** incidents channel so bug traffic does not drown task/PR threads.

## Normalized Incident Envelope

Every report should include:

- `incident_id`
- `created_at_utc`
- `report_type` (`bug` | `feature`)
- `severity` (`S0` | `S1` | `S2` | `S3`)
- `user_context` (safe identifier, no secret payload)
- `surface` (api endpoint, UI route, runtime component)
- `environment` (local/test/live, runtime mode)
- `repro_steps` (if available)
- `attachments_ref` (logs/screenshots references)

## Severity Rubric

- `S0`: production unusable, data integrity/security risk, urgent rollback/cutover decision
- `S1`: critical feature broken, high user impact, patch in same day
- `S2`: functional but degraded behavior, schedule in active beta backlog
- `S3`: minor UX/documentation/non-blocking enhancement

## Triage Lanes


| Lane          | Owner                  | Output                                      |
| ------------- | ---------------------- | ------------------------------------------- |
| Intake/Dedupe | Companion + operator   | canonical incident record + duplicate links |
| Diagnosis     | Agent-assisted         | likely root cause + impacted boundary       |
| Patch Design  | Agent-assisted         | implementation plan + test plan             |
| Delivery      | Human-approved         | feature branch + PR + validation evidence   |
| Verification  | Human + runtime checks | pass/fail + release decision                |


## Human-Gated Autofix Policy

Allowed automation actions:

1. create `fix/<incident-id>-<slug>` branch
2. implement candidate patch
3. run deterministic checks
4. open draft PR with incident linkage
5. post concise operator summary

Mandatory human gates:

1. **Gate A (merge authorization):** operator approves PR merge
2. **Gate B (runtime deploy authorization):** operator approves deploy command
3. **Gate C (traffic switch authorization):** operator approves blue/green cutover

No gate approval -> no forward progression.

## Verification Gate Contract

Minimum evidence required before merge/deploy:

- changed scope and risk summary
- contract/API compatibility check (when applicable)
- runtime validation checklist subset executed
- regression test result for incident repro
- rollback command/path confirmed

## Blue/Green Pre-Production Hardening (Near-Term)

Current state: blue/green assets exist but are not run as strict operational lanes yet.

Required hardening steps before full production-style operation:

1. **Color ownership model**
  - Explicitly label active/inactive runtime every cycle.
2. **Inactive color smoke gate**
  - All candidate deploys must pass smoke on inactive color first.
3. **Cutover checklist**
  - Single documented switch sequence with rollback command inline.
4. **Rollback drill cadence**
  - Scheduled rehearsal to keep rollback deterministic.
5. **Evidence ledger**
  - Record color, artifact identity, checks, and approver per cutover.

## VPS Email Outbound Guidance

For beta-week reliability:

- use transactional SMTP/API provider path for incident notifications
- include incident metadata in subject/body (no secrets)
- add retry + failure logging for notifier path
- route low-severity events to digest mode; high-severity as immediate alerts

## Beta Week Execution Rules

1. `S0/S1` triage preempts feature work.
2. Contract/schema changes require compatibility check before UI-only fixes.
3. Incident closure requires verification evidence, not just code merge.
4. All autonomous actions must be replayable from logs/artifacts.
5. Keep operator in loop for merge, deploy, and cutover.

## Suggested Immediate Next Actions (Hours-To-Launch)

- Stand up normalized incident envelope in current report path.
- Enforce draft-PR-only automation mode for beta week.
- Add incident-to-PR linkage field in PR template/checklist.
- Run one dry-run blue/green cutover exercise with rollback.
- Confirm outbound email alert path from VPS with one live test incident.