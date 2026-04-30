---
plan_id: PLAN_AUDIT_WEDGE_CONSISTENCY_2026-04-30
status: draft
priority: P2
created: 2026-04-30
updated: 2026-04-30
owner: pproctor

plan_root: plans/cursor/s1b/wedge-consistency-audit/
intended_branch: cursor/s1b/wedge-consistency-audit
parent_plan: plans/cursor/s1b/
target_repos:
  - finance_manager_web
  - design_docs

strategic_phase: S1
strategic_link: plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with:
  - PLAN_RESEARCH_ENTITY_FORMATION_2026-04-30
  - PLAN_RESEARCH_PAYMENT_PROVIDER_2026-04-30
  - PLAN_RESEARCH_AI_ECONOMICS_2026-04-30
  - PLAN_RESEARCH_DISTRIBUTION_CHANNEL_2026-04-30
  - PLAN_OPS_DRIFT_CLEANUP_2026-04-30
conflicts_with: []

slack_gates:
  pre_execution: none
  pre_merge: required
  pre_close: optional

deployment:
  required: false

standalone: true
standalone_notes: ""
---

# S1.B Sub-Plan — Wedge Consistency Audit

## 0) Strategic Inheritance

- **Wedge respected:** this audit IS the wedge-consistency mechanism.
- **Locked decisions touched:** `00_strategic_context.md` §1 (the wedge sentence) — every public-facing surface should lead with it.
- **Cost cap impact:** none (HitM time + minor agent cycles).
- **Validation gates affected:** S1.B exit; ongoing weekly automated audit during S1.C+.

## 1) Objective

Audit every public-facing surface of the product to verify alignment with the wedge sentence (`00_strategic_context.md` §1). Per huddle Topic 7 Q7.3: "we need consistency work to align future agents and design implementations." This audit is the baseline; S1.C+ runs weekly automated re-audits.

## 2) Scope

### In scope (per huddle Topic 7 audit scope proposal)

| Category | Surfaces |
|---|---|
| **Static product surfaces** | Landing hero, sub-hero, value props, dashboard primary KPI label, onboarding flow copy, settings/about pages, footer |
| **Public-facing docs** | README files (when public), ToS, Privacy, About |
| **Social/content surfaces** | FB business page about + recent posts (when published), app store description (when published), monthly content cadence posts (when active) |

### Consistency definition (locked)

A surface is "consistent" if it either:

- Leads with the wedge sentence verbatim, OR
- Has explicit thematic alignment with wedge (safe-to-spend / thin-margin language).

A surface is "inconsistent" if it:

- Mentions "budgeting" / "savings tracking" / "personal finance" generically without wedge anchor.
- Uses "Average Joe vs Finance Bro" framing (retired persona).
- Implies surplus-optimization vs survival-math (off-wedge).

### Out of scope

- Landing page polish design changes (separate W3 task).
- New copy creation (audit identifies; another task fixes).

## 3) Source Evidence

- `00_strategic_context.md` §1 (canonical wedge sentence).
- Live web app at `https://thehivemanager.com/`.
- Repo: `finance_manager_web/src/` for in-app copy.
- Design docs in `design_docs/01_Business_Vision.md`, etc.

## 4) Deliverables

Audit report with:

- Each surface categorized: ✅ consistent, ⚠ partial alignment, ✗ inconsistent.
- For each ✗ or ⚠: current text + suggested replacement that aligns with wedge.
- Recommendation: which fixes are P0 (must-fix before S1.C) vs P1 (queue for S1.C polish).
- Setup automation: agent script that re-runs this audit weekly during S1.C+.

## 5) Verification Gates

- Report covers all in-scope surface categories.
- Each ✗ surface has a concrete suggested fix.
- Weekly automation script in place (or explicitly deferred to a follow-up task).

## 6) Documentation Sync Required

- Audit report committed to `design_docs/40_System_Design/` (or `_governance/audits/wedge_consistency/`) with date.
- Follow-up tasks created for ✗ surfaces if not fixed in this plan.

## 7) Strategic Phase Impact

- S1.B exit: wedge consistency audit complete ✅
- Weekly re-audit cadence active during S1.C+.

## 8) Risks

Trivial. Audit doesn't change behavior; just identifies divergence.

## Estimated Effort

HitM: 1–2 hours (review + signoff).
Agent: 2–3 hours (sweep + report).
Total: ~3–5 hours; aim for 1 hour slip-in if possible.
