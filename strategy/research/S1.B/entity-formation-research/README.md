---

plan_id: PLAN_RESEARCH_ENTITY_FORMATION_2026-04-30
status: draft
priority: P0
created: 2026-04-30
updated: 2026-05-04
owner: pproctor

plan_root: plans/S1/S1.B/entity-formation-research/
intended_branch: cursor/s1b/entity-formation-research
parent_plan: plans/S1/S1.B/
target_repos: []

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks:

- PLAN_RESEARCH_PAYMENT_PROVIDER_2026-04-30
parallel_safe_with:
- PLAN_RESEARCH_AI_ECONOMICS_2026-04-30
- PLAN_RESEARCH_DISTRIBUTION_CHANNEL_2026-04-30
conflicts_with: []

slack_gates:
  pre_execution: required
  pre_merge: none
  pre_close: required

deployment:
  required: false

## standalone: true

standalone_notes: ""

# S1.B Sub-Plan — Entity Formation Research

## Task and slice IDs

Per [`governance/plan_template.md`](../../../../governance/plan_template.md) **§1a Task slices (T##.SL#)** and [`governance/branching_guidelines.md`](../../../../governance/branching_guidelines.md): when execution work is authored from this plan, use **tasks** `T##` and **slices** `T##.SL#` (**`SL`** avoids collision with Phase/Stage **S** notation). Executors must **ask clarifying questions** when decisions are underspecified instead of guessing.

## 0) Strategic Inheritance

- **Wedge respected:** yes — entity choice constrains payment infrastructure (PH wallet support); wedge requires PH-friendly billing.
- **Locked decisions touched:**
  - `00_strategic_context.md` §3.9 (mobile wallet payment as hard constraint)
  - `01_unit_economics_and_costs.md` §5 (FEIE structuring; entity timing interacts with revenue nexus)
  - `PARKING_LOT.md` P-2 (US + PH dual-entity structure deferred or revived depending on timeline branch)
- **Cost cap impact:** formation cash outlay must stay within HitM personal budget; recurring compliance must not silently consume runway (model explicitly in [US_ENTITY_PH_OPERATIONS.md](./US_ENTITY_PH_OPERATIONS.md)).
- **Validation gates affected:** S1.B exit requires **entity formation decision made** (which vehicle, which jurisdiction, and under which timeline branch).

## 0.1) Research hub — all artifacts in this folder

**Index:** [RESEARCH_ARTIFACTS.md](./RESEARCH_ARTIFACTS.md)

| Read first | Why |
| ---------- | ----- |
| [HITM_LOCAL_CONTEXT.md](./HITM_LOCAL_CONTEXT.md) | Marriage, residency, BI uncertainty, strategic preferences |
| [TIMELINE_BRANCHES.md](./TIMELINE_BRANCHES.md) | Branch A (fast recognition) vs Branch B (PH registry delay) |
| [REGISTRATION_BREAKPOINTS.md](./REGISTRATION_BREAKPOINTS.md) | When a legal business becomes *necessary* |
| [US_ENTITY_PH_OPERATIONS.md](./US_ENTITY_PH_OPERATIONS.md) | US entity primarily serving PH — cost and feasibility scaffold |
| [PH_SPOUSE_LED_AND_TRANSFER.md](./PH_SPOUSE_LED_AND_TRANSFER.md) | Spouse-led PH entity and later transfer — counsel checklist |
| [DECISION_MATRIX.md](./DECISION_MATRIX.md) | Matrices and signoff slots |
| [US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md](./US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md) | US LLC formation + US↔PH tax **pathway matrix** and Gemini drop log (before PSP go-live) |
| [PH_TAX_BMBE_AND_DEDUCTIONS.md](./PH_TAX_BMBE_AND_DEDUCTIONS.md) | PH entity assumption: BMBE law text, VAT/CIT breakpoints, deductions (NIRC Sec. 34), primary links |

**Disclaimer:** This sub-plan contains **research scaffolding and questions**, not legal, tax, or immigration advice. Confirm with qualified advisors in PH and US before acting.

## 0.2) Operating pipeline (HitM lock — 2026-05-03)

HitM confirms the **default operating structure** for the PH wedge (subject to counsel, PSP KYB, and written intercompany agreements):

1. **PH primary business — spouse-led.** Filipino-owned vehicle (DTI sole proprietorship vs SEC **OPC** or other form **TBD** with counsel) is the **merchant of record** for PHP settlement, local tax filings, and PSP onboarding. Spouse has **agreed** to minimum genuine management and governance needed to mitigate **Anti-Dummy** risk; see [SPOUSE_INVOLVEMENT_REQUIREMENTS.md](./SPOUSE_INVOLVEMENT_REQUIREMENTS.md) and [PH_SPOUSE_LED_AND_TRANSFER.md](./PH_SPOUSE_LED_AND_TRANSFER.md).
2. **HitM US LLC — contracted vendor.** US entity acts as **independent technical / IP vendor** to the PH operating company (license + services), **not** as undisclosed controller of the PH business. Intercompany pricing and personal tax (US citizen; spouse tax posture) require a **dedicated PH + US advisor pass**—treat as **high priority follow-on research**, not implied by this lock alone.
3. **US market later.** The same US LLC is the natural **sister / expansion** vehicle for US-facing revenue when roadmap gates (e.g. `PARKING_LOT.md` P-6) allow—avoids standing up a separate US shell solely for that unlock.
4. **Future implementation split (when gates clear).** Plan for **separate product/repo or deploy lanes** so **PH wallet rails** (e.g. PayMongo / Xendit) are not entangled in US-only stacks and **US card rails** (e.g. Stripe) are not entangled in PH-only stacks—reduces regulatory and KYB cross-contamination. Exact split is an **engineering + compliance** decision after payment provider lock and volume thresholds.

**L1 (BI / marriage recognition timeline)** remains **`TIME_GATED`** in [DECISION_MATRIX.md](./DECISION_MATRIX.md) Matrix 2; it does **not** invalidate the operating pipeline above.

## 0.3) Payment provider research — joint seating (entity × PSP)

**L1 (timeline branch)** may stay **`TIME_GATED`** for ~**two months** after the marriage month until **BI validates** recognition ([HITM_LOCAL_CONTEXT.md](./HITM_LOCAL_CONTEXT.md) §1.1, [DECISION_MATRIX.md](./DECISION_MATRIX.md) Matrix 2). That does **not** idle payment work.

- **Run in parallel:** [`../payment-provider-research/README.md`](../payment-provider-research/README.md) with PSP matrix keyed to the **locked PH spouse-led + US LLC vendor** pipeline (**§0.2**), plus **contingency columns** only if counsel requires a fallback. Capture **KYB / onboarding** per PSP for the PH settlement entity.
- **Feed back:** PSP constraints update [DECISION_MATRIX.md](./DECISION_MATRIX.md) Matrix 3 (vehicle shortlist) and [REGISTRATION_BREAKPOINTS.md](./REGISTRATION_BREAKPOINTS.md) B1.
- **Final lock:** When L1 becomes `LOCKED`, collapse PSP recommendation from conditional rows to a single **primary path** (or explicit hybrid), still subject to counsel.

YAML on the payment plan still lists `depends_on: entity-formation`; interpret that as **shared scenario documentation + breakpoints**, not “block all payment research until BI returns.”

## 0.4) Execution posture (HitM — 2026-05-04)

- **Counsel-heavy tail:** Vehicle choice (DTI vs OPC), written intercompany terms, and **US LLC registration + tax** modeling require **paid advisors** and embassy/BI evidence — not parallelizable as pure engineering.
- **Not shelved:** Short-cycle research (e.g. Gemini) on **US LLC formation requirements and tax pathways** continues when HitM has bandwidth; capture drops in [US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md](./US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md) §4.
- **Not a PWA blocker:** **PWA implementation** (S1.B Group D) may proceed without completing this tail — offline/install/resync work does not depend on PSP merchant KYB.
- **PSP gate:** **Production PSP integration** (merchant onboarding, settlement in PH entity name, intercompany cash movement) **does** depend on clearing the US + PH setup to advisor comfort — treat [US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md](./US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md) as the **prep workbook** for that gate.

## 1) Objective

Research and **decide** (HitM signoff):

1. **Timeline branch** — how marriage documentation affects **when** HitM can own or control a PH entity vs need a bridge ([TIMELINE_BRANCHES.md](./TIMELINE_BRANCHES.md)).
2. **Operating entity** — **Pipeline locked** per **§0.2** (spouse-led PH + HitM US LLC vendor); remaining work is **vehicle choice** (DTI vs OPC), **documentation**, and **advisor signoff**, not a greenfield structure search.
3. **Fallback paths** — Retained as **contingency** reading if counsel or PSP forces a change ([US_ENTITY_PH_OPERATIONS.md](./US_ENTITY_PH_OPERATIONS.md); [PH_SPOUSE_LED_AND_TRANSFER.md](./PH_SPOUSE_LED_AND_TRANSFER.md)).
4. **Breakpoint discipline** — smallest entity that clears the next real gate ([REGISTRATION_BREAKPOINTS.md](./REGISTRATION_BREAKPOINTS.md)).

Output: **HitM-locked** decisions recorded in [DECISION_MATRIX.md](./DECISION_MATRIX.md) and migrated to `01_unit_economics_and_costs.md` §5.

This is **HitM-led research**; agent role is to compile structure, questions, and citation targets—not to choose immigration outcomes or corporate vehicles.

## 2) Scope

### In scope

- Entity and jurisdiction comparison aligned to **PH-first revenue** and optional **US sister** later.
- Tax and compliance **question lists** for US citizen living in PH (FEIE interactions; cross-border SaaS — advisor targets, not conclusions).
- Cost of formation + ongoing compliance (US and PH paths).
- **Philippine tax:** BMBE vs regular domestic corporation, revenue registration breakpoints (e.g. VAT), deductible expenses — [PH_TAX_BMBE_AND_DEDUCTIONS.md](./PH_TAX_BMBE_AND_DEDUCTIONS.md) (statute + PwC summaries; counsel for application).
- Payment infrastructure compatibility (which legal person PSPs accept for GCash/Maya-heavy flows — **joint task** with [`../payment-provider-research/`](../payment-provider-research/README.md); see **§0.3** above).
- Immigration **timing as input** to corporate sequencing (not visa legal work product).

### Out of scope

- Actual incorporation filings, bank openings, or tax return preparation.
- Replacing immigration or corporate counsel with plan markdown.

## 3) Source Evidence (targets)

- IRS Form 2555 + FEIE rules (current year); how **foreign earned income** and **entity type** interact (advisor).
- US state LLC (and if relevant, corp) formation — registered agent, franchise tax (Wyoming, Delaware, home state as candidates).
- PH: SEC/DTI foreign equity, OPC rules, BIR registration nexus for digital services (primary sources + counsel).
- BI / embassy checklists for **marriage recognition** tied to intended visa route (HitM to obtain current PDFs).
- PSP KYB checklists (Stripe, PayMongo, Xendit — link to payment sub-plan).

## 4) Deliverables

- [RESEARCH_ARTIFACTS.md](./RESEARCH_ARTIFACTS.md) kept current as the one-page index.
- Filled **breakpoint table** and **decision matrices** with dates and evidence pointers.
- Entity comparison table (jurisdiction × vehicle × tax × compliance × PSP).
- HitM final lock rows in [DECISION_MATRIX.md](./DECISION_MATRIX.md).
- Estimated formation + Year 1 ongoing cost per shortlisted path.
- Trigger conditions for revisiting (MRR, PSP change, status change).

## 5) Verification Gates

- HitM has read research output and signed off on **timeline branch + primary entity path**.
- Decision migrated to `01_unit_economics_and_costs.md` §5 with explicit lock.
- `PARKING_LOT.md` P-2 updated if dual-entity timing changes from “deferred” to “active” or vice versa.

## 6) Documentation Sync Required

- Update `01_unit_economics_and_costs.md` §5 with the locked entity choice and jurisdiction.
- Update `PARKING_LOT.md` P-2 when US/PH structure timing is known.

## 7) Strategic Phase Impact

- S1.B exit: entity formation decision check-box (vehicle + timeline evidence + advisor alignment — **pipeline** already locked per §0.2).
- **payment-provider-research:** Hard dependency for **production billing / PSP merchant go-live**; **research and comparison** may continue in parallel per §0.3. **PWA** work does **not** wait on entity tail (§0.4).

## 8) Completion Criteria

- HitM signoff on locks in [DECISION_MATRIX.md](./DECISION_MATRIX.md).
- Documentation sync complete.
- [RESEARCH_ARTIFACTS.md](./RESEARCH_ARTIFACTS.md) reflects **draft vs completed** per artifact section once HitM signs off.

## 9) Risks

| Risk | Trigger | Rollback |
| ---- | ------- | -------- |
| BI timeline is Branch B while product needs B1 revenue ([REGISTRATION_BREAKPOINTS.md](./REGISTRATION_BREAKPOINTS.md)) | PSP KYB requires legal person before immigration clears | Activate US bridge or spouse-led path per matrices |
| Tax advisor disagrees with informal research | Consultation returns different structure | Update matrices; amend lock |
| Entity choice constrains wallets unexpectedly | Payment provider research surfaces friction | Revisit vehicle; log in DECISION_MATRIX |

## Estimated Effort

HitM: counsel/embassy coordination + reading + decision time (front-loaded May–early June per S1.B README).  
Agent: maintain artifacts, compile primary-source links, keep matrices structured (2–6 hours cumulative across sprint).
