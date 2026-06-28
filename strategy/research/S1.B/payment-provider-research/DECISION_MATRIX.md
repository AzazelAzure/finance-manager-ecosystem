# Decision matrices and locks — payment provider sprint

**Purpose:** Single place for **PSP comparisons**, **capability tradeoffs**, and **HitM signoff** once research closes. Product numbers (MDR, minimums) **change** — confirm on each provider’s current pricing and docs before locking margin in `01_unit_economics_and_costs.md` §2.

**Governance:** Rows labeled **PROPOSED** or **research hypothesis** are **not** HitM locks. Only rows under **HitM locks (payment)** with **HitM-confirmed** dates count as this plan’s exit deliverable. External tools (Gemini, etc.) must **not** set payment locks without explicit HitM signoff — see [`../GEMINI_RESEARCH_README.md`](../GEMINI_RESEARCH_README.md). **CPPRD (2026-05-05):** HitM merged Gemini-assisted research on branch `cursor/s1b/gemini-research-cpprd` and confirmed **PM1–PM4**; re-verify fees and KYB checklists on PSP sites before go-live.

**Entity coupling:** PH **spouse-led** merchant of record + HitM **US LLC** vendor is **locked** in [`../entity-formation-research/DECISION_MATRIX.md`](../entity-formation-research/DECISION_MATRIX.md) **L2–L4** (2026-05-03). This file owns **PSP choice** and **billing mechanics**, not corporate structure.

**Working detail:** Feature-level comparison lives in [`PSP_COMPARISON_MATRIX.md`](./PSP_COMPARISON_MATRIX.md); money flow concepts in [`PAYMENT_ARCHITECTURE_SPLIT.md`](./PAYMENT_ARCHITECTURE_SPLIT.md).

---

## Matrix 1 — Primary PSP path vs wedge (strategic)

| Option | GCash / Maya as **primary** path | Recurring subscriptions | KYB on **PH** MoR (spouse-led) | Notes |
| ------ | -------------------------------- | ------------------------ | ------------------------------ | ----- |
| **PayMongo** | Yes | Yes (Maya native, GCash invoice workaround) | Yes (DTI supported) | **SELECTED PRIMARY** - Better e-wallet rates (Maya 1.79%, GCash 2.23%) |
| **Xendit** | Yes | Yes (Maya native, GCash restricted) | Yes (DTI supported) | Secondary alternative |
| **Stripe** | No | No (GCash/Maya recurring unsupported) | No (US entity required) | **DEFERRED ENTIRELY** until US deployment gates. |

**Selection column:** HitM fills **`SELECTED`** for PayMongo in the HitM locks below.

---

## Matrix 2 — PSP × operating capabilities

Use for **P-8 trial**, **failed renewal**, and **wallet vs card** behavior. Values below reflect **May 2026** research — **re-verify** with PayMongo / Xendit product docs before shipping.

| Capability | PayMongo | Xendit | Stripe (as applicable) | HitM minimum? |
| ---------- | -------- | ------ | ---------------------- | ------------- |
| GCash — one-time checkout | Yes (2.23%) | Yes (2.3%) | N/A | Required for wedge |
| Maya — one-time checkout | Yes (1.79%) | Yes (1.8%) | N/A | Required for wedge |
| GCash / Maya — **recurring** | Maya Yes, GCash No | Maya Yes, GCash No | N/A | Required for Pro subscription |
| Native subscription object vs invoice-only | Subscription API (Maya/Cards) + Links | Subscription API (Maya/Cards) + Invoices | N/A | |
| **Trial** period + instrument / wallet on file | Yes for Maya/Cards, No for GCash | Yes for Maya/Cards, No for GCash | N/A | Tie to `PARKING_LOT.md` P-8 |
| **Failed renewal** → downgrade / dunning | Subscription API dunning / webhooks | Subscription API webhooks | N/A | Per [`README.md`](./README.md) §0.5 |
| Refund / partial refund API | Yes via API / Dashboard | Yes via API / Dashboard | N/A | |
| Webhook reliability / idempotency story | Standard robust webhooks | Standard robust webhooks | N/A | Align with PWA D2 outbox where relevant |

---

## Matrix 3 — Settlement and economics

| Field | Value |
| ----- | ----- |
| Settlement currency (PH wedge) | PHP (default) |
| Estimated **blended** MDR net to MoR (list → after PSP) | **~2.0% (0.02)** blended wallet rate. Replaces `~0.85` placeholder in `01_unit_economics_and_costs.md` §2. |
| Monthly platform minimums (if any) | None (Pay-as-you-go) |
| Chargeback / dispute fee exposure | Standard dispute fees (wallet dispute rates are generally lower than card chargebacks) |
| FX exposure (if any non-PHP leg) | None on PH user -> PH MoR side |

---

## HitM locks (payment) — signoff slots

**Naming:** **PM1–PMn** are **payment-plan** locks only (do not confuse with entity plan **L1–L5**).

| Lock | Decision | Date | Migrates to |
| ---- | -------- | ---- | ----------- |
| **PM1** — Primary PSP (PH wedge, spouse-led MoR) | `LOCKED: PayMongo` | 2026-05-03 | `01_unit_economics_and_costs.md` §2; integration spec |
| **PM2** — Secondary / contingency PSP (if any) | `Xendit` | 2026-05-03 | Same + runbooks |
| **PM3** — Wallet-first confirmation (GCash + Maya acceptable paths) | `LOCKED: Maya Auto-Debit, GCash Manual Invoice` | 2026-05-03 | [`README.md`](./README.md); exit gate copy |
| **PM4** — Blended effective fee / net % for unit economics | `LOCKED: ~2.0%` | 2026-05-03 | `01_unit_economics_and_costs.md` §2 |
| **PM5** — Revisit trigger (e.g. fee change, KYB rule change) | | | This file + `CHANGELOG.md` |

---

## Trigger conditions for revisit (starter)

- PSP changes **pricing**, **KYB**, or **wallet** product rules.
- Entity counsel changes **PH vehicle** (DTI vs OPC) in a way that affects KYB with chosen PSP.
- MRR or VAT posture crosses threshold modeled with [`../entity-formation-research/PH_TAX_BMBE_AND_DEDUCTIONS.md`](../entity-formation-research/PH_TAX_BMBE_AND_DEDUCTIONS.md).
- Roadmap clears **US** acquisition (`PARKING_LOT.md` P-6) and **multi-PSP** or **Stripe-on-US-LLC** becomes active — see [`PAYMENT_ARCHITECTURE_SPLIT.md`](./PAYMENT_ARCHITECTURE_SPLIT.md).

---

*Last updated: 2026-05-05 — PM1–PM4 HitM-confirmed via Gemini research CPPRD; Matrix 2–3 filled from [`PSP_RESEARCH_NOTES_2026_05.md`](./PSP_RESEARCH_NOTES_2026_05.md).*
