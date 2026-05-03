# Unit Economics, Cost Caps, and Tax Structuring

**Originally captured:** 2026-04-28. **Major revision:** 2026-04-30 post-beta huddle (PH-first market lock; revenue path constrained to subscription + Sari-Sari B2B + curated partners; ads + user-data sales rejected). **Overhead baseline:** revised 2026-05-01 (Cursor/VPS/domain actuals; Slack bridge on hiatus). **List-price lock (PH subscription + PAYG floor + founding cap):** 2026-05-01 — see §2 intro.

This file is the financial guardrail for the roadmap. Re-read before any tier/pricing/feature change.

## 1) Current Overhead Baseline


| Item                                   | Cost (USD/mo)     | Notes                                                                                                                                                                                                                          |
| -------------------------------------- | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Cursor Pro+                            | **~$60**          | Required for current dev velocity; non-negotiable in S1–S2.                                                                                                                                                                    |
| VPS (Hostinger or similar PH-friendly) | **~$40**          | Current production-adjacent tier; revise if scale demands.                                                                                                                                                                     |
| Domain + TLS                           | **~$2** (~$20/yr) | Registration + certs amortized monthly.                                                                                                                                                                                        |
| Slack/CLI bridge                       | **$0**            | **Temporary hiatus** while integration options settle. No separate Slack subscription HitM-paid—any future bridge is expected to ride **Cursor Pro+** tooling/entitlements only; no incremental line item unless that changes. |
| **Approx. total operating overhead**   | **~$100–105/mo**  | Sum of Cursor + VPS + domain; rounded. Add buffer for spikes (LLM PAYG outside Cursor, incidentals) → planning **~$115–130/mo** conservative.                                                                                  |


**Hard cap:** ₱100/mo (≈$1.80/mo at current FX) runtime cost cap per HitM personal constraint (`00_strategic_context.md` §7). New infrastructure proposals must fit this cap or are blocked.

**Personal overhead context:** HitM cites ~$2k USD/mo personal living overhead. Project must not increase this beyond the line items above without crossing a kill/commit gate.

## 2) Pricing Tiers

Anchored to PH purchasing power. **PH-first market focus locked 2026-04-30** (`00_strategic_context.md` §3.8).

### 2.0 Locked list prices — PH subscription, PAYG floor, founding cohort (2026-05-01)


| Item                  | Lock                                               | Notes                                                                                                                                                                                                                                          |
| --------------------- | -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Pro (monthly)**     | **₱249/mo** list                                   | Within published band **₱149–₱249**; humane pricing vs **₱250** negligible. Gate headcount normalization in `validation_gates.md` may still cite **₱199** anchor until that file is updated—recompute equivalents when reconciling milestones. |
| **Pro+ AI (monthly)** | **₱349/mo** list                                   | Included **250 credits/mo**.                                                                                                                                                                                                                   |
| **PAYG price floor**  | **₱99 → 100 credits**                              | Canonical **~₱0.99/credit**; parity anchor vs subscription allowances.                                                                                                                                                                         |
| **Founding Lifetime** | **₱999–₱1,499** one-time · **≤100 seats** hard cap | Seat count **locked at 100** for planning; entitlement text still ToS-ready per Appendix A founder questions.                                                                                                                                  |


**Not locked:** **Pro Annual** SKU math (still table band); optional **larger PAYG bundles** — see `**plans/cursor/s1b/ai-economics-deep-dive/PAYG_VOLUME_BUNDLES_RESEARCH.md`** before adding SKUs.


| Tier                                    | PHP/mo                   | USD/mo            | What's included                                                                                                                                                                                                                                                                                         |
| --------------------------------------- | ------------------------ | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Free (PH primary)**                   | ₱0                       | $0                | Safe-to-spend dashboard, manual entry, single account, GCash/Maya CSV import for PH users only, **~10 AI credits/month** (wallet debits **1× mini** baseline; **T2+ blocked** — see metering §2.5).                                                                                                     |
| **Pro (PH)**                            | **₱249/mo** list         | ~$4.45            | Multi-account, automatic GCash/Maya parsing (PH only), **100 AI credits/month**, priority support, family-share (up to 3 members). Stronger flows **burn >1 debit/credit**. Band **₱149–₱249** remains for future promos or regional variation unless strategy reopens.                                 |
| **Pro Annual (PH)**                     | ₱1,499–₱2,499            | ~$25–$45          | 40% discount vs monthly. Cuts churn dramatically. **Shelf prices** still tentative until PSP + annual cohort behavior validated.                                                                                                                                                                        |
| **Pro+ AI (PH)**                        | **₱349/mo** list         | ~$6.50            | Pro plus **250 AI credits/month**, “AI planning sessions,” advanced predictions. Same **BC ledger**; scaled debits.                                                                                                                                                                                     |
| **AI Credits PAYG**                     | **₱99 → 100 credits**    | **~$1.77 / pack** | **Floor SKU locked.** Top-up: **~₱0.99/credit** list (**1 peso ≈ 1 credit** UX). **Larger bundles** — if offered — must pass volume-discount economics (`PAYG_VOLUME_BUNDLES_RESEARCH.md`); baseline pack remains parity anchor. Ledger: `**AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md` §2.5, §8**. |
| **Founding Lifetime (PH)**              | **₱999–₱1,499** one-time | ~$18–$28 one-time | **First 100 seats** (hard cap for planning). **Pro+ entitlement + founder PAYG discount band** (`00_strategic_context.md` §3.11, Appendix A) — legal/marketing wording still finalized in ToS.                                                                                                          |
| **Honorary Founder (US grandfathered)** | $0                       | $0                | Existing US testers grandfathered with free Pro tier access; founder badge; no payment. AI tier deferred until US re-engagement trigger fires (P-6).                                                                                                                                                    |
| **Pro (US)** — *deferred*               | –                        | $7.99             | NOT live in S1. Activates if/when P-6 trigger fires for US re-engagement. Same as Pro PH minus GCash/Maya.                                                                                                                                                                                              |


**Included credits / month:** **10 / 100 / 250** (Free / Pro / **Pro+**). **Parity shorthand:** implied PAYG-parity of included AI bucket alone at list floor ≈ **~₱99 / ~₱248 / month** equivalents for Free / Pro / Pro+ allowances (still not full product COGS story). See `CREDIT_FLOOR_SUBSCRIPTION_AND_FOUNDER_MATH.md`.

**Critical constraints:**

- **GCash/Maya as primary payment method, not fallback** (per `00_strategic_context.md` §3.9). S1.B billing infra design must support direct GCash/Maya. Forcing PH users to have a credit card is a non-starter.
- **Mobile wallet billing legality for US-incorporated business** is part of the S1.B research workstream.
- **Still pending at PSP / implementation detail:** exact **annual** SKUs, **multi-currency display**, and **optional PAYG volume packs** (must follow `PAYG_VOLUME_BUNDLES_RESEARCH.md`). The PSP MDR is locked at **~2.0%** blended for e-wallets (PM4).

**Affordability vs margin (pricing discipline):**

- **Goal:** balance **affordability** (common PH user still willing to upgrade) with **sustainable margin** after PSP take-rate and AI variable cost.
- **Pro list lock:** **₱249/mo** (2026-05-01) sits at the top of the **₱149–₱249** band—still consistent with the original **ceiling** intent; reopen only via strategic context if conversions fail.
- **Implication for gates:** break-even and Phase **paying-user minimums** are **not fixed magic numbers**. They must be **reconciled at S1.B pricing + PSP lock** to the **net PHP (and USD) per paying sub** implied by the chosen list price. **Lower Pro price for conversion → fewer pesos per sub → more paying users required** for the same overhead and revenue-equivalent milestones (see §4.1 table).
- **Procedure:** when Pro list + blended PSP net % is locked, update `validation_gates.md` headcount triggers per the indexing rule there, and refresh §4.1 worked examples.

**Deferred until S1.B feature roadmap is solid (then revisit in one pass):**

- **Free vs paid feature map:** do **not** treat the tier table above as final entitlements row-by-row until HitM’s **S1.B feature backlog** (what ships in S1.B / what seeds S1.C) is clear. Come back for a deliberate **heads-up pass:** which capabilities keep users **sticky and daily-active on Free** (wedge + trust) versus which **meaningfully justify Pro / Pro+ AI** without gutting the free hook. Reconcile outcomes with AI variable cost (`§3`) and affordability rules above.
- **Pro free-trial pattern (candidate, not locked):** later consider **first month free Pro** with **payment method on file** and copy that matches common SaaS norms: user may **cancel before first charge**; **renewal billing automatic** afterward. Requires explicit **risk/reward** work: downgrade shock and **churn entirely** vs **taste of paid** driving willing conversion. Decision depends on the finalized feature split (what trial actually demonstrates).
- **PSP / wallet behavior for trials:** investigate how chosen rails (e.g. PayMongo-class aggregators, GCash/Maya) handle **authorization vs first charge**, **wallet verification**, and **failed renewal**—either **prove funding** up front or accept **failed charge → downgrade / stop paid features** with clear UX (see `PARKING_LOT.md` **P-8**).

## 3) AI Cost Cap Model

LLM inference is the single largest variable cost as you scale free users. Without a cap, free tier eats the project.

### 3.1 Per-user AI allowance (billing credits) & cost budget

Included **wallet credits**/month (**same numeric caps** as legacy prompt allowances). **1 credit ≈ 1.0× mini Short‑S** debit baseline; routed models/long sessions multiply debits (**§2.5** metering doc).


| Tier    | Credits / mo | Default / ceiling routing (policy)                                                                  | Typical variable API envelope (still validate in prod)                                                                     |
| ------- | ------------ | --------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Free    | **10**       | **Mini-only**, T0/T1; **no T2+**                                                                    | Order **~$0.04–$0.05**/mo at full **1×** draw                                                                              |
| Pro     | **100**      | T2+ allowed; blended mini → Sonnet on gated flows                                                   | **~$0.38–$0.52**/mo @ full bucket (1× vs **~1.39×** effective debit — see `CREDIT_FLOOR_SUBSCRIPTION_AND_FOUNDER_MATH.md`) |
| Pro+ AI | **250**      | Planning-grade routes; **2.5×** Pro bucket size → scale COGS linearly vs Pro rows at same debit mix |                                                                                                                            |


**Hard rule:** if **rated debits** (after multipliers, in **1× equivalents**) exceed **2× nominal monthly allowance** in a billing period, throttle and offer **₱99 → 100** top-up. Enforce at **API gateway** with ledger, not raw model internals.

### 3.2 System-Level AI Cost Cap

- **Free tier monthly LLM spend cap:** $50/mo at S1.C launch, scales to $200/mo at S2 if paid users >100, $500/mo at S3.
- **Trigger:** if free-tier LLM spend > 30% of MRR in any month, free tier **included credits**/mo is reduced (**10 → 5 → 3 → 1** analog) until paid conversion catches up.
- **Caching is mandatory:**
  - Merchant-name → category mapping cached forever.
  - Recurring transaction predictions cached for 24h.
  - Safe-to-spend forecasts cached for 1h per user.
- **Batch processing where possible:** weekly digest "smart predictions" run as a batch job at off-peak hours, not per-action.

### 3.3 AI Economics Deep-Dive (S1.B workstream)

Required S1.B sub-Sprint before S1.C opens. 16 interlocking decisions, captured in `phases/S1_public_beta_position.md`. Final Pro+ AI commitment (currently `S1.C tentative` per Topic 4 Q4) depends on this deep-dive's outcome.

**Model-vs-price sanity check:** `plans/cursor/s1b/ai-economics-deep-dive/LLM_PROVIDER_COST_SNAPSHOT.md` — full **bucket** usage vs tariff (still uses **completion** framing; aligns to **debit multipliers** in metering doc).

**Metering / BC ledger:** `plans/cursor/s1b/ai-economics-deep-dive/AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md` — **tier ceilings**, debit multipliers, PAYG **₱99 → 100**.

**Floor vs subscription vs founder discounts:** `plans/cursor/s1b/ai-economics-deep-dive/CREDIT_FLOOR_SUBSCRIPTION_AND_FOUNDER_MATH.md` — **net $/credit**, **COGS/credit**, Pro **100** vs Pro+ **250**, breakeven **discount vs PAYG**.

### 3.4 AI usage observability (S1.C implementation — required for financial health)

Ship **privacy-respecting usage telemetry** alongside the AI gateway so margins stay evidence-based (not guesswork). **Default posture:** **aggregate and/or strongly pseudonymous** metrics suitable for **COGS and product** decisions—avoid storing raw chat content in analytics pipes.

**Minimum dimensions to plan for in the AI implementation phase:**


| Area                                      | Why                                                                                                                                                                       |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Invocations / DAU / WAU**               | Baseline load vs paying mix.                                                                                                                                              |
| **Multi-turn sessions**                   | Conversation length drives token growth; long “financial health” sessions should be **rare** if product is tight—**validate** with data.                                  |
| **Credits debited per interaction**       | Reconcile wallet drains to **tiered multipliers** (`AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md` §2.5): baseline **1× mini** vs **scaled** Sonnet / long / multi-turn. |
| **T0–T3 bucket counts**                   | Route roadmap and pricing to **actual** use-case mix (see `AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md` §1).                                                           |
| **Model_id + token histograms (p50/p95)** | Catch blend drift; tune caps and **dynamic list prices** later.                                                                                                           |
| **Top-up purchase vs burn rates**         | Sanity-check ₱99→100 pack economics over time.                                                                                                                            |


**Outcome:** After baseline telemetry exists, **re-price** packs or subscription allowances using measured distributions (still subject to PSP + positioning gates)—see metering doc §9 checklist.

## 4) Break-Even and Win Math

### 4.1 Break-even (cover overhead only)

- Overhead: **~$102/mo** recurring baseline (§1); **~$115–130/mo** with buffer and incidentals.
- **Modeling shortcut:** **Pro list locked ₱249** (2026-05-01, §2.0); use **~0.85 × list** as a highly conservative “net PHP after processor + rough AI allowance” for **Pro-only** napkin math (with PSP fee locked at ~2.0% blended, this leaves a generous ~13% buffer for AI COGS). USD column uses **illustrative ₱56/$1**; refresh FX at lock.
- **Sensitivity — Pro list price vs break-even headcount** (all Pro PH, ~0.85 net, $125/mo all-in overhead, illustrative FX):


| Pro list (₱/mo) | Net ₱/mo (×0.85) | ~USD/sub/mo @₱56:$1 | ~Pro subs for $125/mo |
| --------------- | ---------------- | ------------------- | --------------------- |
| 149             | 127              | 2.26                | **~55**               |
| 179             | 152              | 2.72                | **~46**               |
| 199             | 169              | 3.02                | **~41**               |
| 249             | 212              | 3.78                | **~33**               |


- **Affordability choice:** locking Pro at the **lower** end of the band **raises** the subscriber count needed to cover the same USD overhead; **profit maximization** via higher list price **lowers** required N but must stay within the **upgrade psychology cap** (see §2 pricing discipline).
- **Mix:** Founding one-time, Pro+ AI, and PAYG credits change blended ARPU—gates that count “paying users” should still be **re-indexed** when Pro ASP moves (see `validation_gates.md`).

**Anchors used elsewhere until revised at S1.B lock**

- **Mid-band illustration (₱199 list):** net **~$3.02/mo**/sub → **~41** Pro subs for **$125/mo** overhead; **~34** subs for **$102/mo** baseline.
- **Floor price illustration (₱149 list):** net **~$2.26/mo**/sub → **~55** subs for **$125/mo**; **~45** for **$102/mo**.

### 4.2 Personal-replacement target (₱100k/mo take-home)

- HitM-stated personal success threshold: ₱100k/mo business take-home (matches current personal income).
- Gross PFM revenue required (after Stripe fees + tax overhead, single US entity): roughly ₱150k–180k/mo.
- Mix scenario at this scale: ~600–800 Pro PH subs + ~50–100 Pro+ AI subs.
- Realistic timeline: 18–30 months post-S1 launch.

### 4.3 Win ($1k MRR or ~₱56k/mo)

- Mix scenario: 300 Pro PH + 50 Pro+ AI + Founding Beta one-time capital.
- Realistic timeline: 24–36 months post-S1 launch.

### 4.4 Tax Cliff Threshold

- Foreign Earned Income Exclusion (FEIE) for 2026: ~$126,000–$130,000/yr (verify current IRS figure each tax year).
- Anything above this: US tax applies even living in PH.
- **Trigger:** if MRR × 12 × 0.85 (gross margin) projects to exceed FEIE within 12 months, structuring task fires (see §5).

## 5) Tax / Compliance Structuring (Forward-Looking)

These are pre-decided actions, not commitments to act now.

### 5.0 Operating entity pipeline (HitM lock — 2026-05-03)

Authoritative narrative for **how** revenue is intended to flow pending counsel, PSP KYB, and written agreements (see `plans/cursor/s1b/entity-formation-research/README.md` §0.2 and `DECISION_MATRIX.md` L2–L4):

- **PH operating entity (spouse-led):** Filipino-owned vehicle is **merchant of record** for PHP customer receipts, PSP settlement, and PH tax filings. Spouse has **agreed** to genuine management responsibilities consistent with **Anti-Dummy** constraints.
- **HitM US LLC:** Acts as **independent contractor** — software / IP **licensor** and technical **services vendor** to the PH entity under B2B contracts (arm’s-length pricing **TBD** with PH + US tax advisors).
- **Personal tax:** US citizen receiving US LLC income while resident in PH is **high-sensitivity**; requires coordinated **US + PH advisor** modeling (FEIE, sourcing, intercompany deductibility)—**not** decided by this bullet.
- **US market later:** Same US LLC supports **US-facing** revenue when roadmap gates allow (`PARKING_LOT.md` P-6), reducing need for a net-new US shell at that time.
- **Future code/deploy split:** When volume and compliance warrant, **isolate** PH wallet integrations from US-only product surfaces and US card rails from PH-only surfaces (separate repos or deploy lanes)—engineering decision after **payment-provider** lock.

### 5.1 Trigger: MRR projects to ≥80% of FEIE within 12 months

*Note (2026-05-03): The **initial** operating pattern is locked in **§5.0** (spouse-led PH MoR + HitM US LLC vendor). When this trigger fires, **PH + US tax counsel** must reconcile the generic restructuring checklist below with that pipeline (intercompany pricing, roles, and distributions)—do not treat the numbered list as literal order without advisor signoff.*

Within 60 days of trigger:

1. Engage PH + US tax advisor (one of each, not a generalist).
2. Form PH SEC-registered entity (Corporation or sole-proprietorship; advisor recommends).
3. Transfer PFM IP and revenue contracts to PH entity.
4. HitM becomes salaried/contracted employee of PH entity.
5. Distribution timing controlled via salary + dividend mix to manage FEIE + PH tax simultaneously.

**Cost estimate for restructuring:** ~$2,000–$5,000 USD one-time (advisor fees + entity setup + accounting setup).

### 5.2 Pre-trigger compliance hygiene (always)

- Keep clean revenue ledger (Stripe → spreadsheet → annual export).
- Keep clean expense ledger (Cursor, VPS, domain, AI API costs).
- File US Form 2555 (FEIE) annually regardless of MRR.
- File PH BIR returns once entity exists.
- Do not accept payments to personal name once revenue exists; route through Stripe to a business bank account.

### 5.3 Earlier dual-entity trigger (separate from §5.1)

**Update (2026-05-03):** The **settlement dual-entity** pattern (PH spouse-led MoR + HitM US LLC vendor) is now **locked** in §5.0 for the PH wedge. Per `PARKING_LOT.md` P-2, additional **corporate** complexity (e.g. further PH vehicles, US C-Corp, or holding stacks) may still be needed *before* the §5.1 FEIE trigger if **payment or tax friction** at volume demands it—advisor-driven, distinct from the §5.0 operating pipeline lock.

## 6) Operating Cost Discipline Rules

- **Monthly cost audit (1st of month):** spend a fixed 30 minutes reviewing all subscription costs + AI API usage. Cancel anything unused. **First execution: 2026-05-01** per Topic 8 Q8.5 lock.
- **Cursor cap as forcing function:** when monthly Cursor cap is hit, work on PFM stops until next billing cycle. **No overage purchases.** Per Topic 8 Q8.1 lock.
- **Daily / weekly work ceiling:** 10 hours/day max; 55 hours/week max. Local Cursor "time clock" agent enforces (Topic 8 Q8.3 lock).
- **Decompression ceiling:** 6 hours/day, 30 hours/week during decompression weeks (Topic 8 Q8.3 lock).
- **VPS sizing rule:** stay one tier below "comfortable" until paid users justify the upgrade.
- **Free LLM tier rule:** if free-tier LLM cost exceeds 30% of paid-tier MRR for two consecutive months, **included free credits**/mo is halved.
- **No paid ads pre-S5.** No exceptions. (Locked + reinforced 2026-04-30; see `00_strategic_context.md` §4.)

## 7) Revenue Recognition (Simple Model)

- All revenue is treated as recognized in the month received (cash basis), not deferred.
- Annual subs are recognized in full in the month of payment for HitM's internal MRR tracking, *but* a separate "deferred MRR" line is maintained for honesty.
- **Founding Beta lifetime deals are recorded separately and NOT counted toward MRR.** They are one-time capital. Gross from founding seats (~₱100k–150k for a full 50–100 cap at PH pricing) covers infra costs for ~2–3 years independent of MRR.

## 8) Revenue Path Constraints (locked 2026-04-30)

The combination of locked decisions has narrowed the revenue surface:


| Path                             | Status                                | Source                              |
| -------------------------------- | ------------------------------------- | ----------------------------------- |
| **Subscription (Pro / Pro+ AI)** | Primary                               | All sections above                  |
| **Founding Beta lifetime**       | One-time capital, S1.C only, hard cap | §7, `00_strategic_context.md` §3.11 |
| **PAYG AI credits**              | Supplement to subscription            | §2                                  |
| **Sari-Sari B2B (S6+)**          | Future revenue stream                 | `00_strategic_context.md` §3.6      |
| **Curated affiliate / partner**  | Future, conditional                   | `PARKING_LOT.md` P-4                |
| **Sponsored partnership**        | Future, scale-dependent               | `PARKING_LOT.md` P-5                |
| **GCash/Maya partnership**       | Future, partnership-only              | `PARKING_LOT.md` P-1                |
| ~~Ads~~                          | **Rejected**                          | `00_strategic_context.md` §4        |
| ~~User-data monetization~~       | **Rejected**                          | `00_strategic_context.md` §4        |
| ~~US market acquisition (S1)~~   | **Deferred to P-6 trigger**           | `00_strategic_context.md` §3.8      |


Without ads or user-data, ZK middleware (S5) is the structural revenue defense — premium subscription pricing is justified by "we genuinely cannot read your data," which is only credible with ZK shipped.

## 9) HitM-Specific Risk Notes

- **VA disability income** is the personal floor. The project does not need to replace it.
- **Baby due 2026-06-15.** Plan assumes ~30–50% velocity loss from mid-June through end of 2026. Phase calendar accounts for this.
- **Wife / fiancée does not work.** Household has zero second-income buffer. Treat any personal capital injection into the project as a clearly-tracked loan, not an investment.
- **Monthly savings target cycle:** HitM pay arrives end of month; the constrained spending applies to the *next* month. May 2026 currently constrained; future months TBD. New project costs that breach this cycle are blocked until cleared.
- **Personal-business income separation:** treat business and personal as distinct streams; pay self a wage from business if/when entity exists. Confirmed at huddle 2026-04-30.

