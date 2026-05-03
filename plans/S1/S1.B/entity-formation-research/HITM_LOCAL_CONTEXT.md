# HitM local context — working assumptions (entity sprint)

**Purpose:** Ground entity-formation research in facts HitM controls or is validating, so agents and future sessions do not re-derive context from chat.  
**Not legal advice:** Immigration and corporate eligibility are statutory and factual; verify every bullet with counsel or primary sources before relying on it commercially.

## 1) Marriage plan (working)

- **Intent:** Utah **county online marriage** process (solemnization online), then post-marriage **fees** to activate the full document package the county coordinates.
- **Automated pipe (HitM-described):** The county service routes documentation to the **Philippine embassy in San Francisco** for forwarding into the **Philippines**; HitM receives a **physical** marriage license and a **digital** copy. Exact fee schedule, turnaround SLAs, and checklist URLs are **TBD** (HitM to paste authoritative links or PDF names into this file when available).
- **Effect on research:** Two timelines remain possible depending on **BI** (and related steps) treating that package as sufficient for the intended residency route vs requiring further PH-side registry delay (see [TIMELINE_BRANCHES.md](./TIMELINE_BRANCHES.md)).

## 1.1) L1 timeline branch — time gate (HitM)

**Branch A vs B cannot be chosen on evidence until roughly two months after marriage work starts** (order of magnitude; refine with real dates):

1. **Marriage** — target **before baby due date (2026-06-15)**; confirm **firm calendar date** with the county and embassy timeline.
2. **US license** — processing and **shipping** time after solemnization until documents are in hand.
3. **BI** — in-person trip to **validate** that the package will be **recognized** for the intended immigration path.

Until step 3 completes, treat **L1 (timeline branch)** in [DECISION_MATRIX.md](./DECISION_MATRIX.md) as **TIME_GATED** — parallel research continues ([TIMELINE_BRANCHES.md](./TIMELINE_BRANCHES.md) “Work while branch unknown”), but do not pretend L1 is locked.

## 2) PH business ownership constraint (assumption to verify)

- **Working assumption:** Until HitM has a legal basis to own or control a domestic business in the Philippines (e.g. residency status that permits investment/ownership as described in applicable law), **direct PH incorporation as HitM-owned** may be blocked or impractical.
- **Research task:** Map which statuses allow **foreign national** ownership of PH domestic corporations (including OPC) vs nominee structures vs foreign branch/representative office — cite SEC/DTI guidance or advisor memo.

## 3) Bureau of Immigration (BI) uncertainty — driver of divergent timelines

- **Uncertainty:** Whether a **US marriage license / US solemnized marriage** package, as presented to BI for the relevant visa/residency route, is **sufficient without** waiting for full **Philippine civil registry** annotation or equivalent.
- **If sufficient (Branch A):** Faster path to statuses that unlock PH-side entity work HitM can own or control (subject to §2 verification).
- **If insufficient until PH-side completion (Branch B):** Model **6–8 months** additional delay for piping through PH registries (order of magnitude for planning; confirm with counsel and current embassy processing times).

## 4) Strategic preference if Branch A (fast recognition)

- **Preferred arc:** Stand up **PH-oriented operating entity** for the PH market first; preserve option for a **US sister company** later for US and other Western markets if product and economics justify dual structure.
- **Ties to:** [DECISION_MATRIX.md](./DECISION_MATRIX.md), payment provider research (entity KYC rails).

## 5) Worst-case / Branch B — US entity serving PH

- **Need:** If PH local ownership path is delayed and product must bill or contract, estimate **cost of doing business** for a **US entity** primarily serving customers in the Philippines: formation, ongoing compliance, **cross-border tax**, **withholding**, payment processor fit, and any **permanent establishment** or local registration triggers.
- **Artifact:** [US_ENTITY_PH_OPERATIONS.md](./US_ENTITY_PH_OPERATIONS.md).

## 6) Fallback if US path is not feasible

- **Explore:** Legality and typical mechanics of **opening in spouse’s name first** (where spouse is eligible), then **transferring ownership or control** under Philippine law once HitM’s status allows — including matrimonial property and securities transfer considerations.
- **Artifact:** [PH_SPOUSE_LED_AND_TRANSFER.md](./PH_SPOUSE_LED_AND_TRANSFER.md).

## 7) Breakpoints — when HitM *must* be a legal business

- **Need:** Clear triggers (e.g. first paid subscription, PSP onboarding, contract counterparty, BIR registration nexus, employer-of-record avoidance) rather than “feel ready.”
- **Artifact:** [REGISTRATION_BREAKPOINTS.md](./REGISTRATION_BREAKPOINTS.md).

## Open questions list (rolling)

1. Exact **BI checklist** for the intended visa/residency route with Utah-online marriage (document list, authentication chain).
2. Whether **SEC/DTI foreign equity rules** for the chosen PH vehicle require HitM’s specific status vs 100% Filipino-owned interim structure.
3. Whether **US LLC income** from PH customers creates **PH tax nexus** or **permanent establishment** exposure at low revenue — threshold research.
4. **Stripe / PayMongo / Xendit** KYB for **PH spouse-led MoR** (primary) vs contingency columns — **seated jointly** with [`../payment-provider-research/README.md`](../payment-provider-research/README.md) §0.6. **HitM pipeline lock (2026-05-03):** [`README.md`](./README.md) §0.2; strategic mirror [`01_unit_economics_and_costs.md`](../../../cursor/strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md) §5.0. **L1** (BI timeline) remains time-gated independently of PSP choice.