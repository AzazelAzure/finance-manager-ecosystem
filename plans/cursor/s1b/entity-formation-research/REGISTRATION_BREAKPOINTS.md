# When HitM *needs* a formal business entity

**Purpose:** Separate **emotion** (“we should look professional”) from **hard gates** (cannot proceed without a legal person). Use this to sequence spend and counsel hours.

## Principles

1. **Smallest legal person that clears the next gate** beats “perfect cap table” if revenue is still unproven.
2. **Personal / founder** activity is often fine for **pre-revenue R&D**; gates usually appear at **money in**, **money out to strangers**, **regulated data**, or **counterparty insistence**.
3. Each gate below should get a **date observed**, **gate cleared by (entity type + jurisdiction)**, and **citation** (PSP doc, statute, contract clause).

## Breakpoint table (fill as verified)


| #   | Gate                                            | Typical blocker if unincorporated              | PH-local entity?             | US entity?                      | Notes / source target            |
| --- | ----------------------------------------------- | ---------------------------------------------- | ---------------------------- | ------------------------------- | -------------------------------- |
| B1  | Collect **subscription revenue** from strangers | PSP merchant agreement requires business KYB   | Often yes for wallet-first   | Sometimes yes (Stripe etc.)     | Tie to payment-provider research |
| B2  | **App store** merchant / legal seller of record | Google Play / Apple legal entity fields        | Depends on account country   | Often US acceptable             | Store console terms              |
| B3  | **Hire employees** (PH or US)                   | Employer of record / SSS PhilHealth etc.       | Yes for PH hires             | US for US hires                 | EOR vs own entity                |
| B4  | **Sign B2B contracts** (schools, banks)         | Counterparty requires corp seal, AOI, SEC cert | Usually PH or foreign branch | US LLC often accepted           | Redlines                         |
| B5  | **VAT / OSS** style obligations                 | Revenue threshold or local digital VAT rules   | TBD with tax advisor         | TBD                             | BIR circulars                    |
| B6  | **Founding member** / **refunds** program       | Consumer protection, chargeback entity         | As per ToS draft             | As per ToS draft                | S1.F legal docs                  |
| B7  | **Open business bank account** for settlement   | Bank KYB                                       | PH corp common               | US corp + international banking | Bank checklist                   |
| B8  | **Hold IP** (trademark, codebase assignee)      | Clean acquisition / investor diligence         | Any stable jurisdiction      | US common                       | IP assignment agreement          |


## Suggested HitM ordering (hypothesis — validate)

- **Before B1:** Confirm **entity scenario** with [DECISION_MATRIX.md](./DECISION_MATRIX.md) (HitM locks + counsel) and PSP KYB; do not treat research drafts as final structure.
- **At B1:** Entity must match **PSP onboarding** ([US_ENTITY_PH_OPERATIONS.md](./US_ENTITY_PH_OPERATIONS.md) + payment plan).
- **Before B6:** Entity aligned with **ToS / Privacy / Refund** signatory (S1.B exit).

## “Do not incorporate yet” zone

Document explicit reasons if HitM stays **pre-entity**:

- No paid flows, no KYB, no employees, IP held by founders with written **intent to assign** on incorporation (counsel template).

## Links

- [HITM_LOCAL_CONTEXT.md](./HITM_LOCAL_CONTEXT.md)
- [DECISION_MATRIX.md](./DECISION_MATRIX.md) — add “Breakpoint first hit” row when known.

