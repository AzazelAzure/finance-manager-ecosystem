---
plan_id: PLAN_RESEARCH_PAYMENT_PROVIDER_2026-04-30
status: draft
priority: P0
created: 2026-04-30
updated: 2026-04-30
owner: pproctor

plan_root: plans/cursor/s1b/payment-provider-research/
intended_branch: cursor/s1b/payment-provider-research
parent_plan: plans/cursor/s1b/
target_repos: []

strategic_phase: S1
strategic_link: plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on:
  - PLAN_RESEARCH_ENTITY_FORMATION_2026-04-30
blocks: []
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

# S1.B Sub-Plan — Payment Provider Research

## 0) Strategic Inheritance

- **Wedge respected:** yes — mobile wallet payment as primary path is a hard constraint (`00_strategic_context.md` §3.9). Forcing PH users to credit cards is a non-starter.
- **Locked decisions touched:** §3.9 (mobile wallet primary), §3.4 (GCash/Maya free PH ingestion), `01_unit_economics_and_costs.md` §2 (PHP-anchored pricing tiers).
- **Cost cap impact:** payment processor fees affect per-sub margin; AI cost cap unaffected.
- **Validation gates affected:** S1.B exit requires payment provider decision made; S1.C entry requires billing infra live with mobile wallet primary path.

## 1) Objective

Decide payment processor strategy: which provider(s) accept PH users, support mobile wallets (GCash/Maya) as primary payment method (not just card fallback), and integrate well with the entity choice from `entity-formation-research` plan.

## 2) Scope

### In scope

- Comparison: Stripe (international, USD settlement) vs PayMongo (PH-native) vs Xendit (regional including PH) vs GCash direct (if API access feasible).
- Entity-type compatibility (some processors require local entity).
- Settlement currency: PHP-direct vs USD-converted.
- Per-transaction fees + monthly fees + chargeback policies.
- Card vs mobile-wallet support specifically.
- Recurring subscription support.
- Refund policy compatibility.

### Out of scope

- Actual integration code (that's W3 / S1.C feature work).
- Founding member program backend (separate W5 task).
- GCash/Maya partnership negotiation (`PARKING_LOT.md` P-1).

## 3) Source Evidence

- Stripe PH availability + GCash support (Stripe added GCash 2024–2025).
- PayMongo product / pricing page.
- Xendit product / pricing page.
- HFM legal posture: US entity (per entity-formation-research outcome).

## 4) Deliverables

Research document with:

- Provider comparison matrix.
- Recommended primary + secondary provider (e.g. "Primary: PayMongo for PH; Secondary: Stripe for international/US Honorary Founders").
- Mobile wallet integration path (specific API/SDK).
- Estimated per-transaction effective margin at PHP-anchored prices.
- HitM final lock decision (signoff).
- Trigger to revisit (e.g. "if PayMongo monthly fees creep above X, re-evaluate").

## 5) Verification Gates

- HitM has read research output and signed off on payment provider choice.
- Decision migrated to `01_unit_economics_and_costs.md` §2 with explicit notes.

## 6) Documentation Sync Required

- `01_unit_economics_and_costs.md` §2 (pricing tier section) updated with chosen provider's effective margin.
- New design doc: `design_docs/40_System_Design/16_Payment_Provider_Choice.md` (optional; may be inline in unit economics).

## 7) Strategic Phase Impact

- S1.B exit: payment provider decision check-box ✅
- Feeds W5 founding member program backend (S1.C entry prep).

## 8) Risks

| Risk | Trigger | Rollback |
|---|---|---|
| All US-entity-friendly providers reject mobile-wallet primary | Research surfaces no viable option | Escalate to PARKING_LOT.md P-2 (PH entity may be needed earlier than planned) |
| PayMongo / Xendit have minimum revenue requirements (some PH processors have ₱X/mo minimums) | Provider declines below minimum | Defer to Stripe + manual GCash/Maya as workaround; note in implementation plan |
| Entity-formation outcome makes a previously-good provider unworkable | Mismatch surfaces during research | Iterate; entity decision may need re-review |

## Estimated Effort

HitM: 4–8 hours.
Agent: 4–6 hours compiling comparison + integration-path detail.
