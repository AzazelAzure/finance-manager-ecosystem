# Unit Economics, Cost Caps, and Tax Structuring

This file is the financial guardrail for the roadmap. Re-read before any tier/pricing/feature change.

## 1) Current Overhead Baseline (2026-04-28)

| Item | Cost (USD/mo) | Notes |
|---|---|---|
| Cursor Pro | ~$20 | Required for current dev velocity; non-negotiable in S1–S2. |
| VPS (Hostinger or similar PH-friendly) | ~$5–15 | Beta scale. May rise to ~$30 at S2 if scale demands. |
| Domain + TLS | ~$1–2 | Baseline. |
| Slack/CLI bridge LLM API costs (currently bundled with Cursor) | ~$0–20 | Treated as part of Cursor budget. |
| **Approx. total operating overhead** | **~$30–60/mo** | Owner-stated overhead figure of ~$100/mo includes buffer + Stripe-style aggregation if it ever turns on. |

**Personal overhead context (from 2026-04-28):** owner cites ~$2k USD/mo personal living overhead. Project must not increase that beyond the line items above without crossing a kill/commit gate.

## 2) Pricing Tiers (Reference Model — Locked at S1 Public Beta Launch)

Anchored to PH purchasing power; convertible to USD/EUR with regional pricing later.

| Tier | PHP/mo | USD/mo | What's included |
|---|---|---|---|
| **Free** | ₱0 | $0 | Safe-to-spend dashboard, manual entry, single account, GCash/Maya CSV import for PH users only, ~10 free AI prompts/month (small model). |
| **Pro (PH)** | ₱149–₱249 | ~$2.50–$4.50 | Multi-account, automatic GCash/Maya parsing (PH only), 100 AI prompts/month (smart model), priority support, family-share (up to 3 members). |
| **Pro (US/EU)** | – | $7.99 | Same as Pro PH minus GCash/Maya (replaced by CSV import + future Plaid optional). |
| **Pro Annual** | ₱1,499 | ~$25 / $79 | 40% discount vs monthly. Cuts churn dramatically. |
| **Pro+ AI** | ₱349 | ~$6.50 | Pro plus 500 AI prompts/month, "AI planning sessions" feature, advanced predictions. |
| **AI Credits PAYG** | ₱49 / 100 prompts | ~$0.99 / 100 | Top-up sold to all paid tiers. |
| **Founding Lifetime** | ₱999–₱1,499 one-time | ~$18–$28 one-time | First 50–100 seats only. PH-region pricing. Hard cap. |

**Pricing decisions deferred until S2:** US/EU tier exact price, PHP→USD conversion strategy, family/team plans.

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

- **Free tier monthly LLM spend cap:** $50/mo at S1 launch, scales to $200/mo at S2 if paid users >100, $500/mo at S3.
- **Trigger:** if free-tier LLM spend > 30% of MRR in any month, free tier prompts/mo is reduced (5 → 3 → 1) until paid conversion catches up.
- **Caching is mandatory:**
  - Merchant-name → category mapping cached forever (it doesn't change).
  - Recurring transaction predictions cached for 24h.
  - Safe-to-spend forecasts cached for 1h per user.
- **Batch processing where possible:** weekly digest "smart predictions" run as a batch job at off-peak hours, not per-action.

## 4) Break-Even and Win Math

### 4.1 Break-even (cover overhead only)

- Overhead: ~$60/mo conservative, ~$100/mo with buffer.
- Effective gross margin per Pro PH sub: ₱149/mo × 0.85 (Stripe + AI cost) ≈ ₱127/mo ≈ $2.20/mo.
- **Break-even at $100/mo overhead → ~45 Pro PH subs OR ~13 Pro US/EU subs OR a mix.**
- Realistic mix at S2 exit: 30 PH Pro + 5 US/EU Pro + 2 Pro+ AI ≈ ~$130/mo gross. Break-even possible.

### 4.2 Win ($1k MRR)

- ₱1k MRR ≈ ~₱56,000/mo at exchange rate.
- Mix scenario A (PH-heavy): 300 Pro PH + 30 US/EU Pro + 15 Pro+ AI ≈ ~$1,050/mo gross.
- Mix scenario B (Pro+ AI loaded): 150 Pro PH + 50 US/EU Pro + 50 Pro+ AI ≈ ~$1,025/mo gross.
- **Realistic timeline: 24–36 months post-S1 launch.**

### 4.3 Tax Cliff Threshold

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
4. Owner becomes salaried/contracted employee of PH entity.
5. Distribution timing controlled via salary + dividend mix to manage FEIE + PH tax simultaneously.

**Cost estimate for restructuring:** ~$2,000–$5,000 USD one-time (advisor fees + entity setup + accounting setup). This is the "good problem to have" cost.

### 5.2 Pre-trigger compliance hygiene (always)

- Keep clean revenue ledger (Stripe → spreadsheet → annual export).
- Keep clean expense ledger (Cursor, VPS, domain, AI API costs).
- File US Form 2555 (FEIE) annually regardless of MRR.
- File PH BIR returns once entity exists.
- Do not accept payments to personal name once revenue exists; route through Stripe to a business bank account.

## 6) Operating Cost Discipline Rules

- **Monthly cost audit (1st of month):** spend a fixed 30 minutes reviewing all subscription costs + AI API usage. Cancel anything unused.
- **Cursor Pro stays in S1–S2.** Re-evaluate at S3 entry; possible downgrade to Pro pay-per-use if velocity allows.
- **VPS sizing rule:** stay one tier below "comfortable" until paid users justify the upgrade. Add CPU/RAM only when monitoring shows actual saturation, not anticipated load.
- **Free LLM tier rule:** if free-tier LLM cost exceeds 30% of paid-tier MRR for two consecutive months, prompts/mo is halved.
- **No paid ads pre-S5.** No exceptions.

## 7) Revenue Recognition (Simple Model)

- All revenue is treated as recognized in the month received (cash basis), not deferred.
- Annual subs are recognized in full in the month of payment for owner's internal MRR tracking, *but* a separate "deferred MRR" line is maintained for honesty (especially before tax structuring).
- Founding lifetime deals are recorded separately and **not** counted toward MRR. They are one-time capital.

## 8) Owner-Specific Risk Notes

- VA disability income is the personal floor. The project does not need to replace it.
- Baby due 2026-06. Plan assumes ~30–50% velocity loss from 2026-06 through 2026-12. S1 exit criteria are intentionally lenient on calendar date.
- Fiancée/wife does not work. Household has zero second-income buffer. Treat any personal capital injection into the project as a clearly-tracked loan, not an investment, to keep boundaries clean.
