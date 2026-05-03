---
plan_id: PLAN_RESEARCH_PAYMENT_PROVIDER_2026-04-30
status: draft
priority: P0
created: 2026-04-30
updated: 2026-05-05
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
| **Entity formation (`depends_on`)** | **L2–L4 locked (2026-05-03):** PH spouse-led MoR + HitM US LLC vendor — see [`../entity-formation-research/README.md`](../entity-formation-research/README.md) **§0.2**. **L1** (BI/marriage recognition) may still be **`TIME_GATED`** — see **§0.6**. |
| **AI economics (parallel plan)** | PSP affects **net subscription revenue**; AI provider pricing affects **variable LLM cost**. Together they bound **true** Pro / Pro+ margin—see `../ai-economics-deep-dive/LLM_PROVIDER_COST_SNAPSHOT.md` for the LLM side. |

## 0.6) Entity coupling — L2–L4 locked; L1 time gate only

**Entity plan hub:** [`../entity-formation-research/README.md`](../entity-formation-research/README.md) — **§0.2** operating pipeline (HitM lock **2026-05-03**), **§0.3** PSP seating. [DECISION_MATRIX.md](../entity-formation-research/DECISION_MATRIX.md): **L2–L4** locked; **L1** (BI / marriage recognition) may remain **`TIME_GATED`** until **marriage → US license in hand → BI validation** ([`../entity-formation-research/HITM_LOCAL_CONTEXT.md`](../entity-formation-research/HITM_LOCAL_CONTEXT.md) §1.1).

**How payment research proceeds now**

1. **Primary column:** PSP KYB and rails for the **PH spouse-led settlement entity** (DTI vs OPC **TBD** with counsel)—this is the **default** row in [`PSP_COMPARISON_MATRIX.md`](./PSP_COMPARISON_MATRIX.md).
2. **US LLC column:** **Not** a PH PSP merchant of record; document only **cross-border settlement / invoicing** implications if any provider allows US entity to touch PH wallets (likely **no**—expect PH entity only for GCash/Maya-first wedge).
3. **Contingency columns:** Keep slim fallback only if counsel or PSP rejects the default (reference [DECISION_MATRIX.md](../entity-formation-research/DECISION_MATRIX.md) Matrix 1).
4. **Working artifacts:** [`PSP_COMPARISON_MATRIX.md`](./PSP_COMPARISON_MATRIX.md) and [`PAYMENT_ARCHITECTURE_SPLIT.md`](./PAYMENT_ARCHITECTURE_SPLIT.md) — update from “hypothesis only” to **pipeline-aligned** drafts; **HitM PSP choice** still requires this plan’s §5 verification + signoff.
5. **PH tax / VAT:** Map gross receipts to **VAT vs non-VAT** for the **PH MoR** using [PH_TAX_BMBE_AND_DEDUCTIONS.md](../entity-formation-research/PH_TAX_BMBE_AND_DEDUCTIONS.md).

**Next research dependency:** Deep **PH BIR + US LLC / personal tax** pass (intercompany pricing, HitM compensation, spouse tax)—parallel to PSP lock; not a substitute for advisors.

Plan YAML `depends_on: PLAN_RESEARCH_ENTITY_FORMATION_2026-04-30` is satisfied for **operating-structure** decisions; **payment provider choice** and **tax memos** remain open until HitM signoff on those plans.

## 0.65) Decision matrix and payment locks

**HitM signoff + strategic matrices:** [DECISION_MATRIX.md](./DECISION_MATRIX.md) — Matrix 1–3 (PSP path, capabilities, settlement economics) and **PM1–PM5** lock slots (**payment** locks; entity plan uses **L1–L5** separately).

## 1) Objective

Decide payment processor strategy: which provider(s) accept PH users, support mobile wallets (GCash/Maya) as primary payment method (not just card fallback), and integrate with the **locked PH spouse-led settlement entity** from `entity-formation-research` (**L2–L4**, 2026-05-03) plus contingency columns only if counsel requires. **HitM PSP signoff** remains the exit gate for this plan (L1 BI timeline is separate).

## 2) Scope

### In scope

- Comparison: **Stripe** (international, card + evolving wallet rails) vs **PayMongo** (PH-native) vs **Xendit** (regional including PH) vs GCash direct (if API access feasible).
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

- Stripe PH availability + GCash support (verify current product pages).
- PayMongo product / pricing page.
- Xendit product / pricing page.
- HFM legal posture: **PH spouse-led MoR + HitM US LLC vendor** per [../entity-formation-research/DECISION_MATRIX.md](../entity-formation-research/DECISION_MATRIX.md) L2–L4 (2026-05-03); cite PSP KYB under PH entity name in final write-up.
- **Payment locks:** fill [DECISION_MATRIX.md](./DECISION_MATRIX.md) **PM1–PM5** after HitM PSP signoff (do not conflate with entity **L** locks).

## 4) Deliverables

Research document with:

- Provider comparison matrix **pipeline-aligned** to PH spouse-led MoR (§0.6); **contingency** columns only if counsel requires; **HitM PSP signoff** still required for final primary provider.
- Recommended primary + optional secondary provider, **after** signoff.
- Mobile wallet integration path (specific API/SDK).
- Estimated per-transaction effective margin at PHP-anchored prices.
- HitM final lock decision (signoff) recorded in [DECISION_MATRIX.md](./DECISION_MATRIX.md) **HitM locks (payment)**.
- Trigger to revisit (e.g. "if PayMongo monthly fees creep above X, re-evaluate") — also logged in `DECISION_MATRIX.md` **PM5** / revisit section.

## 5) Verification Gates

- HitM has read research output and signed off on payment provider choice.
- Decision migrated to `01_unit_economics_and_costs.md` §2 with explicit notes.

## 6) Documentation Sync Required

- `01_unit_economics_and_costs.md` §2 (pricing tier section) updated with chosen provider's effective margin.
- New design doc: `design_docs/40_System_Design/16_Payment_Provider_Choice.md` (optional; may be inline in unit economics).

## 7) Strategic Phase Impact

- S1.B exit: payment provider decision check-box (pending HitM signoff).
- Feeds W5 founding member program backend (S1.C entry prep).

## 8) Risks

| Risk | Trigger | Rollback |
|---|---|---|
| All US-entity-friendly providers reject mobile-wallet primary | Research surfaces no viable option | Escalate to PARKING_LOT.md P-2 (PH entity may be needed earlier than planned) |
| PayMongo / Xendit have minimum revenue requirements (some PH processors have ₱X/mo minimums) | Provider declines below minimum | Document workaround path; revisit matrix |
| Entity-formation outcome makes a previously-good provider unworkable | Mismatch surfaces during research | Iterate; entity decision may need re-review |

## Estimated Effort

HitM: 4–8 hours.
Agent: 4–6 hours compiling comparison + integration-path detail.
