# Device Eligibility Policy and SMM Mobile-Only Viability (Pre-Huddle)

Purpose: define primary-device requirements by role and evaluate whether mobile-only execution is viable for Social Media Management (SMM) under current operating constraints.

Date seeded: 2026-05-05  
Status: planning artifact (policy draft for huddle discussion and decision lock).

## Policy baseline (current operating model)

- Company execution roles require a **primary managed PC/laptop** by default.
- Tablets/phones are companion devices unless a role passes explicit mobile-only viability gates.
- Cloud agents can assist but do not replace operator-owned runtime control.

## Role-based device eligibility

### Engineering

- **Primary required:** managed laptop/PC (**mandatory**)
- **Mobile-only:** **not eligible**
- **Reason:** local IDE/orchestration/runtime verification and recovery paths require desktop-class workflows.

### Admin Operations

- **Primary required:** managed laptop/PC (**default mandatory**)
- **Mobile-only:** **not eligible by default**
- **Reason:** governance handling, structured documentation, cross-tool orchestration, and traceable operations are desktop-biased.

### Social Media Management (SMM)

- **Primary required:** conditional
- **Mobile-only:** **conditionally eligible** for narrow scope only
- **Reason:** channel posting can be mobile-first, but planning, analytics, governance compliance, and escalation handling often need desktop capability.

## SMM mobile-only viability assessment

### What mobile-only can handle reliably

- scheduled/post-now content publishing on major social apps
- story/reel posting and basic engagement handling
- comment/reply moderation for low-volume channels
- lightweight media upload and caption iteration

### What mobile-only struggles with or fails

- long-form content planning against governance templates
- multi-platform campaign tracking and comparative analytics
- bulk asset management, metadata consistency, and archival discipline
- reliable handoff packaging for agentic workflow integrations
- deep troubleshooting when automation/distribution tooling breaks

### Mobile-only viability verdict

- **SMM mobile-only is viable only for constrained execution scopes** (publish, basic moderation, lightweight engagement).
- **Not viable as sole device** when role includes planning, analytics ownership, governance traceability, or automation-adjacent workflows.

## SMM scope tiers (recommended)

### Tier S1 - Mobile-Only Allowed

Allowed if all are true:
- role scope limited to posting + basic community interaction
- no ownership of reporting beyond simple in-app metrics
- no requirement to maintain governance artifacts directly
- escalation path exists to desktop-capable operator

### Tier S2 - Mobile-Primary + Desktop Fallback

Default for early SMM hires:
- day-to-day posting can run mobile-first
- desktop access required at least weekly for planning/reporting/audit tasks
- fallback desktop must be available for incident/escalation windows

### Tier S3 - Desktop-Required SMM Ops

Required when any are true:
- owns campaign analytics and performance reporting
- owns documentation/compliance and traceability tasks
- participates in automation or cross-functional ops planning

## Minimum controls if mobile-only is approved

- company-managed account separation and credential controls
- approved app/tool allowlist for business channels
- documented escalation SLA to desktop-capable operator
- weekly audit checkpoint for missed tasks and reporting gaps
- explicit trigger conditions that force migration to Tier S2/S3

## Trigger conditions to end mobile-only eligibility

Move role from S1 to S2/S3 if any occur:
- repeated missed reporting/compliance deliverables
- content backlog growth due to device workflow bottlenecks
- need for cross-channel campaign planning beyond app-native tools
- increased automation/governance handoff requirements

## Huddle decision prompts

1. Should SMM hires start in Tier S2 by default instead of S1?
2. What exact tasks are permitted in S1 (mobile-only) vs blocked?
3. What is the escalation SLA when mobile workflow cannot complete a task?
4. At what KPI or workload threshold is desktop provision mandatory?
