# Topic 4 — Phase Definition Overhaul: Quick Reference

Purpose: scrollable single-page reference for the six load-bearing questions on Topic 4. Answers go directly in this file as we work through them, then migrate to `DECISIONS.md` when locked.

**Read first:** `GLOSSARY.md` for canonical vocabulary. All questions below use canonical terms.

---

## Note on question dependencies

Q1 (canonical model lock) depends partially on Q2–Q6 outcomes. If we substantially restructure S1–S6 in Q2–Q6, the answer to Q1 becomes "the Strategic Plan structure is canonical, but its specific content gets rewritten." If Q2–Q6 are minor adjustments, Q1 is "yes, lock as-is."

Recommended order: Q2 → Q3 → Q4 → Q5 → Q6 → Q1 (Q1 last as a summary lock).

---

## Q1 — Canonical model lock

**Question:** Is the Strategic Plan (`strategy/strategic-roadmap-reframe-53be/`) the canonical multi-year structure going forward, with old `Phase 1` / `Phase 2` docs in `design_docs/20_Roadmap/` becoming historical reference only?

**HitM context (2026-04-30):** "This depends. We will need to likely need to restructure this entirely."

**Decision options:**

- (a) Yes — Strategic Plan structure (S1–S6 + Stages + Sprints) is canonical; content gets revised based on Q2–Q6 outcomes.
- (b) No — restructure into a different shape entirely. (If chosen, Q2 becomes "what's the new structure?")
- (c) Partial — keep S1–S6 structure but rename Phases or restructure Phase contents substantially.

**Decision (2026-04-30):** **Option (a) — locked.** Strategic Plan structure (S1–S6) is canonical; old `Phase 1`/`Phase 2` docs become historical reference only.

**Substantial content revision queued for Topic 11 close-out:**


| Phase | Revision required                                                                                                                                                                     |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| S1    | Add 4-Stage breakdown (A/B/C/D); re-scope content per PH-first + research-heavy S1.B + AI tier S1.C + multi-event launch                                                              |
| S2    | Re-scope from "PH Vertical Hardening (retention-gated)" to "PH Public Launch + scaling"; remove JS pivot pillar (already done); acknowledge AI tier already in production by S2 entry |
| S3    | Re-scope from "Mobile Offline-First (initial build)" to "Android scaling and feature parity"; document Android pull-forward begins in S1.B                                            |
| S4    | Reaffirmed; minor — note dev-channel reputation feeds US re-engagement alignment in S5                                                                                                |
| S5    | Elevate from "magnum opus / clout" to "structural revenue defense"; document US re-engagement alignment (exact label deferred per P-6)                                                |
| S6    | Reaffirmed; minor — note PH-first market focus reinforces Sari-Sari B2B as PH-only product                                                                                            |


**New locks for `00_strategic_context.md` §3 (locked decisions):**

- PH-first market focus (US passive; trigger-deferred per P-6)
- Mobile wallet payment as hard constraint (GCash/Maya primary, not fallback)
- Ads rejected as revenue vector
- ZK middleware (S5) as structural revenue defense
- "Lifetime access to all future features" requires careful definition (deep-dive in S1.B)
- HitM overwork pattern as structural input to Topic 8 mechanisms

**New entries for `00_strategic_context.md` §4 (rejected/deferred):**

- Ads — formally rejected
- Desktop standalone — registered as `desktop:Concept` future stream (no scheduled work)
- US re-engagement Phase placement + trigger — deferred to S1.B → S1.C transition

**HitM signoff:** yes (2026-04-30)

---

## Q2 — S1 Stage split

**Question:** Does Phase S1 split into the four Stages I proposed?


| Stage | Name                   | What it covers                                                                            |
| ----- | ---------------------- | ----------------------------------------------------------------------------------------- |
| S1.A  | Tight Invite Beta      | Owner + small invite cohort; current state                                                |
| S1.B  | Distribution Readiness | S0 fixes, billing infra, ToS, refund policy, founding-member program, landing/hero polish |
| S1.C  | Founding Beta          | Founding-member tier open; first 50–100 paying lifetime seats                             |
| S1.D  | Soft Public Open       | Anyone can sign up; pricing visible; low-key promotion only                               |


**Alternatives:**

- (a) The four-stage split as above.
- (b) Two stages only: "Beta" (covers S1.A + S1.B + S1.C) and "Launch" (S1.D).
- (c) Promote each stage to its own Phase (so we'd have S1, S2-formerly-S1.B, S3-formerly-S1.C, etc., shifting all downstream Phase numbers by 3).
- (d) Different cut entirely — describe.

**Decision (2026-04-30):** **Option (a) — locked**, with the following caveats and additions:

1. **Current state:** end of S1.A → entering S1.B.
2. **S1.B is research-heavy:** internal sub-Sprints needed for entity structure (US LLC vs OPC), payment provider selection (Stripe vs PayMongo vs Xendit vs hybrid), GCash/Maya integration legality for US-incorporated business. Research is *the work*, not a prerequisite to it.
3. **Mobile wallet integration is a hard constraint:** "forcing PH users to have a credit card is a financial death sentence." S1.B billing infra must support direct GCash/Maya as a primary payment method, not a fallback. Locked.
4. **Ads rejected as revenue vector** (see `PARKING_LOT.md` P-3). Locked.
5. **ZK model preserved** as primary user-data posture; user-data monetization rejected. S5 elevated from "magnum opus / clout" to "structural revenue defense." Locked.
6. **Android product stream pulls forward:** `android:Scaffold → android:Alpha` during S1.B; `android:Tight Beta` during S1.C. S3 gets re-scoped from "Android initial build" to "Android scaling and feature parity." Affects Q6 calendar.
7. **Long-term considerations** (deferred to `PARKING_LOT.md`):
  - P-1: GCash/Maya partnership exploration
  - P-2: US + PH dual-entity structure (HFM US / HFM PH split)
  - P-4: Curated affiliate/partner revenue model
  - P-5: Sponsored partnership at scale

---

## Q3 — Desktop product stream (was Track E)

**Question:** Original Track E was "Desktop standalone version" — single-binary bundle for Linux/Windows/Mac with local SQLite. Per the canonical per-product launch-state model, this would become a `desktop` product stream with its own state progression. What's its status?

**Options:**

- (a) Add as `desktop:Concept`. Tracked as a future product stream, no scheduled work, no Phase commitment. Roadmap mentions exist for awareness only.
- (b) Defer entirely. Drop from current roadmap; revisit at S5 or later. No mention in active docs.
- (c) Drop permanently. Not in roadmap. If anyone asks, "not happening." Out of scope forever.
- (d) Promote to active. Schedule into a specific Phase (which one?).

**Decision (2026-04-30):** **Option (a) — locked.** Desktop product stream registered as `desktop:Concept`. Strong consideration for later, not executable now. Trigger to revisit: TBD; likely at S5 or later, or if a specific user demand emerges.

---

## Q4 — AI tier timing

**Question:** Pro+ AI tier (per `01_unit_economics_and_costs.md` §2: monthly subscription with AI credits + PAYG top-ups) — when does it ship?

**Options:**

- (a) **Stays in S2** as originally planned. Founding Beta members get the same dashboard / safe-to-spend / manual-entry experience as Tight Beta testers; AI features arrive when paying-user volume justifies the per-user cost cap infrastructure.
- (b) **Pulls forward to S1.C** (Founding Beta entry). Founding members get AI from day 1. Implication: Founding Beta lifetime seats include AI credits, which means we're pre-paying inference costs against future revenue.
- (c) **Pulls forward to S1.D** (Soft Public Open entry). Free tier still has 10-prompt taster; Pro tier with AI launches alongside public signup.
- (d) **Slips later than S2.** AI infrastructure built but not user-facing until S3 or later.

**Constraint to consider:** AI cost cap model assumes paying-user revenue offsets free-tier inference cost. Pull-forward without paid users → free-tier subsidy comes from owner pocket.

**Decision (2026-04-30):** **Option (b) — tentative** — AI ships at `S1.C` (Founding Beta entry).

**HitM framing of Founding Beta tier:** "Lifetime access to all future features" with AI features specifically gated and potentially tiered for founders (with discounts on credit packs).

**Pushback flagged for resolution:**

- "Lifetime access to all future features" is more generous than typical lifetime deals; risks include undervalued future product streams (desktop, Android Pro, etc.), future pricing tier reshuffles, and unbounded AI inference cost commitment. Industry-standard alternative: "lifetime Pro tier + lifetime access to Pro+ AI features with consumption at 50%-off PAYG rate; new product streams negotiated at launch." HitM to consider before locking final founder marketing copy.

**Required S1.B workstream — AI Economics Deep-Dive:**

The 16 interlocking decisions below must be resolved in S1.B before S1.C opens. Captured here as a defined sub-Sprint within S1.B; outcome may revise this Q4 answer.

*Cost questions:*

1. LLM provider + model selection per tier (Haiku/Sonnet/Opus class or equivalent).
2. Per-prompt cost estimates per tier's typical workload.
3. Caching effectiveness ceiling.

*Pricing questions:*

1. Pro+ AI monthly price (₱349 current model holds, or revise?).
2. Founder credit-pack discount structure.
3. Free tier prompt limit (10/month holds?).
4. Hard cap before throttle for non-founders.

*Profitability bounds:*

1. Minimum margin per Pro+ AI sub.
2. Free tier subsidy ceiling validation.
3. Founder cumulative inference cost commitment math (e.g. 100 founders × $2/mo × 24 months ≈ $4,800).

*UX questions:*

1. Cap-hit behavior (throttle / blocked / upsell).
2. Credits-remaining visibility.
3. Reset cadence (calendar / rolling / anniversary).

*Founder-specific:*

1. "Lifetime access" precise definition (per pushback above).
2. Founder credit-pack gating (manual purchase or auto-allocation).
3. Founder monthly allocation exhaustion behavior.

**HitM signoff:** tentative yes; final commitment pending AI Economics Deep-Dive outcome.

---

## Q5 — Public Launch placement

**Question:** Where in the Phase/Stage map does the launch-state `Public Launch` (active distribution effort, content cadence, community presence) actually sit?

**Options (original):**

- (a) **Stage S1.D = Public Launch.** "Soft Public Open" and "Public Launch" are the same thing. Anyone can sign up; we're actively promoting; pricing live.
- (b) **Stage S1.D = Soft Public Open ≠ Public Launch.** S1.D is "anyone can sign up but we're not promoting hard." Public Launch is later — mid-S2 after AI tier ships, or S2 exit.
- (c) **Multi-event.** Founding Beta launch (S1.C), Soft Public Open (S1.D), Public Launch (S2 mid), Full Public (S2 exit). Each is its own milestone.
- (d) **Don't define yet.** Leave Public Launch undefined until S1.B/C reveal what scaling looks like.

**Options (PH-first reframe):**

- (e) **PH-only Soft Public Open at S1.D, PH-only Public Launch at S2 mid.** US testers grandfathered. No US re-engagement scheduled.
- (f) **(e) + explicit US re-engagement trigger.** PH Public Launch at S2 mid. US re-engagement deferred to a later Phase (concept paired with S5 ZK middleware timing), exact Phase label TBD at S1.B → S1.C transition.
- (g) **Multi-event PH-first.** Founding Beta (S1.C, PH primary) → PH Soft Public Open (S1.D) → PH Public Launch (S2 mid) → PH Full Public (S2 exit). US Public Launch is a separate later event.

**Decision (2026-04-30):** **Option (f) — locked.**

PH-first multi-event sequence:

- **Founding Beta launch (S1.C):** PH primary. PH Paying Founders + US Honorary Founders. Founder badge for both groups; pricing differentiated.
- **PH Soft Public Open (S1.D):** Anyone can sign up; pricing visible; low-key promotion only.
- **PH Public Launch (S2 mid):** Active PH distribution (PH-local creators, FB groups, OFW communities, content cadence).
- **PH Full Public (S2 exit):** Steady-state production in PH.

**US re-engagement deferred.** Concept locked: US re-engagement happens when ZK middleware (S5) or its dev-channel reputation work (S4) is shippable, roughly aligned with S5 timing. Exact Phase label (S5.A, separate Phase, or other) deferred to S1.B → S1.C transition decision point.

**Asymmetric pricing for US users (locked):**

- **US Honorary Founders:** continued free Pro tier access; grandfathered.
- **AI tier in S1.C:** PH-only initially; not available to US users.
- **AI for US (post-PH-validation, post-trigger):** USD-equivalent prices (e.g. $7.99/mo Pro+ AI), inference paid in USD by us at PH margin economics. Currency conversion fees passed through.
- **Founder badge / acknowledgment:** distinct page; PH Paying Founders + US Honorary Founders both surfaced.

**HitM signoff:** yes (2026-04-30)

---

## Q6 — Calendar comfort

**Question:** Rough calendar windows for the Phases (estimates, not commitments):


| Phase / Stage | Estimate                      |
| ------------- | ----------------------------- |
| S1.A          | Apr 2026 (just completed)     |
| S1.B          | May–Jun 2026                  |
| S1.C          | Jul–Sep 2026                  |
| S1.D          | Sep–Dec 2026                  |
| S2            | Q1–Q3 2027                    |
| S3            | Q3 2027–Q2 2028 (overlaps S2) |
| S4            | Q1–Q4 2028                    |
| S5            | Q3 2028–Q3 2029 (conditional) |
| S6            | Q1 2029–Q2 2030 (conditional) |


**Calibration questions:**

- Does S1.B–D taking until end of 2026 feel right, faster, or slower than your gut?
- Is there a hard external deadline (tax cycle, family event, financial runway) that should anchor any Phase?
- Should we explicitly name a Maintenance Sprint window between S1.A and S1.B for decompression?

**Decision (2026-04-30):** **Locked as proposed**, with the following structural input flagged for Topic 8:


| Phase / Stage | Estimated calendar                                                         |
| ------------- | -------------------------------------------------------------------------- |
| S1.A          | Apr 2026 (complete)                                                        |
| S1.B          | May–Jul 2026 (~3 mo) — research-heavy                                      |
| S1.C          | Aug–Oct 2026 (~3 mo) — Founding Beta + AI tier (PH-only)                   |
| S1.D          | Nov 2026–Feb 2027 (~3–4 mo) — PH Soft Public Open                          |
| S2            | Mar–Sep 2027 (~6 mo) — PH Public Launch + scaling                          |
| S3            | Q4 2027–Q2 2028 (overlaps S2) — Android scaling                            |
| S4            | Q3 2027–Q3 2028 (overlaps S2/S3) — Trust/reputation                        |
| S5            | Q3 2028–Q3 2029 (conditional) — ZK middleware + potential US re-engagement |
| S6            | Q1 2029–Q2 2030 (conditional) — Sari-Sari B2B                              |


**Acceleration permitted** if S1.B research surfaces faster than expected, but velocity ceiling enforced via Topic 8 mechanisms (see below).

**Structural input — HitM overwork pattern (flagged for Topic 8):**

HitM identified personal work-pattern risk: tendency to hyper-fixate and overwork (ADHD-driven dopamine pattern). Real friction at home; expected to be partially managed by baby's schedule but requires structural support. To be addressed in Topic 8 via:

1. **Cursor usage cap as forcing function** — when monthly cap hits, stop. No overages. Reframes cost-discipline as health-discipline.
2. **Sprint duration minimums** — schedule Sprints longer than the work needs, to prevent "just one more thing" cascade.
3. **Hard off-time defaults** — to be agreed in Topic 8 (e.g. weekend cadence, evening boundary, etc.).
4. **Family / health quarterly review** (per `kill_commit_gates.md` §6) becomes operational, not theoretical.

**HitM signoff:** yes (2026-04-30)

---

## Working space

Use this section for thinking-out-loud, partial answers, alternatives we discussed but didn't pick. Doesn't migrate to `DECISIONS.md`.

*(empty)*