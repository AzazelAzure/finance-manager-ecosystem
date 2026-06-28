# Session 1 — Legal & Entity (Cluster A)

**Date started:** 2026-05-06  
**Attendees:** HitM, spouse  
**Topics:** TP11 (Business Expansion Gates) → TP18 (Entity Creation Timelines) → TP25 (Entity Registration Fallback)  
**Status:** `in progress`

## Session flow

1. TP11 — Business expansion gates (→ [TP11_EXPANSION_GATES.md](./TP11_EXPANSION_GATES.md))
2. TP18 — Entity creation timelines (→ TP18_ENTITY_TIMELINES.md, created when reached)
3. TP25 — Entity fallback options (→ TP25_ENTITY_FALLBACK.md, created when reached)

## Running notes

### TP11 discussion

**Started:** 2026-05-06  
**Status:** `discussing` → decisions captured below

**Key findings:**

- Gate categories validated. The dependency chain confirms that most expansion gates are **blocked until post-baby financial stabilization**.
- OPC (One Person Corporation) **likely ruled out** for cost reasons. DTI sole proprietorship is the probable vehicle, pending counsel confirmation.
- Spouse is **not willing to take on business debt** (no business loans). HitM supports this. All costs (entity, legal, employee) come from HitM personal funds. This is a **hard constraint** for all downstream planning.
- **Family member identified for SMM role** — part-time, ~₱10k/month estimated. Needs counsel on legal structure for employment/contract arrangement. Gated to baby being a few months old.
- **PH counsel lead identified** — landlord's property owner (the subletter above current landlord) is a lawyer with US travel experience. Has been informally notified of potential future engagement. Good fit for PH-side legal needs (entity formation, Anti-Dummy, employment). **Not** suited for US tax/LLC counsel — separate US advisor still needed later.
- **S1.B timeline extension acknowledged and accepted** — longer cycle is fine. Most hiring and legal commitments deferred until post-baby financial picture is clear.
- **Engineering hire deferred to S1.C or later** — HitM anticipates that robust automation pipelines (with progress notifications) could eliminate the need for a dedicated engineer during S1.B. Focus is on making HitM an admin/planner rather than hands-on coder. Decision depends on automation hardening outcomes (→ TP5, TP14 in later sessions).

---

## Decisions made this session


| Decision ID | Topic                                | Decision                                                                                                                                                        | Rationale                                                                                                                                                 | Migrates to                                    |
| ----------- | ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------- |
| S1-D01      | DM-1: Hiring readiness gate sequence | **DEFERRED** post-baby. No hiring commitments until finances stabilize and budget is concrete.                                                                  | Cannot define monthly headcount budget until post-baby living costs are known. No business loans — all from HitM personal funds.                          | TP11 gates, S1.B README personal constraints   |
| S1-D02      | DM-2: Counsel engagement timing      | **DEFERRED** post-baby. PH counsel lead identified (landlord's property owner, lawyer w/ US experience) but formal engagement postponed.                        | Budget pressure during constrained months; baby is priority. Counsel contact is warm — can activate when ready.                                           | TP11 DM-4, entity-formation-research           |
| S1-D03      | DM-3: Training investment model      | **DEFERRED** to post-automation discussions. Engineer likely not needed until S1.C+. First non-engineering hire: family member for SMM at ~₱10k/mo (part-time). | If automation pipelines can handle engineering execution with HitM as admin/planner, dedicated engineer is premature. SMM is the immediate capacity need. | TP24, TP14, TP5                                |
| S1-D04      | Entity vehicle preference            | **DTI sole prop preferred** over OPC, pending counsel confirmation. OPC likely ruled out for cost reasons.                                                      | Lower formation cost, simpler compliance, faster registration. Liability exposure trade-off acknowledged — revisit if counsel recommends otherwise.       | entity-formation-research DECISION_MATRIX L5   |
| S1-D05      | Debt constraint                      | **NO business loans.** All business costs absorbed by HitM personal funds. Spouse will not take on debt burden. HitM supports.                                  | Hard constraint. Shapes all budget planning — hiring, legal, infra.                                                                                       | 01_unit_economics §9, all budget-dependent TPs |
| S1-D06      | SMM hire specifics                   | Family member, part-time, ~₱10k/mo. Legal structure TBD with counsel. **Gated** to baby being a few months old.                                                 | Known person reduces onboarding risk. Below Tier 0 floor from wage bands artifact (family rate). Still needs counsel on proper legal arrangement.         | TP2, TP24                                      |
| S1-D07      | PH counsel contact                   | Landlord's property owner (lawyer, has US experience). Informally warm. Not yet formally engaged.                                                               | Proximity advantage; PH law expertise confirmed; some US context. Separate US tax counsel still needed for FEIE/LLC.                                      | entity-formation-research DM-4                 |
| S1-D08      | S1.B timeline                        | **Extended timeline accepted.** Most legal/hiring gates pushed post-baby. Concrete timeline TBD when budget stabilizes.                                         | Baby due Jun 15; finances must stabilize; no rushing commitments with uncertain budget.                                                                   | validation_gates.md S1.B, S1.B README          |


## Parking lot (deferred from this session)


| Item                                            | Related TP      | Reason deferred                                                                                                                                                                                                                                                                                                                                                                                                                     | Target session/time                        |
| ----------------------------------------------- | --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------ |
| Exact monthly headcount budget                  | TP24, TP2       | Cannot determine until post-baby finances stabilize                                                                                                                                                                                                                                                                                                                                                                                 | Post-baby review (~Aug-Sep 2026)           |
| DTI vs OPC final decision                       | TP11, TP18      | Counsel confirmation needed; counsel engagement deferred                                                                                                                                                                                                                                                                                                                                                                            | When counsel is formally engaged           |
| US LLC formation timing                         | TP18            | Depends on PH entity being registered first; cascading delay                                                                                                                                                                                                                                                                                                                                                                        | Post PH entity formation                   |
| Intercompany agreement                          | TP18            | Requires both entities to exist                                                                                                                                                                                                                                                                                                                                                                                                     | Post both entity formations                |
| **Cross-border cash flow & tax topology**       | TP18, TP11      | Full payment routing: PH customers → PH entity → (license/service fees) → US LLC → HitM personal income. Tax at every node: PH withholding on outbound payments, US FEIE on LLC income, spouse's PH income tax on entity profits, transfer pricing compliance. Needs **joint PH + US counsel** — PH counsel (identified) for the PH side, separate US tax advisor for FEIE/LLC side. **Must be mapped before first revenue flows.** | When both counsel are engaged; pre-revenue |
| Employment legal structure for family SMM hire  | TP2, TP24       | Needs counsel input on proper arrangement                                                                                                                                                                                                                                                                                                                                                                                           | When counsel is engaged; post-baby         |
| Automation pipeline design for HitM admin model | TP5, TP14, DM-3 | Separate session (Session 5: Tooling & Agents)                                                                                                                                                                                                                                                                                                                                                                                      | Session 5                                  |


