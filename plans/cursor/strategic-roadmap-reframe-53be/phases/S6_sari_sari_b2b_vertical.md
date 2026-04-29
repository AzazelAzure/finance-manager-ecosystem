# Phase S6: Sari-Sari B2B Vertical (Conditional)

## Status

**Conditional.** Entry gated by `kill_commit_gates.md` §5. Defer or abandon is an explicit option.

## Objective

Convert the trust + technical infrastructure built across S1–S5 into a **B2B SaaS for Filipino sari-sari store operators**. The product handles inventory, customer tabs ("utang"), simple POS, and (long-term aspiration) automated supplier resupply.

This is a **separate product** that **reuses the PFM data layer + encryption**, not a feature of the PFM. Distribution motion is fundamentally different (B2B local feet-on-the-ground, not B2C online).

## Entry Criteria (all required)

- S5 exit met OR S5 explicitly abandoned via documented decision in `kill_commit_gates.md`.
- PFM ≥$1k MRR sustained for ≥6 months.
- ≥3 sari-sari operators in owner's personal network expressed unprompted interest.

## Exit Criteria (all required)

- ≥10 paying sari-sari operators.
- Supplier-integration prototype operational (even behind feature flag).
- B2B churn <10%/quarter.

## Workstreams

### 1. Discovery (P0, Pre-Code Mandatory)

- [ ] Owner interviews ≥10 sari-sari operators **before any code is written**. Personal network plus near-network referrals.
- [ ] Document existing pain points: inventory visibility, customer tabs, supplier ordering, cash management, end-of-day reconciliation.
- [ ] Document existing tools: pen and paper, notebook, mental, family-shared spreadsheet?
- [ ] Document willingness to pay: ₱500/mo? ₱1,000/mo? Free? Ask in pesos, not in hypotheticals.
- [ ] Document device/connectivity reality: Android model used, data plan, backup power for storefront, internet during business hours.

### 2. MVP Scoping (P0, Post-Discovery)

Based on discovery, MVP is **at most** 3 of these (not all):

- Inventory tracker (additions, sales, current count, low-stock alerts).
- Customer tab management (utang ledger; payment tracking).
- Simple POS (add items, calculate change, end-of-day total).
- Supplier order builder (low-stock items → draft order list).
- Cash reconciliation (start-of-day vs end-of-day cash count).

**MVP is for the operator herself, not for IT-savvy users.** UI in Filipino. Big buttons. Numbers, not graphs.

### 3. Implementation (P0)

- [ ] Reuse PFM data layer where it makes sense (auth, encryption-at-rest, sync infra).
- [ ] Reuse Android offline-first architecture (operator may have no internet during half the day).
- [ ] Reuse `django-zk` if S5 was completed (sari-sari customer tab data is sensitive: who owes what to whom).
- [ ] **Separate database / namespace.** Do not commingle PFM personal data with sari-sari B2B data.
- [ ] Multi-tenant architecture: one operator = one shop instance, with multi-staff support if discovery shows demand.
- [ ] AI agents implement; owner reviews architecture and money math.

### 4. Local Distribution (P0)

- [ ] First 5 paying customers come from owner's personal network (not online).
- [ ] Onboarding is **in-person or video-call**, not self-serve. The first cohort gets owner-led setup.
- [ ] Print collateral: simple Filipino-language flyer for "barangay" community boards.
- [ ] Word-of-mouth referral incentive: 1 month free for each operator referred who signs up.
- [ ] Avoid Facebook ads. Avoid Google. The audience is local, in-person, trust-based.

### 5. Pricing (P0)

- [ ] Anchored to discovery findings.
- [ ] Likely range: ₱299–₱599/mo per shop. Possibly ₱1,000+ if supplier-integration is included.
- [ ] Annual discount available; cash payment via GCash transfer is acceptable (do not force credit cards).
- [ ] Free trial: 30 days, no credit card required. Operator must affirmatively decide to pay; this filters for real intent.

### 6. Supplier Integration (P1, Aspirational)

- [ ] Identify 1–2 willing supplier partners in owner's network.
- [ ] Prototype: shop X needs items A, B, C → message dispatched to supplier → supplier driver dispatched.
- [ ] This is **not** an MVP feature. It is a P1 stretch goal that demonstrates the long-term vision and is the genuine moat.
- [ ] If discovery shows operators do not want supplier integration ("I prefer choosing my supplier each time"), drop it. Listen to operators, not the pie-in-the-sky framing.

### 7. PFM Continuity (P0, Always)

- [ ] PFM revenue is still the primary KPI.
- [ ] Sari-Sari is a parallel business, not a successor.
- [ ] Brand: distinct enough that PFM users don't get confused; but trust-linked enough that "made by the PFM person" is a reason to consider.
- [ ] Possible separate brand name; possible "by [PFM-Brand]" sub-brand. Decide during workstream 1.

### 8. Documentation Sync (P1, at exit)

- [ ] Create `design_docs/sari_sari_docs/` or equivalent.
- [ ] Update `01_Business_Vision.md` to reflect dual-product reality.
- [ ] Update `00_strategic_context.md` with what was learned during discovery.

## Constraints

- **No code before discovery.** This is non-negotiable. Discovery must produce a written interview log ≥10 operators.
- **First cohort is owner-led onboarding.** No self-serve until ≥10 paying customers exist.
- **PFM is not allowed to regress.** Same rule as S5. PFM is the trust source; if it falters, sari-sari adoption falters.
- **Supplier integration is post-MVP.** Resist the temptation to build the cool part first.
- **Filipino-language UI is mandatory.** English-only sari-sari product is a non-starter.

## Risks and Mitigations

| Risk | Mitigation |
|---|---|
| Operators love the demo but won't pay | Free trial requires affirmative decision to convert; if conversion is low, reposition or abandon. |
| Sari-Sari distribution requires owner's full attention | This is by design in S6; PFM operations move to maintenance mode. Pre-budget the focus split. |
| Operators prefer pen/paper "because it works" | Honor that. Discover the *specific* friction that breaks pen/paper for them (lost notebooks, sibling disputes, theft). Build for that, not for "general digitization." |
| Supplier partnerships fall through | Drop the workstream; ship MVP without it; revisit later. |
| PFM users get confused by parallel product | Clear brand separation; cross-link only where it adds value (e.g. "do you also run a sari-sari? check out [product]"). |
| Owner over-extends across two businesses | Quarterly self-review per `kill_commit_gates.md` §6. |

## Verification Gate

Per `validation_gates.md` Phase S6 exit triggers.

## Definition of Done for Phase S6

- All exit triggers met.
- Sari-Sari has its own paying customers and its own retention story.
- PFM is intact and continues its own trajectory.
- Owner has demonstrated ability to operate two products without one starving the other (or has explicitly decided to focus on one and unwound the other).
