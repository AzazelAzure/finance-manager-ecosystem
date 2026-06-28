# Decision matrices and locks — entity formation sprint

**Purpose:** Single place for **branch calls**, **comparisons**, and **HitM signoff** once research closes. Numbers are **placeholders** until filled from advisors or primary sources.

**Governance:** Rows labeled **PROPOSED** or **research hypothesis** are **not** HitM locks. Only rows in **HitM locks** with a **HitM-confirmed** date and evidence count as S1.B deliverables. External drafting tools must not set `LOCKED` without explicit HitM signoff.

## Matrix 1 — Operating entity vs market (strategic)


| Option | PH customers (wedge) | US / Western later | Immigration dependency | Complexity |
| ------ | -------------------- | ------------------ | ------------------------ | ---------- |
| PH primary (HitM-owned) | Strong for wallets + local KYB **if** foreign participation and visa status allow | Add US later | High — needs eligible status | Medium |
| PH primary (spouse-led) + US LLC vendor | **SELECTED (HitM lock 2026-05-03).** Spouse MoR + HitM US LLC contracted for IP/services; PSP KYB on PH entity | US LLC already exists for later US revenue | Medium — spouse governance + Anti-Dummy discipline | Medium–high |
| US bridge (US LLC, PH customers) | **Subsumed:** US LLC is vendor to PH MoR, not standalone PH checkout entity | Natural | Lower than PH-owned-by-HitM | Medium — cross-border tax |
| Delay entity | Only if gates in [REGISTRATION_BREAKPOINTS.md](./REGISTRATION_BREAKPOINTS.md) allow | — | None until gate hit | Lowest until gate |

**Research note (FIA / minimum capital):** The **Foreign Investments Act** (e.g. [RA 7042](https://lawphil.net/statutes/repacts/ra1991/ra_7042_1991.html) as amended) and the **Foreign Investment Negative List** interact with **industry** and **corporate form**. Treat any minimum-capital figure as **verify with counsel** for the **actual** activity class.

## Matrix 2 — Timeline branch (lock when known)

**Status (HitM):** `TIME_GATED` — evidence for A vs B is **not** available until after **marriage → US license receipt (physical/digital) → BI validation trip** (~**two months** from marriage month; replace with concrete dates when scheduled). **Operating pipeline (L2–L4) is locked independently** of Matrix 2—see [README.md](./README.md) §0.2.

| Field | Value |
| ----- | ----- |
| Status | `TIME_GATED` / `LOCKED` |
| Branch selected | A (fast BI) / B (PH registry delay) / mixed |
| Date locked | |
| Evidence link or advisor memo ref | |
| Earliest realistic review date | *(after BI validation; HitM fills)* |

## Matrix 3 — Vehicle shortlist (jurisdiction × type)


| Jurisdiction | Vehicle | Formation $ (est.) | Annual $ (est.) | PSP fit | Notes |
| ------------ | ------- | ------------------ | --------------- | ------- | ----- |
| US (state TBD) | LLC | TBD | TBD | TBD | HitM vendor / IP — **locked role** (L3); confirm state + RA |
| US | C-Corp | TBD | TBD | TBD | If investors |
| PH | Sole prop (DTI) | TBD | TBD | High | **Primary candidate** for fastest PSP KYB — confirm with counsel |
| PH | OPC | TBD | TBD | TBD | If limited liability outweighs compliance |
| PH | Domestic corp | TBD | TBD | TBD | Only if counsel recommends over OPC/sole prop |

## HitM locks (signoff slots)


| Lock | Decision | Date | Migrates to |
| ---- | -------- | ---- | ----------- |
| L1 — Timeline branch | `TIME_GATED` (until BI post-license) | — | This README + optional PARKING_LOT P-2 |
| L2 — Primary operating entity | **LOCKED:** PH **spouse-led** operating company + HitM **US LLC** as **contracted** technical/IP vendor (written B2B terms; counsel to draft) | 2026-05-03 | `01_unit_economics_and_costs.md` §5.0 |
| L3 — US LLC role | **LOCKED:** YES — US LLC as **vendor to PH entity** (not undisclosed controller); US expansion reuses same LLC | 2026-05-03 | Payment provider + tax memo |
| L4 — Spouse-led PH path | **LOCKED:** YES — spouse is MoR for PH KYB/settlement; spouse **aware and agreed** on Anti-Dummy / management minimums | 2026-05-03 | Governance docs + counsel |
| L5 — First paid revenue breakpoint | | | [REGISTRATION_BREAKPOINTS.md](./REGISTRATION_BREAKPOINTS.md) |

## Trigger conditions for revisit (starter)

- MRR crosses threshold in advisor model (FEIE, PE, or VAT).
- PSP changes KYB rules or exits market.
- BI status changes (Branch A ↔ B).
- Counsel or SEC requires different PH vehicle or challenges intercompany structure.
- **Implementation split:** When roadmap requires **separate US vs PH deploy/repos** for PSP isolation—execute after payment lock + engineering gate (see [README.md](./README.md) §0.2 item 4).
