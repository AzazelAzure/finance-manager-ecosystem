# Phase S5: ZK Middleware Magnum Opus (Conditional)

## Status

**Conditional.** Entry gated by `kill_commit_gates.md` §4. Defer or reframe is an explicit option.

## Objective

Build, audit, release, and operationalize `django-zk` — a Rust-backed Django middleware for zero-knowledge encryption — with the live PFM as its production reference deployment.

This phase is the owner's identified "magnum opus." It is also the phase most prone to crowding out core revenue work. The trigger gates are intentionally strict.

## Entry Criteria (all required)

- S4 exit met.
- PFM ≥100 paying users.
- Audit-grade prep complete: threat model published, dependency hygiene score acceptable, no open P0 security findings, IR runbook tested.
- ZK spec from S4 reviewed and locked.

## Exit Criteria (all required)

- `django-zk` Rust middleware publicly released under chosen license.
- External audit completed and findings published.
- PFM in production using the middleware (live reference, not just demo).
- Public announcement on Hacker News, r/django, security channels with measurable adoption signal (stars, forks, downloads, integration mentions).

## Workstreams

### 1. Implementation (P0, AI-Orchestrated)

- [ ] Owner is **executive**, not implementer. AI agents (Cursor + cloud agents) implement; owner reviews architecture, security model, audit findings.
- [ ] Rust crate scaffolding: keys management, crypto primitives, FFI to Django middleware.
- [ ] Django middleware Python layer: integration points, encryption/decryption hooks, key lifecycle.
- [ ] Test harness: property-based tests for crypto correctness; integration tests against PFM models.
- [ ] CI/CD: build matrix for Linux + macOS + Windows; published wheels.

### 2. License Decision (P0, Early)

- [ ] Per `design_docs/40_System_Design/09_Licensing_and_Publication_Strategy.md` Gate L2.
- [ ] Decide: permissive (MIT/Apache-2) vs copyleft (AGPL/MPL). Tradeoffs:
  - Permissive: maximizes adoption, accepts that competitors can use it freely.
  - Copyleft: protects the open-source intent, may limit corporate adoption.
- [ ] Owner's strategic call. Expected default: Apache-2 for crate; AGPL-3 for any reference apps.
- [ ] Contributor model: DCO (lighter) vs CLA (heavier) — DCO recommended pre-acquisition.

### 3. PFM Integration (P0)

- [ ] Migration plan: which PFM models become ZK-encrypted, in what order.
- [ ] Key recovery flow: what happens when user forgets password? Recovery key, social recovery, multi-device, or "data is lost" — owner must commit to an answer pre-launch.
- [ ] Backwards compatibility: existing PFM data migrates safely.
- [ ] Gated rollout: opt-in for early adopters before default.

### 4. External Audit (P0)

- [ ] Engage external audit firm or independent security researcher.
- [ ] Budget: estimate $5k–$30k USD depending on scope (this is the "good problem" cost; budget for it).
- [ ] Audit scope: Rust crate + Django integration + PFM reference deployment.
- [ ] Findings remediation tracked publicly.
- [ ] Audit report published (with appropriate redactions if any).

### 5. Public Launch (P0)

- [ ] Documentation site: getting started, threat model, integration guide, FAQ.
- [ ] Demo Django app showing middleware in action.
- [ ] Launch announcement post: technical depth, transparency about PFM as live user.
- [ ] Hacker News + r/django + security community posts coordinated.
- [ ] Press/podcast outreach optional (Talk Python To Me, Django Chat, etc.).

### 6. PFM Continuity (P0, Always)

- [ ] PFM revenue does not regress during S5. This is the single biggest risk of the phase.
- [ ] Daily owner check-in on PFM operations even during S5 push.
- [ ] If PFM MRR drops >10% in a quarter, S5 work is paused until recovered.

### 7. Documentation Sync (P1, at exit)

- [ ] Update `design_docs/40_System_Design/09_Licensing_and_Publication_Strategy.md` with locked license.
- [ ] Update `design_docs/40_System_Design/10_Bounty_Sandbox_Architecture.md` with audit findings flow.
- [ ] Create `design_docs/zk_docs/` (or appropriate path) with ZK-specific documentation.
- [ ] Update `01_Business_Vision.md` with the actual differentiator delivered.

## Constraints

- **PFM revenue is the primary KPI even in S5.** ZK is the secondary KPI.
- **Owner remains executive role.** No "I'll just write this part myself" exceptions, except for review/architecture decisions.
- **Audit is non-optional.** If audit budget is unavailable, S5 is deferred until it is. A "magnum opus" without independent verification is a marketing claim, not a security artifact.
- **Recovery flow must be honest.** "If you lose your key, your data is gone" is acceptable for some niches; not acceptable for thin-margin households who treated this as their financial dashboard. Choose the recovery model deliberately.

## Risks and Mitigations

| Risk | Mitigation |
|---|---|
| Audit reveals fundamental flaw | Triage; remediate; possibly defer launch. Acceptance is part of the gate. |
| AI-generated Rust crypto code has subtle correctness bugs | Property-based testing; external review; do not skip the audit. |
| PFM revenue regresses during S5 | Pause workstreams 1, 4, 5 until PFM recovers. Workstream 6 is mandatory. |
| Open-source crate goes ignored at launch | Dev-channel reputation from S4 is the mitigation. If S4 didn't establish reach, S5 launch will struggle regardless. |
| Forgot-password disaster damages PFM trust | Gated rollout; recovery model committed before user-facing default. |
| Owner burnout | Quarterly self-review per `kill_commit_gates.md` §6 still applies. S5 is not exempt. |

## Verification Gate

Per `validation_gates.md` Phase S5 exit triggers.

## Definition of Done for Phase S5

- All exit triggers met.
- PFM revenue is intact or improved.
- `django-zk` has independent audit report and measurable adoption signal.
- Owner's reputation as "the person who made ZK encryption practical for Django" is **earned, not claimed**.
- S6 entry gate evaluated.
