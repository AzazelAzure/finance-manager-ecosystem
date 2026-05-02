---
plan_id: PLAN_RESEARCH_PAYMENT_PROVIDER_2026-04-30
status: draft
priority: P0
created: 2026-04-30
updated: 2026-05-02
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

## 0.5) Context bridge (HitM research threads — 2026-05-01)

Use this section when **context drifts** between payment work and adjacent S1.B topics. It does **not** replace deliverables in §4; it links conversations.

| Thread | How it connects to *this* plan |
|--------|--------------------------------|
| **PayMongo / PH aggregators (e.g. Xendit)** | Primary candidate path for **GCash/Maya-first** checkout; trades **MDR off-the-top** for faster integration. Output of this research must feed **`01_unit_economics_and_costs.md` §2**: replace the **~0.85** placeholder with a **blended net %** (list → settlement after PSP). |
| **Affordability vs margin + gate indexing** | Lower Pro list for conversion **raises** paying-user bars (`validation_gates.md` **Indexing paying-user gates**). PSP fees **lower net per sub** for the same list price—same mechanical effect. Payment research + pricing lock happen **together** at S1.B. |
| **Feature roadmap before final tiering** | **`01_unit_economics_and_costs.md` §2 (deferred block):** free vs paid entitlements are **not** final until S1.B **Group D** scope is stable. Payment flows (SKUs, one-time Founding vs recurring Pro) still land here as **provider capabilities**. |
| **`PARKING_LOT.md` P-8 (Pro trial)** | **Trial + wallet verification:** industry pattern is first period free with **instrument on file**; copy and law are HitM—but **technical** questions (auth vs first charge, **failed renewal → downgrade**, whether wallet can be “verified” like a card) are **processor-specific**. This plan’s comparison matrix should include **subscription + trial** behavior for each short-listed PSP. |
| **Charge failure policy** | Acceptable fallback discussed: **failed charge → stop paid entitlements** (vs strong pre-verification). Document what each provider supports and how it affects UX/refund language. |
| **Entity formation (`depends_on`)** | Some wallet rails **require or favor a PH counterparty**; ties to **`PARKING_LOT.md` P-2** if US-only entity blocks the desired flow. **While L1 is time-gated** (BI validation after marriage + license), treat this dependency as **scenario documentation**, not a hard stop — see **§0.6** below. |
| **AI economics (parallel plan)** | PSP affects **net subscription revenue**; AI provider pricing affects **variable LLM cost**. Together they bound **true** Pro / Pro+ margin—see `../ai-economics-deep-dive/LLM_PROVIDER_COST_SNAPSHOT.md` for the LLM side. |

## 0.6) Entity scenario coupling (L1 time gate)

**Entity plan hub:** [`../entity-formation-research/README.md`](../entity-formation-research/README.md) (see **§0.2** there). **Matrix 2 (timeline branch)** on the entity side may remain **`TIME_GATED`** until **marriage → US license in hand → BI validation** (~two months from marriage month; HitM refines dates in [`../entity-formation-research/HITM_LOCAL_CONTEXT.md`](../entity-formation-research/HITM_LOCAL_CONTEXT.md) §1.1).

**How payment research proceeds anyway**

1. **Comparison matrix columns** (minimum): `US entity (bridge)`, `PH entity (HitM-owned when eligible)`, `PH spouse-led interim`, `No entity yet` (only if [REGISTRATION_BREAKPOINTS.md](../entity-formation-research/REGISTRATION_BREAKPOINTS.md) allows).
2. **Rows:** each short-listed PSP × KYB docs, settlement currency, wallet rails, recurring + trial behavior, known blockers for non-PH legal persons.
3. **Outputs before L1 locks:** conditional recommendation (“**If** branch A … **then** …”; “**If** branch B … **then** …”) plus **single preferred** path if HitM must pick a default for engineering spikes.
4. **After L1 = `LOCKED`:** collapse to primary + optional secondary PSP aligned with locked entity path; sync [DECISION_MATRIX.md](../entity-formation-research/DECISION_MATRIX.md) L2/L3.

5. **PH tax / VAT registration:** If the operating assumption is a **PH entity**, map gross receipts to **VAT vs non-VAT** using [PH_TAX_BMBE_AND_DEDUCTIONS.md](../entity-formation-research/PH_TAX_BMBE_AND_DEDUCTIONS.md) (₱3M threshold and cites)—PSP settlement and invoice type must match BIR registration.

Plan YAML `depends_on: PLAN_RESEARCH_ENTITY_FORMATION_2026-04-30` means **coherent cross-links and scenario answers** in both folders—not “freeze payment research until BI.”

## 1) Objective

Decide payment processor strategy: which provider(s) accept PH users, support mobile wallets (GCash/Maya) as primary payment method (not just card fallback), and integrate well with the **entity scenario** from `entity-formation-research` (final pairing after L1 lock; until then **conditional** per **§0.6**).

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
- HFM legal posture: **per entity scenario** until [DECISION_MATRIX.md](../entity-formation-research/DECISION_MATRIX.md) L1/L2 lock; default narrative line in docs may stay “US entity” only if that remains the engineering placeholder.

## 4) Deliverables

Research document with:

- Provider comparison matrix **with entity-scenario columns** (§0.6); conditional recommendation acceptable until L1 `LOCKED`.
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
