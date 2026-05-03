# Timeline branches — marriage recognition vs PH registry

**Read with:** [HITM_LOCAL_CONTEXT.md](./HITM_LOCAL_CONTEXT.md)  
**Purpose:** Decision tree for sequencing entity work without pretending a single timeline exists.

## Work while branch unknown (L1 time-gated)

HitM cannot lock **Branch A vs B** until **after BI validation** following Utah marriage + county-facilitated **embassy SF → PH** document flow and **license in hand** (see [HITM_LOCAL_CONTEXT.md](./HITM_LOCAL_CONTEXT.md) §1.1). Until then:

- **Do:** Fill [DECISION_MATRIX.md](./DECISION_MATRIX.md) **Matrix 3** (vehicles) and payment-provider matrices with **conditional columns**: US entity / PH entity HitM-owned / PH spouse-led interim, per provider KYB notes.
- **Do:** Advance [REGISTRATION_BREAKPOINTS.md](./REGISTRATION_BREAKPOINTS.md) so first paid revenue does not ambush you.
- **Do not:** Block payment research on L1; **final** PSP + entity pairing may remain **conditional** until Matrix 2 moves to `LOCKED`.

## Branch A — BI accepts US marriage package “enough” for residency path

**Trigger (definition):** BI (or relevant issuing authority) accepts documentation sufficient for the **intended residency status** without waiting for full PH civil-registry completion.

**Implied planning:**

- Accelerate **PH-eligible ownership/control** research ([PH_SPOUSE_LED_AND_TRANSFER.md](./PH_SPOUSE_LED_AND_TRANSFER.md) may shrink to “confirm only” if HitM can own directly).
- Prefer **local PH billing entity** for wallet-first wedge if KYC and MDR favor it (payment-provider plan).
- Keep **US sister entity** as a **parallel track** or Phase-2 incorporation; do not block PH go-to-market on US shell unless PSP or contracts require it.

**Risks:** Over-optimism on timeline; embassy/BIR/SEC steps still sequential.

## Branch B — PH registry / annotation required (6–8 month pipe)

**Trigger (definition):** Residency or civil effects for business purposes require **Philippine-side marriage registration or equivalent** that materially lags the US ceremony.

**Implied planning:**

- Treat **US entity serving PH** or **spouse-led PH entity** as serious paths during the gap ([US_ENTITY_PH_OPERATIONS.md](./US_ENTITY_PH_OPERATIONS.md), [PH_SPOUSE_LED_AND_TRANSFER.md](./PH_SPOUSE_LED_AND_TRANSFER.md)).
- **Do not stall product** on “wait for my corp”; use [REGISTRATION_BREAKPOINTS.md](./REGISTRATION_BREAKPOINTS.md) to see what can stay personal/hobby vs must incorporate.
- Revisit **dual-entity** notes in strategic `PARKING_LOT.md` P-2 when Branch B stabilizes.

## Branch selection — how to know which branch you are on


| Signal                                                                             | Branch A lean | Branch B lean |
| ---------------------------------------------------------------------------------- | ------------- | ------------- |
| BI / counsel confirms doc package complete                                         | ✓             |               |
| Embassy / PSA / local civil registry step still blocking “married for PH purposes” |               | ✓             |
| HitM can obtain TIN / open business bank as intended owner                         | ✓             |               |
| Only spouse can KYB for PH PSP in near term                                        |               | ✓             |


**Action:** When BI evidence exists, set Matrix 2 **Status** to `LOCKED`, fill branch + date + evidence. Until then Matrix 2 stays `TIME_GATED` per [HITM_LOCAL_CONTEXT.md](./HITM_LOCAL_CONTEXT.md) §1.1.

## Dependencies on other S1.B work

- **Payment provider research** may force a **minimum viable entity** earlier than immigration resolves (KYB rules).
- **AI economics** remains shelved until entity + PSP path clarifies (per `ai-economics-deep-dive` README).