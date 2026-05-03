# Phase S5: ZK Middleware (Structural Revenue Defense) + US Re-Engagement Alignment

**Elevated 2026-04-30 post-beta huddle.** Originally framed as "magnum opus / clout play." With ads + user-data sales rejected (Topic 4 huddle locks), ZK middleware is now **structural revenue defense** — the differentiator that justifies premium subscription pricing without alternative revenue paths.

This Phase also serves as the natural alignment point for US re-engagement (P-6) per huddle Topic 4 Q5: ZK is the brand asset that gives "we genuinely cannot read your data" credibility in the US market where competitors (Monarch, Copilot, YNAB) cannot make that claim.

## Status

**Conditional.** Entry gated by `kill_commit_gates.md` §4. Defer or reframe is an explicit option per kill gate.

## Objective

Build, audit, release, and operationalize `django-zk` — a Rust-backed Django middleware for zero-knowledge encryption — with the live PFM as its production reference deployment. Concurrently, evaluate and execute US re-engagement per P-6 trigger conditions.

## Entry Criteria (all required)

- S4 exit met (bounty program live, ZK spec public, dev-channel reputation established).
- PFM ≥100 paying users.
- Audit-grade prep complete: threat model published, dependency hygiene score acceptable, no open S0/P0 security findings, IR runbook tested.
- ZK spec from S4 reviewed and locked.
- US re-engagement trigger evaluated (per P-6 candidates: PH MRR ≥ ₱200k/mo for 6mo OR specific inbound demand OR strategic partnership inbound).

## Exit Criteria (all required)

- `django-zk` Rust middleware publicly released under chosen license.
- External audit completed and findings published.
- PFM in production using the middleware (live reference, not just demo).
- Public announcement on Hacker News, r/django, security channels with measurable adoption signal (stars, forks, downloads, integration mentions).
- **US re-engagement decision made** — exact Phase placement (S5.A vs separate Phase like SU vs ongoing workstream), trigger condition validated, AI tier opening to US users with USD-equivalent pricing if approved.

## Workstreams

### W1 — ZK Implementation (P0, AI-Orchestrated)

- [ ] HitM is **executive**, not implementer. AI agents implement; HitM reviews architecture, security model, audit findings.
- [ ] Rust crate scaffolding: keys management, crypto primitives, FFI to Django middleware.
- [ ] Django middleware Python layer: integration points, encryption/decryption hooks, key lifecycle.
- [ ] Test harness: property-based tests for crypto correctness; integration tests against PFM models.
- [ ] CI/CD: build matrix for Linux + macOS + Windows; published wheels.

### W2 — License Decision (P0, Early)

- [ ] Per `design_docs/40_System_Design/09_Licensing_and_Publication_Strategy.md` Gate L2.
- [ ] Decide: permissive (MIT/Apache-2) vs copyleft (AGPL/MPL).
  - Permissive: maximizes adoption, accepts that competitors can use it freely.
  - Copyleft: protects the open-source intent, may limit corporate adoption.
- [ ] HitM strategic call. Expected default: Apache-2 for crate; AGPL-3 for any reference apps.
- [ ] Contributor model: DCO (lighter) vs CLA (heavier) — DCO recommended pre-acquisition.

### W3 — PFM Integration (P0)

- [ ] Migration plan: which PFM models become ZK-encrypted, in what order.
- [ ] Key recovery flow: what happens when user forgets password? Recovery key, social recovery, multi-device, or "data is lost" — HitM must commit to an answer pre-launch. **Honest recovery model required:** "If you lose your key, your data is gone" is acceptable for some niches; not acceptable for thin-margin households who treated this as their financial dashboard.
- [ ] Backwards compatibility: existing PFM data migrates safely.
- [ ] Gated rollout: opt-in for early adopters before default.

### W4 — External Audit (P0)

- [ ] Engage external audit firm or independent security researcher.
- [ ] Budget: estimate $5k–$30k USD depending on scope (this is the "good problem" cost; budget for it from PFM revenue).
- [ ] Audit scope: Rust crate + Django integration + PFM reference deployment.
- [ ] Findings remediation tracked publicly.
- [ ] Audit report published (with appropriate redactions if any).

### W5 — Public Launch (P0)

- [ ] Documentation site: getting started, threat model, integration guide, FAQ.
- [ ] Demo Django app showing middleware in action.
- [ ] Launch announcement post: technical depth, transparency about PFM as live user.
- [ ] Hacker News + r/django + security community posts coordinated.
- [ ] Press/podcast outreach (Talk Python To Me, Django Chat, etc.).

### W6 — US Re-Engagement Alignment (P0–P1, NEW)

Concurrent with W4 + W5; aligned with ZK launch where possible.

- [ ] **Validate P-6 trigger.** Confirm the specific trigger condition that fired (PH MRR threshold OR ZK ready OR inbound demand OR partnership). Document rationale.
- [ ] **US-specific positioning.** Wedge for US market may differ from PH (less "thin-margin survival math," more "privacy-first PFM"). Draft US-specific value prop.
- [ ] **AI tier opens to US** at USD-equivalent prices ($7.99/mo Pro+ AI typical). Asymmetric pricing model honors PH economics + US-market-rate AI.
- [ ] **Honorary US Founders converted.** Existing US testers grandfathered with ZK access at no additional cost; legacy founder badge maintained.
- [ ] **US-specific marketing motion.** Distribution channels: dev-channel (HN, r/django, security Twitter — anchored by ZK launch), PFM-specific channels (privacy-conscious finance audiences). NOT paid ads.
- [ ] **US-specific support tier.** Pricing covers minimal extra support burden; HitM bandwidth is already constrained.

### W7 — PFM Continuity (P0, Always)

- [ ] PFM revenue does not regress during S5. This is the single biggest risk of the phase.
- [ ] Daily HitM check-in on PFM operations even during S5 push.
- [ ] If PFM MRR drops >10% in a quarter, S5 work is paused until recovered.

### W8 — Documentation Sync (P1, at exit)

- [ ] Update `design_docs/40_System_Design/09_Licensing_and_Publication_Strategy.md` with locked license.
- [ ] Update `design_docs/40_System_Design/10_Bounty_Sandbox_Architecture.md` with audit findings flow.
- [ ] Create `design_docs/zk_docs/` (or appropriate path) with ZK-specific documentation.
- [ ] Update `01_Business_Vision.md` with the actual differentiator delivered.
- [ ] Document US re-engagement Phase placement decision in `00_strategic_context.md` §3.8.

## Constraints

- **PFM revenue is the primary KPI even in S5.** ZK is the secondary KPI; US re-engagement tertiary.
- **HitM remains executive role.** No "I'll just write this part myself" exceptions, except for review/architecture decisions.
- **Audit is non-optional.** If audit budget is unavailable, S5 is deferred until it is.
- **Recovery flow must be honest.** Choose the recovery model deliberately; communicate clearly to users.
- **US re-engagement does not regress PH market.** PH remains primary even after US opens.

## Risks and Mitigations

| Risk | Mitigation |
|---|---|
| Audit reveals fundamental flaw | Triage; remediate; possibly defer launch. Acceptance is part of the gate. |
| AI-generated Rust crypto code has subtle correctness bugs | Property-based testing; external review; do not skip the audit. |
| PFM revenue regresses during S5 | Pause workstreams 1, 4, 5 until PFM recovers. Workstream 7 is mandatory. |
| Open-source crate goes ignored at launch | Dev-channel reputation from S4 is the mitigation. If S4 didn't establish reach, S5 launch will struggle regardless. |
| Forgot-password disaster damages PFM trust | Gated rollout; recovery model committed before user-facing default. |
| US re-engagement crowds out PH work | Treat US as secondary motion; PH retention SLA holds; pause US workstream if needed. |
| US market converts poorly despite ZK story | Treat ZK as primary; US conversion is a bonus; don't bet S5 success on US. |
| HitM burnout | Quarterly self-review per `kill_commit_gates.md` §6 still applies. S5 is not exempt. |

## Verification Gate

Per `validation_gates.md` Phase S5 exit triggers.

## Definition of Done for Phase S5

- All exit triggers met.
- PFM revenue is intact or improved.
- `django-zk` has independent audit report and measurable adoption signal.
- HitM's reputation as "the person who made ZK encryption practical for Django" is **earned, not claimed**.
- US re-engagement decision documented and either executed (US market opening) or formally deferred (with new trigger).
- S6 entry gate evaluated.
