# Entity Formation — Ordered Action Sequence

> Distilled from all files in `plans/S1/S1.B/entity-formation-research/`.
> **What's locked vs what's left to do, in the order it needs to happen.**

---

## What's Already Decided (Locked 2026-05-03)

These are **done decisions** — they frame everything below.

| Lock | Decision |
| ---- | -------- |
| **L2** | PH **spouse-led** operating company is the merchant of record for PH revenue |
| **L3** | HitM **US LLC** is the contracted technical/IP vendor to the PH entity (not undisclosed controller) |
| **L4** | Spouse is aware, agreed, and will perform genuine management to satisfy Anti-Dummy requirements |

**L1 (timeline branch A vs B)** remains `TIME_GATED` — can't be resolved until BI validates the marriage package. The sequence below works around that.

---

## Phase 1 — Do Now (Pre-Marriage, No Blockers)

These have zero dependencies on marriage, BI, or counsel. Start immediately.

### 1. Complete the Utah marriage logistics
- **Owner:** HitM
- **Action:** Confirm firm calendar date with the county, verify embassy SF processing SLA, confirm fee schedule
- **Target:** Before baby due date (2026-06-15)
- **Reference:** [HITM_LOCAL_CONTEXT.md](file:///home/pproctor/Documents/python/finance_manager/plans/S1/S1.B/entity-formation-research/HITM_LOCAL_CONTEXT.md) §1

### 2. Research & shortlist US LLC formation state
- **Owner:** HitM + Gemini research
- **Action:** Compare Wyoming vs Delaware vs home state on: formation fee, annual franchise tax, registered agent cost, no-income-state filing requirements for a non-resident owner
- **Deliverable:** Fill [US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md](file:///home/pproctor/Documents/python/finance_manager/plans/S1/S1.B/entity-formation-research/US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md) row **P1**
- **Status:** `Open` — can do without any advisor

### 3. Prepare US LLC formation checklist
- **Owner:** HitM
- **Action:** Draft the concrete filing list — Articles of Organization / Certificate of Formation, Operating Agreement template, Registered Agent selection, EIN application (IRS SS-4), bank KYC documents needed
- **Deliverable:** Fill row **P3** in US_LLC doc
- **Status:** `Open`

### 4. Draft the PH Counsel questionnaire for engagement
- **Owner:** HitM (questionnaire already exists)
- **Action:** Review and finalize [PH_COUNSEL_QUESTIONNAIRE.md](file:///home/pproctor/Documents/python/finance_manager/plans/S1/S1.B/entity-formation-research/PH_COUNSEL_QUESTIONNAIRE.md) — all 4 sections covering Anti-Dummy roles, DTI vs OPC, intercompany agreements, BMBE classification
- **Status:** ✅ Draft complete — needs HitM final review before sending to counsel

### 5. Draft the US Tax Advisor questionnaire for engagement
- **Owner:** HitM (questionnaire already exists)
- **Action:** Review and finalize [TAX_ADVISOR_QUESTIONNAIRE.md](file:///home/pproctor/Documents/python/finance_manager/plans/S1/S1.B/entity-formation-research/TAX_ADVISOR_QUESTIONNAIRE.md) — LLC classification vs FEIE, PE risk, transfer pricing, Form 5471/8858 exposure
- **Status:** ✅ Draft complete — needs HitM final review before sending to advisor

### 6. Find and engage PH corporate counsel
- **Owner:** HitM
- **Action:** Identify a Philippine attorney with Anti-Dummy / foreign investment experience for SaaS. Send questionnaire (step 4). Budget for initial consultation.
- **Gating:** Nothing blocks starting the search now

### 7. Find and engage US CPA / international tax advisor
- **Owner:** HitM
- **Action:** Identify a US CPA experienced with FEIE + foreign-entity reporting for expats. Send questionnaire (step 5).
- **Gating:** Nothing blocks starting the search now

---

## Phase 2 — After Marriage + Document Receipt (≈ Marriage Month + 4–8 weeks)

These depend on having the US marriage license in hand.

### 8. Receive US marriage license (physical + digital)
- **Owner:** HitM (county + embassy pipeline)
- **Action:** Track document through Utah county → Philippine embassy SF → HitM
- **Deliverable:** License in hand = prerequisite for step 9

### 9. BI validation trip — resolve L1 (Branch A vs B)
- **Owner:** HitM
- **Action:** Present marriage documentation package to Bureau of Immigration for the intended residency/visa route. Determine if it's sufficient (Branch A) or requires PH civil registry annotation (Branch B, +6–8 months)
- **Deliverable:** Lock **L1** in [DECISION_MATRIX.md](file:///home/pproctor/Documents/python/finance_manager/plans/S1/S1.B/entity-formation-research/DECISION_MATRIX.md) Matrix 2 — set status to `LOCKED`, record branch + date + evidence

> [!IMPORTANT]
> **If Branch A:** HitM may be able to own/control PH entity directly — PH counsel confirms scope.
> **If Branch B:** Spouse-led path (already locked as default) proceeds; no structural change needed, just timeline confirmation.

---

## Phase 3 — Counsel-Dependent (Can Run in Parallel with Phase 2)

These require advisor responses from steps 6–7. Start as soon as counsel is engaged.

### 10. PH counsel: Lock vehicle choice (DTI sole prop vs OPC)
- **Owner:** PH counsel + HitM
- **Action:** Counsel reviews [DTI_VS_OPC_COMPARISON.md](file:///home/pproctor/Documents/python/finance_manager/plans/S1/S1.B/entity-formation-research/DTI_VS_OPC_COMPARISON.md) and answers questionnaire. Key decision: Does the liability shield of OPC justify the higher compliance burden at pre-revenue/early-revenue scale?
- **Deliverable:** Update [DECISION_MATRIX.md](file:///home/pproctor/Documents/python/finance_manager/plans/S1/S1.B/entity-formation-research/DECISION_MATRIX.md) Matrix 3 — PH row locked to DTI or OPC

### 11. PH counsel: Anti-Dummy guardrails for HitM's role
- **Owner:** PH counsel
- **Action:** Written guidance on what roles HitM can hold (bank signatory? PSP dashboard admin? technical advisor?), how to document the B2B vendor relationship so it's not construed as control
- **Deliverable:** Update [SPOUSE_INVOLVEMENT_REQUIREMENTS.md](file:///home/pproctor/Documents/python/finance_manager/plans/S1/S1.B/entity-formation-research/SPOUSE_INVOLVEMENT_REQUIREMENTS.md) with counsel's written boundaries

### 12. PH counsel: Draft intercompany agreement (IP license + services)
- **Owner:** PH counsel (+ US attorney review)
- **Action:** Written software license and B2B services agreement between PH Entity (A) and US LLC (B) — scope, pricing method, arm's-length terms, no implied management authority
- **Deliverable:** Fill row **P4** in US_LLC doc; feeds into PSP KYB and BIR documentation

### 13. US CPA: Lock LLC tax classification
- **Owner:** US CPA + HitM
- **Action:** Determine if disregarded entity is optimal vs S-corp election, given FEIE interaction, SE tax, and the licensing/services revenue stream
- **Deliverable:** Fill row **P2** in US_LLC doc

### 14. US CPA: PE / nexus analysis at low revenue
- **Owner:** US CPA + PH tax advisor
- **Action:** Does HitM physically coding in PH create permanent establishment for the US LLC? What's the state nexus exposure with no US physical presence?
- **Deliverable:** Fill row **P8** in US_LLC doc

### 15. Joint advisors: Transfer pricing & withholding
- **Owner:** PH + US advisors
- **Action:** Determine arm's-length method for intercompany fees (royalty vs services), BIR withholding obligations on PH→US payments, IRS documentation requirements at startup scale
- **Deliverable:** Fill rows **P6** and **P7** in US_LLC doc

### 16. US CPA: Foreign entity reporting (Form 5471 / 8858)
- **Owner:** US CPA
- **Action:** Does spouse's ownership of PH entity trigger constructive ownership reporting for HitM?
- **Deliverable:** Fill row **P7** (founder economics) context

### 17. PH counsel/BIR: Confirm BMBE eligibility for SaaS
- **Owner:** PH counsel + BIR RDO
- **Action:** Written confirmation that subscription SaaS is an eligible BMBE service, not excluded under RA 9178 Section 3(a) professional services exclusion
- **Deliverable:** Update [PH_TAX_BMBE_AND_DEDUCTIONS.md](file:///home/pproctor/Documents/python/finance_manager/plans/S1/S1.B/entity-formation-research/PH_TAX_BMBE_AND_DEDUCTIONS.md) §5 checklist item 5

---

## Phase 4 — Entity Formation (After Counsel Clears)

### 18. Form US LLC
- **Owner:** HitM
- **Action:** File Articles of Organization in chosen state, appoint registered agent, draft Operating Agreement (incorporating counsel's IP/services scope), obtain EIN, open US business bank account
- **Prerequisite:** Steps 2, 3, 12, 13 complete

### 19. Register PH entity (spouse-led)
- **Owner:** Spouse + HitM (support)
- **Action:** Register with DTI or SEC (per step 10 decision), obtain business permit from LGU, register with BIR (RDO), apply for BMBE Certificate of Authority if eligible (step 17)
- **Prerequisite:** Steps 10, 11, 17 complete; L1 resolution helpful but not strictly blocking if spouse-led path is default

### 20. Execute intercompany agreements
- **Owner:** Both entities + counsel
- **Action:** Sign the IP license + services agreement drafted in step 12. File IP assignment or license registrations if counsel requires.

### 21. Open PH business bank account
- **Owner:** Spouse
- **Action:** KYB with chosen PH bank — registration docs, business permit, TIN
- **Prerequisite:** Step 19 complete

---

## Phase 5 — PSP & Revenue Readiness (Gate B1)

### 22. PSP onboarding (PH entity as merchant of record)
- **Owner:** Spouse (KYB owner) + HitM (technical integration)
- **Action:** Submit KYB to PayMongo (or chosen PH PSP) under PH entity name. Confirm beneficial ownership disclosure rules. Connect settlement to PH business bank.
- **Prerequisite:** Steps 19, 20, 21 complete
- **Cross-reference:** [../payment-provider-research/README.md](file:///home/pproctor/Documents/python/finance_manager/plans/S1/S1.B/payment-provider-research/README.md)

### 23. Confirm US LLC is NOT accidentally KYB'd as PH merchant
- **Owner:** HitM
- **Action:** Verify PSP account ownership, settlement routing, and dashboard access align with counsel's Anti-Dummy guidance (step 11)
- **Deliverable:** Fill row **P9** in US_LLC doc

---

## Phase 6 — Documentation Sync (S1.B Exit Gate)

### 24. Update strategic docs with locked decisions
- **Owner:** HitM / Agent
- **Actions (all required for S1.B exit):**
  - Migrate entity choice + jurisdiction to `01_unit_economics_and_costs.md` §5
  - Update `PARKING_LOT.md` P-2 with dual-entity timing (active vs deferred)
  - Lock all remaining rows in [DECISION_MATRIX.md](file:///home/pproctor/Documents/python/finance_manager/plans/S1/S1.B/entity-formation-research/DECISION_MATRIX.md) (L1, L5)
  - Update [RESEARCH_ARTIFACTS.md](file:///home/pproctor/Documents/python/finance_manager/plans/S1/S1.B/entity-formation-research/RESEARCH_ARTIFACTS.md) with draft→completed status per artifact
  - CHANGELOG entry if CPPRD-worthy

---

## Summary Timeline

```
NOW ──────────── Phase 1 (steps 1-7) ──────────────────────┐
                                                            │
Marriage month ── Phase 2 (steps 8-9) ─────────────────────┤
                                                            │
Counsel engaged ── Phase 3 (steps 10-17) ──── runs parallel│
                                                            │
Counsel clears ── Phase 4 (steps 18-21) ───────────────────┤
                                                            │
Entity formed ── Phase 5 (steps 22-23) ── PSP gate ────────┤
                                                            │
All locked ── Phase 6 (step 24) ── S1.B exit ──────────────┘
```

> [!WARNING]
> **Phase 3 is the long pole.** Finding and engaging qualified PH counsel + US CPA will likely take longer than expected. Start steps 6 and 7 immediately — don't wait for the marriage paperwork.
