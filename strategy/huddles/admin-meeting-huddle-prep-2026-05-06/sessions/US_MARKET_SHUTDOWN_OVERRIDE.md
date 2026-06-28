# Strategic Override: US Market Shutdown

**Date:** 2026-05-07  
**Decision by:** HitM  
**Scope:** Cross-session, cross-huddle, cross-roadmap  
**Status:** `LOCKED`

---

## The Decision

> **Complete shutdown of US operations and use cases. No building for, no accommodating the US market. US beta testers are not testing — not worth the time and money when real PH testers are lined up.**

---

## Rationale

- US beta testers have not found time to actively test the product
- Real PH testers are lined up and ready to engage
- Every hour spent accommodating the US market is an hour not spent on the market that matters
- The cost and complexity of maintaining a dual-market posture (even "passive") is not justified by zero US engagement

---

## What this changes (impact trace)

### 1. Entity Formation (Session 1 decisions affected)

| Before | After |
|--------|-------|
| PH entity (DTI sole prop) + US LLC formation | **PH entity only.** US LLC is not needed. |
| US LLC formed Dec 2026–Jan 2027 | **Eliminated from timeline** |
| Intercompany agreement between PH and US entities | **Eliminated** — no second entity |
| "Separate US tax advisor for FEIE/LLC" | **Not needed** — no US income to declare via LLC |
| Cross-border cash flow topology (Session 1 parking lot) | **Eliminated** — no cross-border B2B flow |
| S1-D07 PH counsel "not suited for US tax/LLC" | **Only PH counsel needed.** US counsel requirement drops entirely. |

**Affected decisions:** S1-D04 (entity vehicle — simplifies), S1-D07 (counsel — US counsel no longer needed)

**Affected parking lot items:** 
- "US LLC formation timing" → **KILLED**
- "Intercompany agreement" → **KILLED**  
- "Cross-border cash flow & tax topology" → **KILLED**

### 2. Entity Timeline (TP18 — simplifies dramatically)

**Before (6-step cascade):**
```
Huddle → Baby → Budget → PH Counsel → PH Entity → US LLC → Intercompany → PSP → Revenue
```

**After (4-step cascade):**
```
Huddle → Baby → Budget → PH Counsel → PH Entity → PSP → Revenue
```

**Impact:** Cuts ~2–3 months from the entity timeline. The "cross-border cash flow mapped" and "intercompany agreement drafted" steps (Jan–Feb 2027) are eliminated. First revenue could be **1–2 months earlier** (late 2026 vs Q1 2027).

### 3. Strategic Roadmap (PARKING_LOT.md)

| Item | Before | After |
|------|--------|-------|
| **P-2 (US+PH dual-entity)** | Deferred with trigger | **KILLED** — no US entity planned |
| **P-6 (US re-engagement trigger)** | Deferred to S1.B→S1.C | **KILLED** — no US re-engagement |
| P-1 (GCash/Maya partnership) | Deferred | **Unchanged** — PH only, still relevant |
| P-4 (curated affiliate) | Deferred | **Unchanged** — PH only |
| P-5 (sponsored partnership) | Deferred | **Unchanged** — PH only |
| P-8 (Pro trial + PSP) | Deferred | **Unchanged** — simplifies since PH-only PSP |

### 4. `00_strategic_context.md` (locked decisions)

**Must update:**
- Remove "US presence continues passively — webapp accessible globally, existing testers grandfathered as Honorary Founders"
- Remove "Asymmetric pricing for US users: continued free Pro tier (Honorary Founders)"
- Change to: "US market completely shut down. No US-targeted features, no US accommodations."

### 5. `01_unit_economics_and_costs.md`

**Must update:**
- Remove "Honorary Founder (US grandfathered)" row from pricing table ($0 tier)
- Remove "US LLC supports US-facing revenue when roadmap gates allow" 
- Remove any dual-entity cost estimates
- Simplify entity cost section to PH-only

### 6. `AGENTS.md` (workspace rules)

**Must update:**
- Change "Active market: PH only; HitM is the sole human operator. US users are grandfathered as Honorary Founders. New US acquisition deferred behind P-6" 
- To: "Active market: PH only. US operations completely shut down. No US accommodations."

### 7. `validation_gates.md`

**Must update:**
- Remove "Active market: PH-only primary; US passive (Honorary Founders only)"
- Change to: "Active market: PH only. US shut down."

### 8. Product Impact

| Area | Before | After |
|------|--------|-------|
| **Currency support** | PHP + USD (for US users) | **PHP only** (can add other currencies later for PH expats/OFW) |
| **i18n scope** | English (US+PH) + Filipino/Tagalog | **English (PH) + Filipino/Tagalog** — no US English differences |
| **ToS/Privacy** | Needed for both US and PH jurisdictions | **PH jurisdiction only** — simpler |
| **PSP** | PayMongo (PH) + potential Stripe (US) | **PayMongo only** |
| **Tax compliance** | PH + US FEIE + intercompany transfer pricing | **PH tax only** |
| **Beta testers** | 2 pools (US inactive, PH active) | **PH pool only** |
| **Founding member program** | PH Paying Founders + US Honorary Founders | **PH Paying Founders only** |

### 9. Cost Impact

| Cost item eliminated | Est. savings |
|---------------------|-------------|
| US LLC formation | ~$500–1,000 one-time |
| US LLC annual maintenance | ~$200–500/yr |
| US tax advisor/counsel | ~$500–2,000/yr |
| Intercompany agreement drafting | ~$1,000–3,000 one-time |
| Stripe/US PSP integration work | Engineering hours |
| US regulatory compliance research | Time |
| **Total estimated savings** | **~$2,000–5,000 first year + engineering time** |

### 10. Timeline Impact

The entity formation timeline shortens by **2–3 months** because:
- No US LLC step
- No intercompany agreement step
- No cross-border cash flow mapping
- No US counsel engagement needed
- PH entity → PSP is a direct path with no US dependency

**Revised earliest dates:**

| Milestone | Before | After |
|-----------|--------|-------|
| PH entity registered | Nov–Dec 2026 | Nov–Dec 2026 (unchanged) |
| US LLC formed | Dec 2026–Jan 2027 | **ELIMINATED** |
| Intercompany agreement | Jan–Feb 2027 | **ELIMINATED** |
| PSP merchant KYB | Feb–Mar 2027 | **Nov–Dec 2026** (can start immediately after PH entity) |
| First paid revenue | ~Q1 2027 | **~Dec 2026–Jan 2027** (1–2 months earlier) |

---

## Existing US beta tester accounts — DECIDED

**Decision:** **Option A** (accounts stay active, no special treatment). **Option B** (deactivation) held as future option.

**Rationale:** Realistic operational time for beta testing is ~2 min to onboard and ~2 min/day to track transactions. If family and closest friends cannot find that time between beta opening and now, asking complete strangers to onboard in the US market is wasted effort. The accounts can stay — there's no engineering cost to leaving them — but no accommodations, no honorary status, no US-specific anything.

---

## NEW CONSTRAINT: Anti-Dummy, Income Flow, and Marriage Gates

> [!WARNING]
> **The US shutdown eliminates cross-border B2B complexity but surfaces a different problem:** how does HitM (US citizen, not yet legally settled in PH) receive income from a PH-only entity?

### The Anti-Dummy Problem

**Republic Act No. 108 (Anti-Dummy Act)** restricts foreign nationals from intervening in the management, operation, administration, or control of activities reserved to Filipino citizens or corporations. Key concern:

| Factor | HitM's situation |
|--------|-----------------|
| **Who builds the product?** | HitM (US citizen) |
| **Who operates the business?** | HitM (US citizen), with spouse as entity owner |
| **Entity structure** | PH entity, spouse-led (per S1-D04, locked) |
| **Anti-Dummy risk** | If HitM is the *de facto* operator/controller of a PH business owned by spouse, this could constitute a dummy arrangement |

**This is exactly why PH counsel is critical.** The distinction between:
- HitM as a **foreign contractor/vendor** providing services to a PH entity (likely legal with proper structure)
- HitM as the **actual controller** of a PH entity using spouse as a front (potentially Anti-Dummy violation)

...is a legal question that only counsel can resolve.

### Income Flow: How Does HitM Get Paid?

With no US LLC, the income path changes:

| Before (dual-entity) | After (PH-only) |
|----------------------|-----------------|
| PH entity → service fee → US LLC → HitM salary | PH entity → ??? → HitM |

**Options (all require counsel confirmation):**

| Path | How it works | Concerns |
|------|-------------|----------|
| **A — Foreign contractor** | HitM contracts with PH entity as foreign service provider. Entity pays HitM directly for "software development services." | Needs proper contractor agreement. Withholding tax (PH-side) on payments to non-resident. HitM must declare as self-employment income for US taxes (FEIE potentially applies if HitM qualifies). |
| **B — Spousal income sharing** | Entity pays spouse as owner. Spouse shares household income with HitM. | Informal; no clean paper trail. May not satisfy US tax reporting. Not professional. |
| **C — Employment via PEZA or special visa** | HitM employed by PH entity under special economic zone or work permit. | Requires legal residency/work authorization. Complex. Likely not viable until marriage + visa sorted. |
| **D — Defer income entirely** | Entity accumulates revenue. HitM doesn't draw income until legal structure is sorted. | Clean but means HitM works unpaid for potentially months/years. |

**Realistic near-term path:** Likely **Option D** (defer income) until marriage + visa + counsel sort the proper structure. Then transition to **Option A** (foreign contractor) or **Option C** (employment) based on counsel recommendation.

### Marriage Gates

| Gate | Status | Impact on entity |
|------|--------|-----------------|
| **Legal marriage** | Pending (HitM not yet legally settled in PH) | Affects spousal property rights, entity ownership structure, visa eligibility |
| **Visa / legal residency** | Pending | Affects ability to be employed by PH entity, tax residency status |
| **Work authorization** | Pending | Affects ability to legally perform work for a PH entity |
| **Tax residency determination** | Pending | US citizen abroad — FEIE eligibility depends on physical presence test or bona fide residence test |

### Entity Formation Timeline — Further Revised

> [!IMPORTANT]
> **Entity creation may need to be postponed beyond what TP18 projected** due to Anti-Dummy compliance requirements and marriage/legal status gates. A holding pattern until HitM's legal status in PH is resolved is a realistic possibility.

**Previous revised cascade (post-US shutdown):**
```
Huddle → Baby → Budget → PH Counsel → PH Entity → PSP → Revenue
```

**Potentially further revised cascade:**
```
Huddle → Baby → Budget → Marriage → Visa/Residency → PH Counsel → 
  Anti-Dummy compliant structure designed → PH Entity → PSP → Revenue
```

**Key unknown:** Can the PH entity be registered (spouse-led) *before* marriage/visa, with HitM structured as a foreign contractor? Or must marriage/visa be resolved first to design a compliant structure?

**This is the #1 question for PH counsel** when counsel is formally engaged.

### Impact on Timeline Estimates

| Milestone | Post-US-shutdown estimate | With marriage/Anti-Dummy gate |
|-----------|--------------------------|-------------------------------|
| PH entity registered | Nov–Dec 2026 | **TBD — depends on marriage/visa timeline** |
| PSP merchant KYB | Nov–Dec 2026 | **Cascades from entity** |
| First paid revenue | Dec 2026–Jan 2027 | **Could slip to mid-2027 if holding pattern** |

### What can still proceed regardless

| Workstream | Blocked by marriage/Anti-Dummy? |
|-----------|-------------------------------|
| Product development | **No** — HitM builds on personal equipment, personal time |
| Beta testing (PH testers) | **No** — free product, no revenue |
| PWA / offline features | **No** |
| Automation hardening | **No** |
| PH counsel warm contact | **No** — can discuss informally |
| Entity *registration* | **Possibly** — counsel must advise |
| Collecting revenue | **Yes** — no entity = no PSP = no revenue |
| HitM drawing income | **Yes** — no legal income path until structure resolved |

---

## Files that need updating (post-huddle)

| File | What changes |
|------|-------------|
| `AGENTS.md` | Remove Honorary Founders, change "US deferred" to "US shut down" |
| `strategy/strategic-roadmap-reframe-53be/00_strategic_context.md` | Remove US passive presence language |
| `strategy/strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md` | Remove Honorary Founder tier, remove US LLC costs, simplify entity section |
| `strategy/strategic-roadmap-reframe-53be/PARKING_LOT.md` | Kill P-2 and P-6; update P-8 to PH-only PSP |
| `strategy/strategic-roadmap-reframe-53be/validation_gates.md` | Remove US passive market reference |
| `strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md` | Remove US Honorary Founders from outreach, change market scope |
| `strategy/huddles/2026-04-30-post-beta/DECISIONS.md` | Add override annotation referencing this decision |
| Session 1 parking lot items | Kill US LLC, intercompany, cross-border items |
| TP18 entity timelines | Simplify cascade but add marriage/Anti-Dummy gate |
| `plans/S1/S1.B/entity-formation-research/` | Remove US LLC research; add Anti-Dummy compliance research |

