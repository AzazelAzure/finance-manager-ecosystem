# Payment architecture split — PH vs US

**Status:** Research draft aligned to **HitM pipeline lock (2026-05-03)** — spouse-led PH MoR + HitM US LLC vendor ([`../entity-formation-research/README.md`](../entity-formation-research/README.md) §0.2). **Not** implementation spec until PSP + counsel artifacts are complete.

**PSP decision / locks:** [`DECISION_MATRIX.md`](./DECISION_MATRIX.md).

## Phase 1 — PH wedge (S1.B)

**Entities (HitM lock):**

1. **PH merchant of record** — **Spouse-led** Filipino vehicle for PSP KYB (DTI sole prop vs SEC **OPC** — **TBD** with counsel).
2. **US vendor** — HitM-owned **US LLC** under **written** B2B license/support agreements with the PH entity (arm’s-length fees **TBD** with tax advisors).

**Money flow (conceptual):**

1. PH user pays subscription in **PHP** via PSP (**PayMongo**).
2. PSP settles to **PH business bank** in the merchant’s legal name.
3. **Intercompany:** PH entity pays US entity per **written** license/support agreement; pricing must be **arm’s-length** (transfer-pricing memo — **do not** use informal percentage splits from chat as tax positions).

**Tax:** PH taxes on PH entity; US reporting on US entity; personal residency and **FEIE** are individual matters—**US PH tax advisors** only.

## Phase 2 — US / international customers (strategic deferral)

US-market re-engagement remains governed by **`PARKING_LOT.md` P-6** and roadmap docs—not by this research file. If/when US direct acquisition returns, a **separate** PSP path (e.g. Stripe) may attach to the **US LLC** merchant of record; billing code would need **multi-PSP** routing by region. Treat as **future** until P-6 and entity locks say otherwise.

## Engineering note

Region-based PSP selection is a **common** pattern; exact gateways and fallbacks are **implementation** work after provider signoff.

## Links

- [`README.md`](./README.md)
- [`PSP_COMPARISON_MATRIX.md`](./PSP_COMPARISON_MATRIX.md)
- [`../entity-formation-research/DECISION_MATRIX.md`](../entity-formation-research/DECISION_MATRIX.md)
- [`../entity-formation-research/SPOUSE_INVOLVEMENT_REQUIREMENTS.md`](../entity-formation-research/SPOUSE_INVOLVEMENT_REQUIREMENTS.md)
