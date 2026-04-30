# Unit Economics, Cost Caps, and Tax Structuring

**Originally captured:** 2026-04-28. **Major revision:** 2026-04-30 post-beta huddle (PH-first market lock; revenue path constrained to subscription + Sari-Sari B2B + curated partners; ads + user-data sales rejected).

This file is the financial guardrail for the roadmap. Re-read before any tier/pricing/feature change.

## 1) Current Overhead Baseline

| Item | Cost (USD/mo) | Notes |
|---|---|---|
| Cursor Pro+ | ~$20 | Required for current dev velocity; non-negotiable in S1–S2. Current cycle: 57% used as of 2026-04-30, refresh 2026-05-28. |
| VPS (Hostinger or similar PH-friendly) | ~$5–15 | Beta scale. May rise to ~$30 at S2 if scale demands. |
| Domain + TLS | ~$1–2 | Baseline. |
| Slack/CLI bridge LLM API costs (currently bundled with Cursor) | ~$0–20 | Treated as part of Cursor budget. |
| **Approx. total operating overhead** | **~$30–60/mo** | HitM-stated overhead figure of ~$100/mo includes buffer. |

**Hard cap:** ₱100/mo (≈$1.80/mo at current FX) runtime cost cap per HitM personal constraint (`00_strategic_context.md` §7). New infrastructure proposals must fit this cap or are blocked.

**Personal overhead context:** HitM cites ~$2k USD/mo personal living overhead. Project must not increase this beyond the line items above without crossing a kill/commit gate.

## 2) Pricing Tiers

Anchored to PH purchasing power. **PH-first market focus locked 2026-04-30** (`00_strategic_context.md` §3.8).

| Tier | PHP/mo | USD/mo | What's included |
|---|---|---|---|
| **Free (PH primary)** | ₱0 | $0 | Safe-to-spend dashboard, manual entry, single account, GCash/Maya CSV import for PH users only, ~10 free AI prompts/month (small model). |
| **Pro (PH)** | ₱149–₱249 | ~$2.50–$4.50 | Multi-account, automatic GCash/Maya parsing (PH only), 100 AI prompts/month (smart model), priority support, family-share (up to 3 members). |
| **Pro Annual (PH)** | ₱1,499–₱2,499 | ~$25–$45 | 40% discount vs monthly. Cuts churn dramatically. |
| **Pro+ AI (PH)** | ₱349 | ~$6.50 | Pro plus 500 AI prompts/month, "AI planning sessions" feature, advanced predictions. |
| **AI Credits PAYG** | ₱49 / 100 prompts | ~$0.99 / 100 | Top-up sold to all paid tiers. |
| **Founding Lifetime (PH)** | ₱999–₱1,499 one-time | ~$18–$28 one-time | First 50–100 seats only. PH-region pricing. Hard cap. **Tentative includes Pro+ AI tier access** pending AI Economics Deep-Dive (`00_strategic_context.md` §3.11). |
| **Honorary Founder (US grandfathered)** | $0 | $0 | Existing US testers grandfathered with free Pro tier access; founder badge; no payment. AI tier deferred until US re-engagement trigger fires (P-6). |
| **Pro (US)** — *deferred* | – | $7.99 | NOT live in S1. Activates if/when P-6 trigger fires for US re-engagement. Same as Pro PH minus GCash/Maya. |

**Critical constraints:**

- **GCash/Maya as primary payment method, not fallback** (per `00_strategic_context.md` §3.9). S1.B billing infra design must support direct GCash/Maya. Forcing PH users to have a credit card is a non-starter.
- **Mobile wallet billing legality for US-incorporated business** is part of the S1.B research workstream.
- **Pricing decisions still pending S1.B research:** exact Pro PH price within ₱149–₱249 range, AI economics validation, currency handling.

## 3) AI Cost Cap Model

LLM inference is the single largest variable cost as you scale free users. Without a cap, free tier eats the project.

### 3.1 Per-User AI Cost Budget

| Tier | AI calls/mo | Model class | Per-call cost (est.) | Per-user cost cap (mo) |
|---|---|---|---|---|
| Free | 10 | Small (Haiku, GPT-mini, local Llama) | $0.001–$0.005 | **$0.05** |
| Pro | 100 | Mid (Sonnet, GPT-4-mini) | $0.005–$0.02 | **$2.00** |
| Pro+ AI | 500 | Mid → Large for "planning sessions" | $0.005–$0.05 | **$10.00** |

**Hard rule:** if any user crosses 2× their tier cap in a billing period, request is throttled and user is offered a credits top-up. Implement this at the API gateway, not in the model call itself.

### 3.2 System-Level AI Cost Cap

- **Free tier monthly LLM spend cap:** $50/mo at S1.C launch, scales to $200/mo at S2 if paid users >100, $500/mo at S3.
- **Trigger:** if free-tier LLM spend > 30% of MRR in any month, free tier prompts/mo is reduced (5 → 3 → 1) until paid conversion catches up.
- **Caching is mandatory:**
  - Merchant-name → category mapping cached forever.
  - Recurring transaction predictions cached for 24h.
  - Safe-to-spend forecasts cached for 1h per user.
- **Batch processing where possible:** weekly digest "smart predictions" run as a batch job at off-peak hours, not per-action.

### 3.3 AI Economics Deep-Dive (S1.B workstream)

Required S1.B sub-Sprint before S1.C opens. 16 interlocking decisions, captured in `phases/S1_public_beta_position.md`. Final Pro+ AI commitment (currently `S1.C tentative` per Topic 4 Q4) depends on this deep-dive's outcome.

## 4) Break-Even and Win Math

### 4.1 Break-even (cover overhead only)

- Overhead: ~$60/mo conservative, ~$100/mo with buffer.
- Effective gross margin per Pro PH sub: ₱149/mo × 0.85 (Stripe + AI cost) ≈ ₱127/mo ≈ $2.20/mo.
- **Break-even at $100/mo overhead → ~45 Pro PH subs OR a mix.**

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

### 5.1 Trigger: MRR projects to ≥80% of FEIE within 12 months

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

Per `PARKING_LOT.md` P-2: HFM US / HFM PH dual-entity structure may need to be considered *before* the FEIE trigger if PHP-denominated payment processing friction blocks user acquisition at material volume. Different scenario from FEIE; same eventual structural change.

## 6) Operating Cost Discipline Rules

- **Monthly cost audit (1st of month):** spend a fixed 30 minutes reviewing all subscription costs + AI API usage. Cancel anything unused. **First execution: 2026-05-01** per Topic 8 Q8.5 lock.
- **Cursor cap as forcing function:** when monthly Cursor cap is hit, work on PFM stops until next billing cycle. **No overage purchases.** Per Topic 8 Q8.1 lock.
- **Daily / weekly work ceiling:** 10 hours/day max; 55 hours/week max. Local Cursor "time clock" agent enforces (Topic 8 Q8.3 lock).
- **Decompression ceiling:** 6 hours/day, 30 hours/week during decompression weeks (Topic 8 Q8.3 lock).
- **VPS sizing rule:** stay one tier below "comfortable" until paid users justify the upgrade.
- **Free LLM tier rule:** if free-tier LLM cost exceeds 30% of paid-tier MRR for two consecutive months, prompts/mo is halved.
- **No paid ads pre-S5.** No exceptions. (Locked + reinforced 2026-04-30; see `00_strategic_context.md` §4.)

## 7) Revenue Recognition (Simple Model)

- All revenue is treated as recognized in the month received (cash basis), not deferred.
- Annual subs are recognized in full in the month of payment for HitM's internal MRR tracking, *but* a separate "deferred MRR" line is maintained for honesty.
- **Founding Beta lifetime deals are recorded separately and NOT counted toward MRR.** They are one-time capital. Gross from founding seats (~₱100k–150k for a full 50–100 cap at PH pricing) covers infra costs for ~2–3 years independent of MRR.

## 8) Revenue Path Constraints (locked 2026-04-30)

The combination of locked decisions has narrowed the revenue surface:

| Path | Status | Source |
|---|---|---|
| **Subscription (Pro / Pro+ AI)** | Primary | All sections above |
| **Founding Beta lifetime** | One-time capital, S1.C only, hard cap | §7, `00_strategic_context.md` §3.11 |
| **PAYG AI credits** | Supplement to subscription | §2 |
| **Sari-Sari B2B (S6+)** | Future revenue stream | `00_strategic_context.md` §3.6 |
| **Curated affiliate / partner** | Future, conditional | `PARKING_LOT.md` P-4 |
| **Sponsored partnership** | Future, scale-dependent | `PARKING_LOT.md` P-5 |
| **GCash/Maya partnership** | Future, partnership-only | `PARKING_LOT.md` P-1 |
| ~~Ads~~ | **Rejected** | `00_strategic_context.md` §4 |
| ~~User-data monetization~~ | **Rejected** | `00_strategic_context.md` §4 |
| ~~US market acquisition (S1)~~ | **Deferred to P-6 trigger** | `00_strategic_context.md` §3.8 |

Without ads or user-data, ZK middleware (S5) is the structural revenue defense — premium subscription pricing is justified by "we genuinely cannot read your data," which is only credible with ZK shipped.

## 9) HitM-Specific Risk Notes

- **VA disability income** is the personal floor. The project does not need to replace it.
- **Baby due 2026-06-15.** Plan assumes ~30–50% velocity loss from mid-June through end of 2026. Phase calendar accounts for this.
- **Wife / fiancée does not work.** Household has zero second-income buffer. Treat any personal capital injection into the project as a clearly-tracked loan, not an investment.
- **Monthly savings target cycle:** HitM pay arrives end of month; the constrained spending applies to the *next* month. May 2026 currently constrained; future months TBD. New project costs that breach this cycle are blocked until cleared.
- **Personal-business income separation:** treat business and personal as distinct streams; pay self a wage from business if/when entity exists. Confirmed at huddle 2026-04-30.
