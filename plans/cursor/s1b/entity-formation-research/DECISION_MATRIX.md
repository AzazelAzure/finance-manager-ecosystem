# Decision matrices and locks — entity formation sprint

**Purpose:** Single place for **branch calls**, **comparisons**, and **HitM signoff** once research closes. Numbers are **placeholders** until filled from advisors or primary sources.

## Matrix 1 — Operating entity vs market (strategic)


| Option                             | PH customers (wedge)                                                                | US / Western later | Immigration dependency       | Complexity                |
| ---------------------------------- | ----------------------------------------------------------------------------------- | ------------------ | ---------------------------- | ------------------------- |
| PH primary (HitM-owned)            | Strong for wallets + local KYB                                                      | Add US later       | High — needs eligible status | Medium                    |
| PH primary (spouse-led → transfer) | Strong if PSP accepts                                                               | Add US later       | Medium — spouse eligibility  | Medium–high               |
| US bridge                          | PSP-dependent                                                                       | Natural            | Low                          | Medium — cross-border tax |
| Delay entity                       | Only if gates in [REGISTRATION_BREAKPOINTS.md](./REGISTRATION_BREAKPOINTS.md) allow | —                  | None until gate hit          | Lowest until gate         |


## Matrix 2 — Timeline branch (lock when known)

**Status (HitM):** `TIME_GATED` — evidence for A vs B is **not** available until after **marriage → US license receipt (physical/digital) → BI validation trip** (~**two months** from marriage month; replace with concrete dates when scheduled). Until then, keep **scenario planning** live in [TIMELINE_BRANCHES.md](./TIMELINE_BRANCHES.md) and run **payment provider research** on **per-scenario KYB** ([`../payment-provider-research/README.md`](../payment-provider-research/README.md) §0.6).

| Field                             | Value                                       |
| --------------------------------- | ------------------------------------------- |
| Status                            | `TIME_GATED` / `LOCKED`                     |
| Branch selected                   | A (fast BI) / B (PH registry delay) / mixed |
| Date locked                       |                                             |
| Evidence link or advisor memo ref |                                           |
| Earliest realistic review date    | *(after BI validation; HitM fills)*        |


## Matrix 3 — Vehicle shortlist (jurisdiction × type)


| Jurisdiction   | Vehicle         | Formation $ (est.) | Annual $ (est.) | PSP fit | Notes        |
| -------------- | --------------- | ------------------ | --------------- | ------- | ------------ |
| US (state TBD) | LLC             |                    |                 |         |              |
| US             | C-Corp          |                    |                 |         | If investors |
| PH             | Sole prop (DTI) |                    |                 |         |              |
| PH             | OPC             |                    |                 |         |              |
| PH             | Domestic corp   |                    |                 |         |              |


## HitM locks (signoff slots)


| Lock                               | Decision | Date | Migrates to                                                  |
| ---------------------------------- | -------- | ---- | ------------------------------------------------------------ |
| L1 — Timeline branch               | `TIME_GATED` (until BI post-license) |      | This README + optional PARKING_LOT P-2                       |
| L2 — Primary operating entity      |          |      | `01_unit_economics_and_costs.md` §5                          |
| L3 — US bridge yes/no              |          |      | Payment provider + tax memo                                  |
| L4 — Spouse-led interim yes/no     |          |      | Governance docs + counsel                                    |
| L5 — First paid revenue breakpoint |          |      | [REGISTRATION_BREAKPOINTS.md](./REGISTRATION_BREAKPOINTS.md) |


## Trigger conditions for revisit (starter)

- MRR crosses threshold in advisor model (FEIE, PE, or VAT).
- PSP changes KYB rules or exits market.
- BI status changes (Branch A ↔ B).

