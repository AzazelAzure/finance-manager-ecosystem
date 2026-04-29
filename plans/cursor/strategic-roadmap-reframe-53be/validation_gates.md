# Validation Gates (Per-Phase Triggers)

Each phase has explicit *quantitative* triggers for entry, mid-phase health, and exit. Where a metric is unmeasurable yet (e.g. before any users exist), the gate is qualitative and explicit about that fact.

## Phase S1: Public Beta Launch + Position Lock-in

### Entry triggers (all required)
- VPS baseline runtime is stable: per `plans/cursor/vps-beta-rollout-ops/validation_gates.md` Phase A pass.
- API + Reflex passing smoke per `plans/cursor/api-reflex-beta-readiness-plan-53be/validation_gates.md`.
- Owner has written one-line wedge sentence and reviewed it against `00_strategic_context.md` §1.
- Founding-member program seat count and pricing decided and recorded in `01_unit_economics_and_costs.md`.

### Mid-phase health checks (monthly)
- Owner velocity not below 30% of pre-baby baseline for >6 weeks running.
- Free-tier LLM spend on track to stay under monthly cap.
- At least 1 PH-local distribution touchpoint per week (Reddit, FB groups, etc.).
- No P0 security incidents.

### Exit triggers (any one of)
- ≥10 paying PH users active in the prior 30 days.
- ≥50 active free users (logged in within prior 30 days), with retention day-30 ≥30%.
- (Both is ideal; one is sufficient.)

### Exit failure modes (handled in `kill_commit_gates.md` §2)
- 9 months elapsed; trigger not met → reposition or extend.

## Phase S2: PH Vertical Hardening

### Entry triggers (all required)
- S1 exit met.
- Owner has written S2-specific feature list capped at: GCash/Maya ingestion (PH free), AI tier MVP, Reflex→JS pivot kickoff. Anything else is deferred.

### Mid-phase health checks (monthly)
- Day-60 retention ≥25% on cohorts that signed up during S1.
- AI tier paid conversion ≥5% of free users by month 3 of S2.
- AI per-user cost is within tier cap for ≥95% of users.

### Exit triggers (all required)
- GCash/Maya ingestion live and accurate (≥95% of test transactions correctly parsed).
- AI tier MVP live with ≥3 paid Pro+ AI subscribers.
- ≥30 paying users total (across all tiers).
- JS pivot has reached "feature parity demo" milestone OR is explicitly deferred to S3 with documented reason.

## Phase S3: Mobile Offline-First (PH Critical)

### Entry triggers (all required)
- S2 exit met.
- Sync architecture design document drafted and reviewed (during S2).
- Android dev environment + AI agent capable of producing buildable artifacts validated.

### Mid-phase health checks (monthly)
- Android crash-free rate ≥99% on test devices.
- Sync conflict resolution validated against scripted scenarios.
- Battery impact during background sync within acceptable bounds (≤2% per hour active sync).

### Exit triggers (all required)
- Android beta in PH Play Store (or sideload distribution if Play Store gating delayed).
- ≥20% of total active users on Android within 60 days of beta launch.
- Sync failure rate <0.5% of operations.

## Phase S4: Trust & Reputation Building

### Entry triggers (any one of)
- PFM ≥50 paying users (proof of real-user usage, not just sign-ups).
- Owner has authored security disclosure policy and `SECURITY.md` for PFM repos.
- Bounty program scope drafted and reviewed.

### Mid-phase health checks (quarterly)
- ≥1 disclosed security finding handled per published policy timeline.
- Dev-channel touchpoints (Hacker News post, blog post, talk submission, OSS contribution) ≥1 per quarter.
- ZK middleware spec / RFC drafted in public.

### Exit triggers (all required)
- Bounty program live with ≥3 reported findings (severity any) handled.
- ZK middleware spec public and reviewed by ≥1 external security-aware reviewer.
- Owner has dev-channel presence (mailing list, blog, or community handle) with measurable inbound interest.

## Phase S5: ZK Middleware Magnum Opus

### Entry triggers (all required)
- S4 exit met.
- PFM ≥100 paying users.
- Audit-grade prep: threat model published, dependency hygiene score acceptable, no open P0 security findings.

### Mid-phase health checks (quarterly)
- Audit/review milestones met: design review → code review → external audit → adoption announcement.
- PFM revenue does not regress during S5 build (S5 must not crowd out PFM operations).

### Exit triggers (all required)
- `django-zk` Rust middleware publicly released under chosen license.
- External audit completed and findings published.
- PFM in production using the middleware (live reference).
- Public announcement on Hacker News, r/django, security channels with measurable adoption signal (stars, forks, downloads).

## Phase S6: Sari-Sari B2B Vertical

### Entry triggers (all required)
- S5 exit met (or S5 explicitly abandoned with documented reason).
- PFM ≥$1k MRR sustained for ≥6 months.
- ≥3 sari-sari operators in owner's personal network have expressed unprompted interest.

### Mid-phase health checks (quarterly)
- Discovery interviews completed before any code (≥10 operators interviewed).
- B2B sales motion validated: at least one operator paying without family-discount.
- Reuse of PFM data layer / encryption confirmed; no fork divergence.

### Exit triggers (all required)
- ≥10 paying sari-sari operators.
- Supplier-integration prototype operational (even if behind feature flag).
- B2B churn <10%/quarter (B2B retention is bigger than B2C absolute number).

## Cross-Phase: Always-On Validation

These gates run **regardless of active phase** and override phase-specific gates if violated.

### Cost discipline gate
- Free-tier LLM monthly cost ≤30% of paid MRR.
- Total infrastructure (VPS+domain+TLS) ≤$50/mo unless paid users justify.
- Cursor Pro re-evaluated at every phase transition.

### Family / health gate
- Quarterly self-review per `kill_commit_gates.md` §6.
- Triggers reduced-scope mode or master kill gate evaluation as defined.

### Security gate
- Any P0 security incident pauses feature work until resolved.
- Any PII/auth/money-math change goes through human review per `00_strategic_context.md` §6.

### Brand consistency gate
- Every public-facing surface (landing page, app store description, social posts) leads with the wedge sentence (`00_strategic_context.md` §1).
- Audit at every phase transition.
