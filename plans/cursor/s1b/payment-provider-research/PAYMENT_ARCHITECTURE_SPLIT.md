# Payment architecture split — hypothesis (PH vs US)

**Status:** Research draft. Flows below assume a **dual-entity** pattern (PH operating merchant + US technical vendor) **only if** counsel and HitM adopt that structure. **Not** implementation spec until signed off.

## Phase 1 — PH wedge (S1.B assumption space)

**Entities (hypothesis):**

1. **PH merchant of record** — Filipino-owned vehicle suitable for PSP KYB (e.g. DTI sole prop or corp — **vehicle TBD**).
2. **US vendor** — HitM-owned US LLC (or other US entity) providing license/services **under contract**, if counsel approves.

**Money flow (conceptual):**

1. PH user pays subscription in **PHP** via PSP (e.g. PayMongo / Xendit — **TBD**).
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
