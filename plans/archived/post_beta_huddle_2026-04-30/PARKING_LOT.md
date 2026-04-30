# Parking Lot — Deferred Strategic Considerations

Items raised during the huddle that are **substantial enough to need formal consideration** but **not appropriate to decide now**. These are not tangents (those go in `TALKING_POINTS.md` topic notes). These are deferred-decision items that should be revisited under specific trigger conditions.

At Topic 11 close-out, each item gets one of three dispositions:

- **Promoted** — converted into an Execution Plan (typically a Research Plan) under `plans/cursor/<branch>/`.
- **Lifted** — added to the Strategic Plan as a known deferred decision with explicit trigger conditions.
- **Discarded** — explicitly removed from active consideration; reasons documented.

---

## P-1: GCash / Maya partnership exploration

**Raised:** 2026-04-30 by HitM during Topic 4 Q2 discussion.

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

**Cross-references:**

- `00_strategic_context.md` §3.4: GCash/Maya ingestion as free PH feature.
- This parking-lot item: focuses on the *partnership/business-side* relationship, distinct from the *technical ingestion* work.

---

## P-2: US + PH dual-entity structure (HFM US / HFM PH split)

**Raised:** 2026-04-30 by HitM during Topic 4 Q2 discussion.

**Description:** Splitting the business into two sister entities — a US-incorporated LLC/OPC for international business and US-side compliance, and a PH-incorporated entity (likely SEC OPC) for local PHP-denominated business and direct integration with PH payment infrastructure (GCash/Maya/local banks).

**Why deferred:**

- Dual-entity overhead estimated at ~$5,000–$10,000 USD/yr in combined compliance + accounting + filings.
- Current revenue does not justify the overhead (zero paying users at huddle date).
- Single US entity (LLC or OPC) is sufficient to begin S1.B Distribution Readiness work for current scale.
- Premature optimization at the structural level.

**Trigger to revisit:**

- PHP-denominated payment processing friction blocks user acquisition at material volume (e.g. payment processor refuses PH cards, or GCash/Maya integration requires PH merchant of record), OR
- Approaching FEIE cliff per `01_unit_economics_and_costs.md` §5 (~80% of current FEIE), OR
- Partnership requirement (P-1 above) demands a PH legal counterparty, OR
- Owner relocation or tax-residency change affects the US-only assumption.

**Owner:** HitM (entity formation requires direct HitM action; agents cannot be officers/directors).

**Cross-references:**

- `01_unit_economics_and_costs.md` §5: FEIE-trigger entity restructuring (different scenario; that's "good problem to have," this is "structural foundation").
- This parking-lot item: covers the *upfront* split case, distinct from the *eventual* tax-driven restructuring.

---

## P-3: Ads as revenue vector — formally rejected

**Raised:** 2026-04-30 by HitM during Topic 4 Q2 discussion.

**Disposition:** Rejected. Locked.

**Rationale:**

1. Trust erosion in thin-margin persona is severe; PH ad networks lean predatory (loans, gambling, investment schemes).
2. Untargeted ad CPM in PH is too low (~$0.02–$0.10/user/month) to justify wedge cost.
3. ZK position rejects financial-data targeting; without targeting, ads economics don't work.
4. Brand consistency: "we cannot monetize your data" is incompatible with ad-supported tier.

**Migration:** This rejected item gets recorded in `00_strategic_context.md` §4 (Rejected Options) at Topic 11 close-out.

---

## P-4: Curated affiliate / partner revenue model (alternative to ads)

**Raised:** 2026-04-30 by agent during Topic 4 Q2 discussion as constructive alternative to ads.

**Description:** Curated, editorially-vetted affiliate or partnership relationships with select PH financial products that align with the wedge persona. Examples: no-fee OFW remittance services, savings platforms, micro-investment products. Recommended in-app via clear "trusted partner" framing, not auction-based ad serving.

**Why parked:**

- Premature without user volume to negotiate with partners.
- Requires editorial discipline that doesn't exist yet (single human, no time for partnership review cycles).
- Risk of becoming "ads with a different name" if not held to a high editorial bar.

**Trigger to revisit:**

- ≥500 paying PH users (partner negotiation has leverage), OR
- HitM has dedicated capacity to evaluate partner products, OR
- Specific partner inbound (e.g. GCash partnership conversation per P-1).

**Owner:** HitM (partner curation is a brand decision, not delegatable).

**Cross-references:**

- P-1 (GCash/Maya partnership) is a special case of this.
- Potentially affects `01_unit_economics_and_costs.md` §2 pricing tiers if affiliate revenue offsets free-tier cost.

---

## P-5: Sponsored partnership at scale (single-source sponsor model)

**Raised:** 2026-04-30 by agent during Topic 4 Q2 discussion as constructive alternative to ads.

**Description:** When user volume justifies, a single-source sponsorship ("Official Partner" model) is worth more than rotating ads and is brand-additive rather than brand-corroding. Example: "GCash Official Partner" or "BPI Powered" arrangement where one sponsor gets a defined surface in exchange for promotional consideration.

**Why parked:**

- Requires meaningful user volume (likely ≥10k active users) to justify single-sponsor pricing.
- Overlaps with P-1 (a GCash/Maya partnership might naturally take this shape).

**Trigger to revisit:** Roughly aligned with S2 → S3 transition or first inbound partner interest.

---

## P-6: US re-engagement trigger condition

**Raised:** 2026-04-30 by HitM and agent jointly during Topic 4 Q5 discussion.

**Description:** With the PH-first market pivot locked (Q5 Option (f)), US re-engagement is deferred behind a specific trigger condition. The trigger has not been quantitatively defined yet.

**Why deferred:**

- Need PH market reception data (S1.B → S1.C+) to anchor a realistic trigger.
- ZK middleware (S5) timing affects US re-entry feasibility.
- HitM and agent agree: "concept locked, specifics deferred to S1.B → S1.C transition decision point."

**Candidate trigger conditions (to be evaluated at S1.B → S1.C transition):**

- PH MRR ≥ ₱200k/mo sustained for 6 months (business has slack to fund US-market expansion).
- ZK middleware shipped + audited (S5 exit) — differentiation that gives a US story.
- Specific inbound demand (US Reddit/HN signups despite no marketing).
- Strategic partnership inbound (US bank or fintech wants to white-label).

**Decision required at trigger:**

- Exact Phase label for US re-engagement (S5.A vs separate Phase like SU vs workstream).
- US-specific marketing motion shape (independent of PH).
- AI tier opening to US users with USD-equivalent pricing.

**Owner:** HitM (strategic call; agents draft scenarios but don't decide).

**Cross-references:**

- `00_strategic_context.md` (will gain PH-first priority region statement).
- `phases/S5_*.md` (will gain placeholder for US-launch alignment).
- Q5 in `TOPIC_4_QUESTIONS.md` (deferred Phase label and trigger).

---

## Update protocol

- New parking-lot items are added during huddles with a clear `Raised:` date.
- Items are reviewed at every Phase transition (S1 → S2, etc.) — at minimum to confirm trigger conditions still make sense.
- Items that have triggered get promoted to an Execution Plan within 30 days of trigger detection.
- Items that haven't triggered after 18 months get a "still relevant?" review.
