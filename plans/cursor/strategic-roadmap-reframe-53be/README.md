# Strategic Roadmap Reframe (Multi-Year Phased View)

## 0) Metadata

- Plan ID: `PLAN_STRATEGIC_ROADMAP_REFRAME_2026-04-28`
- Status: `ready_for_execution` (Phase S1 only; later phases are gated)
- Priority: `P0` strategic anchor; supersedes informal long-term planning
- Plan root: `plans/cursor/strategic-roadmap-reframe-53be/`
- Intended orchestration branch: `cursor/strategic-roadmap-reframe-53be`
- Target areas: business positioning, monetization, product sequencing across PFM core, ZK middleware, and future Sari-Sari B2B vertical

## 1) Why This Plan Exists

The internal docs (`design_docs/01_Business_Vision.md`, `design_docs/20_Roadmap/Roadmap_Overview.md`) describe an "Average Joe vs Finance Bro" dual-persona PFM with ZK encryption and SaaS-far-future. That framing is a **target list**, not a strategy.

This roadmap encodes the strategic reframe captured in working sessions on **2026-04-28**, anchored to:

- A sharper wedge (`safe-to-spend for thin-margin households, mobile-first, PH-local`).
- Realistic success criteria (`break-even at ~$100/mo overhead within 18 months of public Beta; $1k MRR within 3-5 years`).
- Real constraints (`solo dev, baby due 2026-06, ~$2k/mo personal overhead, VA disability income floor, $140k FEIE tax cliff`).
- An ordered theory of how `PFM trust → bounty/ZK clout → Sari-Sari B2B vertical` actually compounds.

**This plan is the source of strategic truth.** The execution plans under `plans/cursor/api-reflex-beta-readiness-plan-53be/`, `plans/cursor/vps-beta-rollout-ops/`, and `plans/cursor/server-beta-install-bluegreen-53be/` are subordinate and feed into Phase S1 of this roadmap.

## 2) Companion Documents

Read in this order when revisiting the plan:

1. `00_strategic_context.md` — wedge, personas, success criteria, what was rejected and why.
2. `01_unit_economics_and_costs.md` — AI cost cap model, pricing tiers, $140k FEIE cliff structuring, overhead budget.
3. `kill_commit_gates.md` — pre-committed decision points (so tired-future-you doesn't have to invent them).
4. `validation_gates.md` — revenue/retention triggers that move you between phases.
5. `phases/` — per-phase detail packets (S1–S6).

## 3) Phase Map

| Phase | Title | Trigger to Enter | Trigger to Exit | Calendar Estimate |
|---|---|---|---|---|
| **S1** | Public Beta Launch + Position Lock-in | VPS baseline stable; safe-to-spend brand decision made | Public landing live + ≥10 paying PH users OR ≥50 active free users | Now → ~2026-09 |
| **S2** | PH Vertical Hardening | S1 retention ≥25% at day-60 | GCash/Maya ingestion live (free), AI tier MVP live, ≥30 paying users | ~2026-08 → ~2027-04 |
| **S3** | Mobile Offline-First (PH critical) | S2 web retention validates wedge | Android beta with offline SQLite + sync, PH community penetration measurable | ~2027-01 → ~2027-12 |
| **S4** | Trust & Reputation Building | PFM ≥50 paying users (proof of usage) | Bounty program live, ZK middleware spec public, dev-channel awareness measurable | ~2027-04 → ~2028-04 |
| **S5** | ZK Middleware Magnum Opus | PFM ≥100 paying users; bounty program scarred-and-healed | Public release of `django-zk` Rust middleware with PFM as live reference | ~2027-12 → ~2028-12 |
| **S6** | Sari-Sari B2B Vertical | PFM ≥$1k MRR + ≥200 PH users + dev reputation established | First 10 paying sari-sari operators; supplier-integration prototype | ~2028-06 → ~2029-12 |

**Phases overlap.** S2 and S3 run partially in parallel (web hardening continues while mobile is built). S4 prep work happens during S2/S3 (security baseline, audit prep). Hard sequencing applies only to phase **entry triggers**, not work cadence.

## 4) Always-On Cross-Cutting Tracks

These run continuously alongside whichever phase is active:

- **Solo-with-baby cadence**: weekly review of velocity vs. plan; monthly priority audit; quarterly kill/commit check (see `kill_commit_gates.md`).
- **Distribution presence**: maintain ≥1 PH-local channel touchpoint per week from S1 onward (Reddit, FB groups, OFW community, content). Dev-channel from S4 onward.
- **Cost discipline**: monthly LLM unit-cost audit; infrastructure cost cap enforced per `01_unit_economics_and_costs.md`.
- **Agent orchestration discipline**: human-review-only categories (money math, auth, migrations) never relaxed; daily 10-minute "what shipped yesterday" review; canary metric pages on deviation.
- **Documentation sync**: every phase exit triggers `design-docs-sync` to update `design_docs/01_Business_Vision.md` and `design_docs/20_Roadmap/`.

## 5) What This Plan Explicitly Does Not Do

- It does not replace `design_docs/`. Behavior changes still trigger doc sync per existing protocol.
- It does not replace the per-batch implementation plans (api-reflex, vps-beta-rollout-ops, etc.). Those are tactical execution; this is strategic orchestration.
- It does not commit to S5/S6 absolutely. Both are conditional on prior-phase trigger gates being met.
- It does not encode the US market expansion (deferred until S5 dev-channel reputation tested).
- It does not encode partnership/acquisition optionality (handled separately if/when offers arrive).

## 6) Completion Criteria for the Roadmap Itself

This roadmap is "alive" while:

- At least one of S1–S6 is the active phase.
- Validation gates and kill/commit gates are reviewed at their stated cadence.
- Phase exits trigger `design-docs-sync` updates.

This roadmap is "retired" when:

- All conditional phases (S5, S6) are either executed-and-completed or formally abandoned via a kill gate.
- Or, the master kill gate fires (see `kill_commit_gates.md` §1) and the project is wound down.

## 7) Execution Handoff

Active phase (S1) handoff to `orchestration-manager`:

- Plan root: `plans/cursor/strategic-roadmap-reframe-53be/`
- Active phase packet: `phases/S1_public_beta_position.md`
- Subordinate execution plans (already in flight):
  - `plans/cursor/api-reflex-beta-readiness-plan-53be/`
  - `plans/cursor/vps-beta-rollout-ops/`
  - `plans/cursor/server-beta-install-bluegreen-53be/`
- Subordinate plans report into S1 exit criteria; they do not have independent strategic authority.

## 8) Plan Governance Layer

Tactical plans that execute against this strategic roadmap follow the **plan governance layer** at `plans/_governance/`:

- `plans/_governance/README.md` — intent and agent reading order.
- `plans/_governance/plan_template.md` — required template for new plans (metadata header + strategic inheritance + dependency declarations + Slack gates).
- `plans/_governance/plan_registry.md` — portfolio-level status of every plan; **read first** when authoring or starting work.
- `plans/_governance/plan_lifecycle.md` — birth → validation → execution → close → archive protocol.
- `plans/_governance/execution_protocols.md` — Slack confirmation gate formats, agent handoff rules, parallel-execution rules.

**This strategic plan is not edited as part of tactical execution.** Subordinate plans update `validation_gates.md` and `kill_commit_gates.md` only at close, and only via the actions documented in `plan_lifecycle.md` Stage 5.

When the owner wants to commission new work without re-reading the entire strategic roadmap, the canonical pattern is:

1. Decide which strategic phase the work falls under (this README §3).
2. Read the relevant phase doc under `phases/`.
3. Hand off to an agent with the phase doc as context; the agent uses `_governance/plan_template.md` to author a new tactical plan.
4. Slack confirmation gates per `_governance/execution_protocols.md` §1 keep the owner in the loop without requiring desktop attention for routine progress.
