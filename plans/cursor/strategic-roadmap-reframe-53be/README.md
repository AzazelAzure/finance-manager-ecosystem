# Strategic Roadmap Reframe (Multi-Year Phased View)

## 0) Metadata

- Plan ID: `PLAN_STRATEGIC_ROADMAP_REFRAME_2026-04-28`
- Status: `active` (Phase S1; Stage S1.A → S1.B transition)
- Priority: `P0` strategic anchor; supersedes informal long-term planning
- Plan root: `plans/cursor/strategic-roadmap-reframe-53be/`
- Target areas: business positioning, monetization, product sequencing across PFM core, Android, ZK middleware, and future Sari-Sari B2B vertical

**Last revision:** 2026-04-30 post-beta huddle (major content revision; S1 split into 4 Stages; PH-first market lock; revenue path narrowed; per-product launch-state model).

## 1) Why This Plan Exists

The original `design_docs/` framing (Phase 1 Alpha / Phase 2 Beta Prep / Tracks A–E) was a target list, not a strategy. This roadmap encodes the strategic reframe captured at huddles 2026-04-28 and 2026-04-30, anchored to:

- A sharper wedge (`safe-to-spend for thin-margin households, mobile-first, PH-local`).
- Realistic success criteria (`break-even at ~$100/mo overhead → ~45 PH paying subs`; personal-replacement target ₱100k/mo take-home).
- Real constraints (solo HitM + AI workforce; baby due 2026-06-15; ₱100/mo runtime cap; VA disability income floor; FEIE tax cliff).
- An ordered theory: PFM trust → bounty/ZK clout → Sari-Sari B2B vertical, with US market deferred behind explicit trigger.

**This plan is the source of strategic truth.** Tactical execution plans under `plans/cursor/<phase-stage>/<sub-plan>/` are subordinate.

## 2) Companion Documents

Read in this order when revisiting the plan:

1. `00_strategic_context.md` — wedge, personas, locked decisions, rejected options, lessons learned, personal operating constraints.
2. `01_unit_economics_and_costs.md` — pricing tiers, AI cost cap, FEIE cliff structuring, revenue path constraints.
3. `kill_commit_gates.md` — pre-committed decision points (master kill gate, phase transitions, family/health review).
4. `validation_gates.md` — quantitative triggers per Phase/Stage (entry, mid-Stage health, exit).
5. `PARKING_LOT.md` — deferred strategic decisions with explicit revisit triggers.
6. `phases/` — per-Phase detail packets (S1–S6).

## 3) Phase Map


| Phase  | Title                                                                   | Trigger to Enter                                                     | Trigger to Exit                                                       | Calendar Estimate                  |
| ------ | ----------------------------------------------------------------------- | -------------------------------------------------------------------- | --------------------------------------------------------------------- | ---------------------------------- |
| **S1** | Public Beta Launch + Position Lock-in (PH-only)                         | Beta runtime live; flagship product committed                        | S1.D exit met                                                         | Apr 2026 → ~Feb 2027               |
| **S2** | PH Public Launch + Scaling                                              | S1.D exit met                                                        | GCash/Maya direct integration live; AI tier mature; ≥100 paying users | Mar 2027 → Sep 2027                |
| **S3** | Android Scaling and Feature Parity                                      | S2 exit met (Android already pulled forward to Tight Beta in S1.B/C) | Android Play Store; ≥30% users on Android; sync stability             | Q4 2027 → Q2 2028 (overlaps S2)    |
| **S4** | Trust & Reputation Building                                             | PFM ≥50 paying users                                                 | Bounty program live; ZK spec public; dev-channel inbound              | Q3 2027 → Q3 2028 (overlaps S2/S3) |
| **S5** | ZK Middleware (structural revenue defense) + US re-engagement alignment | PFM ≥100 paying users; S4 exit                                       | `django-zk` released + audited; US re-engagement decision per P-6     | Q3 2028 → Q3 2029 (conditional)    |
| **S6** | Sari-Sari B2B Vertical                                                  | PFM ≥$1k MRR sustained 6mo; ≥3 sari-sari operators interested        | ≥10 paying operators; supplier prototype operational                  | Q1 2029 → Q2 2030 (conditional)    |


### S1 Stage breakdown


| Stage    | Title                  | What it covers                                                                                                                                                                            | Status (2026-04-30)   |
| -------- | ---------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------- |
| **S1.A** | Tight Invite Beta      | Owner + small invite cohort; flagship product committed; infra stable                                                                                                                     | **Completed**         |
| **S1.B** | Distribution Readiness | S0 fixes; Reflex archival; entity formation research; payment provider research; AI Economics Deep-Dive; landing polish; founding member program backend; "worth paying for" feature work | **Active** (entering) |
| **S1.C** | Founding Beta          | Founding-member program open; first 50–100 paying lifetime seats; AI tier launches PH-only                                                                                                | Pending (~Aug 2026)   |
| **S1.D** | Soft Public Open       | Anyone can sign up (PH); pricing visible; low-key promotion only                                                                                                                          | Pending (~Nov 2026)   |


**Phases overlap.** S2 and S3 run partially in parallel. S4 prep work happens during S2/S3 (security baseline, audit prep). Hard sequencing applies only to **entry triggers**, not work cadence.

## 4) Always-On Cross-Cutting Tracks

- **Solo-with-baby cadence:** quarterly self-review per `kill_commit_gates.md` §6; first execution 2026-06-30.
- **Velocity discipline:** 10hr/day, 55hr/week ceiling during Sprints; 6hr/day, 30hr/week during decompression. Local time-clock agent enforces. Cursor cap as forcing function (no overages).
- **Distribution presence:** ≥1 PH-local channel touchpoint per week from S1.C onward. Dev-channel from S4 onward.
- **Cost discipline:** monthly LLM cost audit (1st of month, ~30 min). First execution 2026-05-01.
- **Agent orchestration discipline:** human-review-only categories (money math, auth, migrations) never relaxed. Manual merge for verification (Lesson 6.7).
- **Documentation sync:** every Stage transition triggers design-docs sync.

## 5) What This Plan Explicitly Does Not Do

- It does not replace `design_docs/`. Behavior changes still trigger doc sync per existing protocol.
- It does not replace tactical Execution Plans. Those live under `plans/cursor/<phase-stage>/<sub-plan>/`.
- It does not commit to S5/S6 absolutely. Both are conditional on prior-Phase trigger gates.
- It does not encode US market acquisition (deferred behind P-6 trigger; see `PARKING_LOT.md`).
- It does not encode partnership/acquisition optionality (handled if/when inbound arrives).

## 6) Completion Criteria for the Roadmap Itself

This roadmap is "alive" while:

- At least one of S1–S6 is the active Phase.
- Validation gates and kill/commit gates are reviewed at their stated cadence.
- Phase/Stage exits trigger design-docs sync.

This roadmap is "retired" when:

- All conditional phases (S5, S6) are either executed-and-completed or formally abandoned.
- OR the master kill gate fires (see `kill_commit_gates.md` §1) and the project is wound down.

## 7) Execution Handoff

Active Stage (S1.B) handoff:

- Plan root: `plans/cursor/strategic-roadmap-reframe-53be/`
- Active Stage packet: `phases/S1_public_beta_position.md` (+ Stage-level `plans/cursor/s1b/README.md`)
- Active Stage execution plans: under `plans/cursor/s1b/<sub-plan>/`
- Pre-governance plans (now closed): see `_governance/plan_registry.md` Recently Completed section

## 8) Plan Governance Layer

Tactical plans that execute against this strategic roadmap follow the **plan governance layer** at `plans/_governance/`:


| File                                        | Read when                                          |
| ------------------------------------------- | -------------------------------------------------- |
| `plans/_governance/README.md`               | First, every session                               |
| `plans/_governance/glossary.md`             | First, every session — canonical vocabulary        |
| `plans/_governance/plan_template.md`        | Authoring a plan                                   |
| `plans/_governance/plan_registry.md`        | Before authoring or starting work                  |
| `plans/_governance/plan_lifecycle.md`       | At every status transition                         |
| `plans/_governance/execution_protocols.md`  | Producing HitM-facing Slack messages               |
| `plans/_governance/deployment_protocol.md`  | Plan ships code to VPS                             |
| `plans/_governance/branching_guidelines.md` | Producing or executing a feature on inactive color |


**Hierarchical plan structure (locked 2026-04-30):** new plans live under `plans/cursor/<phase-stage>/<sub-plan>/` (e.g. `plans/cursor/s1b/drift-cleanup/`). Strategic Plan stays at top level (`plans/cursor/strategic-roadmap-reframe-53be/`); not Stage-scoped.

**This strategic plan is not edited as part of tactical execution.** Subordinate plans update `validation_gates.md` and `kill_commit_gates.md` only at close, and only via the actions documented in `_governance/plan_lifecycle.md` Stage 5.

When commissioning new work:

1. Decide Phase/Stage (this README §3).
2. Read the relevant Phase doc under `phases/`.
3. Read the Stage-level README under `plans/cursor/<phase-stage>/README.md`.
4. Hand off to an agent with the Phase + Stage context; agent uses `_governance/plan_template.md` to author a new tactical plan.
5. Slack confirmation gates per `_governance/execution_protocols.md` §1 keep HitM in the loop without requiring desktop attention for routine progress.

