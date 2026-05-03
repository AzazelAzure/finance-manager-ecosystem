# Parking Lot — Deferred Strategic Considerations

Items raised during planning that are **substantial enough to need formal consideration** but **not appropriate to decide now**. Reviewed at every Phase transition (S1 → S2, etc.) at minimum.

Each item has one of three eventual dispositions:

- **Promoted** — converted into an Execution Plan (typically a Research Plan).
- **Lifted** — added to the Strategic Plan as a known deferred decision with explicit trigger conditions.
- **Discarded** — explicitly removed from active consideration; reasons documented.

---

## P-1: GCash / Maya partnership exploration

**Raised:** 2026-04-30 by HitM during huddle Topic 4 Q2 discussion.

**Description:** Direct partnership/affiliate relationship with GCash and/or Maya as a revenue vector and product-integration multiplier. Could range from co-marketing to API access to revenue-share affiliate.

**Why deferred:**

- Currently below GCash/Maya partnership radar (no demonstrated user volume).
- Realistic short-term integration story is "read SMS on-device with user permission," not "API partnership."
- Partnership negotiation would require a PH-incorporated entity (see P-2).

**Trigger to revisit:**

- ≥1,000 paying PH users sustained for ≥3 months, OR
- Inbound interest from GCash/Maya partnership team, OR
- Competitive landscape shift (e.g. one wallet announces a PFM partnership program).

**Owner:** HitM (relationship work cannot be agent-delegated).

---

## P-2: US + PH dual-entity structure (HFM US / HFM PH split)

**Raised:** 2026-04-30 by HitM during huddle Topic 4 Q2 discussion.

**Description:** Splitting the business into two sister entities — a US-incorporated LLC/OPC for international business and US-side compliance, and a PH-incorporated entity (likely SEC OPC) for local PHP-denominated business and direct integration with PH payment infrastructure.

**Why deferred:**

- Dual-entity overhead estimated at ~$5,000–$10,000 USD/yr in combined compliance + accounting + filings.
- Current revenue does not justify the overhead.
- Single US entity (LLC or OPC) is sufficient to begin S1.B Distribution Readiness work for current scale.

**Trigger to revisit:**

- PHP-denominated payment processing friction blocks user acquisition at material volume, OR
- Approaching FEIE cliff per `01_unit_economics_and_costs.md` §5 (~80% of FEIE), OR
- Partnership requirement (P-1 above) demands a PH legal counterparty, OR
- Owner relocation or tax-residency change affects the US-only assumption.

**Owner:** HitM (entity formation requires direct HitM action).

---

## P-3: Ads as revenue vector — formally rejected

**Raised:** 2026-04-30 by HitM during huddle Topic 4 Q2 discussion.

**Disposition:** **Rejected. Locked.** Recorded in `00_strategic_context.md` §4 (Rejected Options).

**Rationale:**

1. Trust erosion in thin-margin persona is severe; PH ad networks lean predatory.
2. Untargeted ad CPM in PH is too low (~$0.02–$0.10/user/month).
3. ZK position rejects financial-data targeting; without targeting, ads economics don't work.
4. Brand consistency: "we cannot monetize your data" is incompatible with ad-supported tier.

---

## P-4: Curated affiliate / partner revenue model (alternative to ads)

**Raised:** 2026-04-30 by agent during huddle Topic 4 Q2 discussion.

**Description:** Curated, editorially-vetted affiliate or partnership relationships with select PH financial products that align with the wedge persona. Recommended in-app via clear "trusted partner" framing, not auction-based ad serving.

**Why parked:**

- Premature without user volume to negotiate with partners.
- Requires editorial discipline that doesn't exist yet.
- Risk of becoming "ads with a different name" if not held to a high editorial bar.

**Trigger to revisit:**

- ≥500 paying PH users, OR
- HitM has dedicated capacity to evaluate partner products, OR
- Specific partner inbound (e.g. GCash partnership conversation per P-1).

**Owner:** HitM (partner curation is a brand decision).

---

## P-5: Sponsored partnership at scale (single-source sponsor model)

**Raised:** 2026-04-30 by agent during huddle Topic 4 Q2 discussion.

**Description:** When user volume justifies, a single-source sponsorship ("Official Partner" model) is worth more than rotating ads and is brand-additive. Example: "GCash Official Partner" or "BPI Powered" arrangement.

**Why parked:**

- Requires meaningful user volume (likely ≥10k active users).
- Overlaps with P-1 (a GCash/Maya partnership might naturally take this shape).

**Trigger to revisit:** Roughly aligned with S2 → S3 transition or first inbound partner interest.

---

## P-6: US re-engagement trigger condition

**Raised:** 2026-04-30 by HitM and agent jointly during huddle Topic 4 Q5 discussion.

**Description:** With the PH-first market pivot locked, US re-engagement is deferred behind a specific trigger condition. Trigger not yet quantitatively defined.

**Why deferred:**

- Need PH market reception data (S1.B → S1.C+) to anchor a realistic trigger.
- ZK middleware (S5) timing affects US re-entry feasibility.

**Candidate trigger conditions (evaluate at S1.B → S1.C transition):**

- PH MRR ≥ ₱200k/mo sustained for 6 months, OR
- ZK middleware shipped + audited (S5 exit) — differentiation gives a US story, OR
- Specific inbound demand (US Reddit/HN signups despite no marketing), OR
- Strategic partnership inbound.

**Decision required at trigger:**

- Exact Phase label for US re-engagement (S5.A vs separate Phase like SU vs workstream).
- US-specific marketing motion shape.
- AI tier opening to US users with USD-equivalent pricing.

**Owner:** HitM.

---

## P-7: AI video story content format alignment

**Raised:** 2026-04-30 by HitM during huddle Topic 7 Q7.4 discussion.

**Description:** Use of AI-generated video stories (via HitM's personal Gemini Pro asset) as a PH content vector — leveraging cultural preference for AI-drama formats. Three potential framings, none locked:

1. Story directly integrates product use (high craft, high attribution clarity).
2. AI video used for founder/trust content, not conversion (lower expectations, lower craft).
3. Skip AI video entirely; stick to educational text/post content with clearer attribution.

**Why parked:**

- HitM skeptical about loosely-coupled AI-video-to-product attribution.
- Format strategy depends on broader marketing approach (S1.B marketing research workstream).

**Trigger to revisit:** During S1.B marketing research workstream; or earlier if HitM has bandwidth to explore one of the three framings as a one-off test.

**Owner:** HitM (creative direction).

---

## P-8: Pro free trial + wallet / PSP verification behavior

**Raised:** 2026-05-01 by HitM (pricing and growth mechanics; depends on S1.B feature roadmap).

**Description:** Evaluate offering a **first-month-free Pro trial** (or similar) with **payment instrument saved up front**, clear **pre-billing cancellation** rights, and **automatic renewal** thereafter—industry-standard pattern. Parallel research: how **PH e-wallet flows** through aggregators (e.g. PayMongo-class) support **trial authorization**, **verification that a wallet can pay**, versus **attempt first charge at period end** and **downgrade on failure**.

**Why deferred:**

- **Feature-level free vs paid split** must be decided after the **S1.B feature roadmap** is solid; trial value prop only makes sense once “what Pro gives you” is stable (`01_unit_economics_and_costs.md` §2 deferred block).
- Abuse, churn-from-downgrade, and support burden trade-offs need a concrete **entitlement matrix**, not pricing in isolation.
- PSP-specific behavior is an output of **payment provider research**, not a guess.

**Trigger to revisit:**

- S1.B **Group D** feature scope is stable enough to lock entitlements per tier, **and**
- Payment provider shortlist / integration approach is known (same window as `payment-provider-research` closing).

**Owner:** HitM (product + legal copy); payment research informs technical options.

---

## Update protocol

- New parking-lot items are added with a clear `Raised:` date.
- Items are reviewed at every Phase transition (S1 → S2, etc.) at minimum.
- Items that have triggered get promoted to an Execution Plan within 30 days of trigger detection.
- Items that haven't triggered after 18 months get a "still relevant?" review (Discarded if not).
