# Decision matrices and locks — payment provider sprint

**Purpose:** Single place for **PSP comparisons**, **capability tradeoffs**, and **HitM signoff** once research closes. Product numbers (MDR, minimums) **change** — confirm on each provider’s current pricing and docs before locking margin in `01_unit_economics_and_costs.md` §2.

**Governance:** Rows labeled **PROPOSED** or **research hypothesis** are **not** HitM locks. Only rows under **HitM locks (payment)** with **HitM-confirmed** dates count as this plan’s exit deliverable. External tools (Gemini, etc.) must **not** set payment locks without explicit HitM signoff — see [`../GEMINI_RESEARCH_README.md`](../GEMINI_RESEARCH_README.md).

**Entity coupling:** PH **spouse-led** merchant of record + HitM **US LLC** vendor is **locked** in [`../entity-formation-research/DECISION_MATRIX.md`](../entity-formation-research/DECISION_MATRIX.md) **L2–L4** (2026-05-03). This file owns **PSP choice** and **billing mechanics**, not corporate structure.

**Working detail:** Feature-level comparison lives in [`PSP_COMPARISON_MATRIX.md`](./PSP_COMPARISON_MATRIX.md); money flow concepts in [`PAYMENT_ARCHITECTURE_SPLIT.md`](./PAYMENT_ARCHITECTURE_SPLIT.md).

---

## Matrix 1 — Primary PSP path vs wedge (strategic)

| Option | GCash / Maya as **primary** path | Recurring subscriptions | KYB on **PH** MoR (spouse-led) | Notes |
| ------ | -------------------------------- | ------------------------ | ------------------------------ | ----- |
| **PayMongo** | Verify current product matrix | Verify Subscriptions / invoices vs one-time | Strong fit for PH-native SME path | Default **research** column per [`README.md`](./README.md) §0.6 |
| **Xendit** | Verify PH wallet coverage | Verify recurring / tokenization vs card | Regional API; confirm PH catalog rules | Primary alternative column |
| **Stripe** (PH context) | Verify wallet vs card emphasis for PH users | Strong subscriptions story historically | US LLC **not** PH wedge MoR — contingency / US-later only | See [`PAYMENT_ARCHITECTURE_SPLIT.md`](./PAYMENT_ARCHITECTURE_SPLIT.md) Phase 2 |
| **Hybrid** (e.g. PH PSP + Stripe later for US) | Per-region routing | Engineering + compliance cost | After P-6 / split-repos gates | **Future** — do not assume for wedge |

**Selection column:** HitM fills **`PRIMARY_CANDIDATE`** / **`SELECTED`** here or in **HitM locks** below when signoff happens.

---

## Matrix 2 — PSP × operating capabilities (fill from research)

Use for **P-8 trial**, **failed renewal**, and **wallet vs card** behavior. Replace `TBD` with verified notes + source date.

| Capability | PayMongo | Xendit | Stripe (as applicable) | HitM minimum? |
| ---------- | -------- | ------ | ---------------------- | ------------- |
| GCash — one-time checkout | TBD | TBD | TBD | Required for wedge |
| Maya — one-time checkout | TBD | TBD | TBD | Required for wedge |
| GCash / Maya — **recurring** | TBD | TBD | TBD | Required for Pro subscription |
| Native subscription object vs invoice-only | TBD | TBD | TBD | |
| **Trial** period + instrument / wallet on file | TBD | TBD | TBD | Tie to `PARKING_LOT.md` P-8 |
| **Failed renewal** → downgrade / dunning | TBD | TBD | TBD | Per [`README.md`](./README.md) §0.5 |
| Refund / partial refund API | TBD | TBD | TBD | |
| Webhook reliability / idempotency story | TBD | TBD | TBD | Align with PWA D2 outbox where relevant |

---

## Matrix 3 — Settlement and economics (placeholders)

| Field | Value |
| ----- | ----- |
| Settlement currency (PH wedge) | PHP (default) / other: ___ |
| Estimated **blended** MDR net to MoR (list → after PSP) | **TBD** — replace `~0.85` placeholder in `01_unit_economics_and_costs.md` §2 when locked |
| Monthly platform minimums (if any) | TBD |
| Chargeback / dispute fee exposure | TBD |
| FX exposure (if any non-PHP leg) | TBD |

---

## HitM locks (payment) — signoff slots

**Naming:** **PM1–PMn** are **payment-plan** locks only (do not confuse with entity plan **L1–L5**).

| Lock | Decision | Date | Migrates to |
| ---- | -------- | ---- | ----------- |
| **PM1** — Primary PSP (PH wedge, spouse-led MoR) | `OPEN` | — | `01_unit_economics_and_costs.md` §2; integration spec |
| **PM2** — Secondary / contingency PSP (if any) | `OPEN` / `NONE` | — | Same + runbooks |
| **PM3** — Wallet-first confirmation (GCash + Maya acceptable paths) | `OPEN` | — | [`README.md`](./README.md); exit gate copy |
| **PM4** — Blended effective fee / net % for unit economics | `OPEN` | — | `01_unit_economics_and_costs.md` §2 |
| **PM5** — Revisit trigger (e.g. fee change, KYB rule change) | | | This file + `CHANGELOG.md` |

---

## Trigger conditions for revisit (starter)

- PSP changes **pricing**, **KYB**, or **wallet** product rules.
- Entity counsel changes **PH vehicle** (DTI vs OPC) in a way that affects KYB with chosen PSP.
- MRR or VAT posture crosses threshold modeled with [`../entity-formation-research/PH_TAX_BMBE_AND_DEDUCTIONS.md`](../entity-formation-research/PH_TAX_BMBE_AND_DEDUCTIONS.md).
- Roadmap clears **US** acquisition (`PARKING_LOT.md` P-6) and **multi-PSP** or **Stripe-on-US-LLC** becomes active — see [`PAYMENT_ARCHITECTURE_SPLIT.md`](./PAYMENT_ARCHITECTURE_SPLIT.md).

---

*Last updated: 2026-05-05 — created as payment-plan counterpart to entity `DECISION_MATRIX.md`.*
