---
plan_id: PLAN_RESEARCH_ENTITY_FORMATION_2026-04-30
status: draft
priority: P0
created: 2026-04-30
updated: 2026-04-30
owner: pproctor

plan_root: plans/cursor/s1b/entity-formation-research/
intended_branch: cursor/s1b/entity-formation-research
parent_plan: plans/cursor/s1b/
target_repos: []

strategic_phase: S1
strategic_link: plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks:
  - PLAN_RESEARCH_PAYMENT_PROVIDER_2026-04-30
parallel_safe_with:
  - PLAN_RESEARCH_AI_ECONOMICS_2026-04-30
  - PLAN_RESEARCH_DISTRIBUTION_CHANNEL_2026-04-30
conflicts_with: []

slack_gates:
  pre_execution: required
  pre_merge: none
  pre_close: required

deployment:
  required: false

standalone: true
standalone_notes: ""
---

# S1.B Sub-Plan — Entity Formation Research

## 0) Strategic Inheritance

- **Wedge respected:** yes — entity choice constrains payment infrastructure (PH wallet support); wedge requires PH-friendly billing.
- **Locked decisions touched:**
  - `00_strategic_context.md` §3.9 (mobile wallet payment as hard constraint)
  - `01_unit_economics_and_costs.md` §5 (FEIE structuring; this is upfront entity, not FEIE-trigger)
  - `PARKING_LOT.md` P-2 (US + PH dual-entity structure deferred)
- **Cost cap impact:** entity formation cost ~$500–$2,000 USD one-time (US LLC/OPC); within HitM personal budget for one-time setup, not recurring overhead.
- **Validation gates affected:** S1.B exit requires entity formation decision made.

## 1) Objective

Research and decide US entity structure (LLC vs OPC) for the business. Output: HitM-locked decision with documented rationale.

This is **HitM-led research**; agent role is to compile data, not decide.

## 2) Scope

### In scope

- Entity types comparison (US LLC vs US OPC vs sole proprietorship).
- Tax implications for US-citizen-living-in-PH (FEIE interactions).
- Cost of formation + ongoing compliance.
- Payment infrastructure compatibility (which entity type makes Stripe / PayMongo / GCash easier).

### Out of scope

- Actual entity formation paperwork.
- PH-side entity formation (deferred per PARKING_LOT.md P-2).
- Tax filings / advisor engagement (that's a separate forward action).

## 3) Source Evidence

- IRS Form 2555 + FEIE rules (verify current year amount).
- US state requirements for LLC vs OPC (Delaware, Wyoming most common for solo founders).
- HitM personal context: US citizen, PH resident, VA disability income.

## 4) Deliverables

A research document with:

- Entity comparison table (LLC / OPC / sole prop columns; tax / compliance / payment-infra rows).
- Recommendation with reasoning.
- HitM final lock decision (signoff).
- Estimated formation cost + ongoing yearly cost.
- Trigger conditions for revisiting (e.g. "if MRR projects to FEIE within 12mo, re-engage tax advisor").

## 5) Verification Gates

- HitM has read research output and signed off on entity choice.
- Decision migrated to `01_unit_economics_and_costs.md` §5 with explicit lock.

## 6) Documentation Sync Required

- Update `01_unit_economics_and_costs.md` §5 with the locked entity choice.
- Possibly update `PARKING_LOT.md` P-2 with revised trigger (since upfront entity vs FEIE-triggered restructure are different scenarios).

## 7) Strategic Phase Impact

- S1.B exit: entity formation decision check-box ✅
- May feed into payment provider research (next plan in sequence).

## 8) Completion Criteria

- HitM signoff on entity choice.
- Documentation sync complete.

## 9) Risks

| Risk | Trigger | Rollback |
|---|---|---|
| Tax advisor disagrees with research finding | HitM consults advisor and gets different answer | Update research; HitM may amend lock; escalate to PARKING_LOT.md |
| Entity choice makes payment provider research harder than expected | Next plan reveals entity-specific friction | May need to revisit; document in DECISIONS log |

## Estimated Effort

HitM: 4–8 hours of reading + decision time.
Agent: 2–4 hours compiling comparison data and references.
