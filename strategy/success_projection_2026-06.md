# Success Projection — Long-Term Profitability Baseline

> **ADMIN / STRATEGY.** Baseline projection for re-scoring at the **Dec 31 2026** pseudo-open beta growth checkpoint and at each quarterly self-review. Probability bands are calibrated estimates, not forecasts — the point is to track whether they shift up or down as real usage data arrives.

**Generated:** 2026-06-26
**Author:** HitM + Claude Code (admin synthesis)
**Re-score triggers:** Dec 31 2026 growth checkpoint · quarterly self-reviews · any 10×-order change in active user base
**Cross-refs:** [`validation_gates.md`](./strategic-roadmap-reframe-53be/validation_gates.md) · [`current_status.md`](./current_status.md) §14 · memory `project-beta-strategy`

---

## 1. Corrected Burn Baseline

| Item | Monthly |
|---|---|
| Cursor Pro+ | ~$60 |
| Claude Pro | ~$20 |
| VPS | ~$40 |
| Domain / TLS | ~de minimis (amortized) |
| **All-in burn** | **~$120/mo (~₱6,840 at ₱57/USD)** |

This burns against a **personal budget, not investor capital.** That single fact dominates the entire projection (see §4).

**Note:** The HitM personal **₱100/mo runtime cost cap** in governance refers to *app-attributable runtime* (LLM inference for users, etc.), separate from this **founder tooling+infra overhead** of ~$120/mo. Don't conflate the two when reconciling gates.

---

## 2. The Revenue Ladder

Locked pricing: Pro ₱249/mo · Pro+ AI ₱349/mo · PAYG ₱99/100 credits · Founding ₱999–₱1,499 one-time.
Net-per-Pro at mid-band affordability ≈ **₱169** (gate-anchor normalization, ~0.85 of ₱199 anchor).

| Milestone | Net MRR | Paying users | Free users @3% | Free users @1.5% |
|---|---|---|---|---|
| **All-in break-even** (~$120/mo) | ~₱6,840 | **~41** | ~1,350 | ~2,700 |
| **Meaningful side income** | ₱30–50k | ~180–300 | ~6,000–10,000 | ~12,000–20,000 |
| **Personal target** (₱100k take-home) | ~₱120k gross | ~500–700 | ~17,000–23,000 | ~34,000–46,000 |

**The hard truth in this table:** the ₱100k/mo personal success target requires **~20,000+ active free users** acquired with **zero ad spend**, via organic invite-sharing, by a solo founder at a **6hr/day** ceiling. That is the central challenge — not the product, the *growth volume*.

**Conversion caveat:** 3% free-to-paid is generous for a **thin-margin PH audience** — the very segment the wedge targets is structurally the hardest to charge a recurring fee. 1.5–2% is the honest planning number, which roughly doubles every free-user requirement above.

---

## 3. Probability Bands (baseline 2026-06)

Calibrated to solo-founder bootstrapped base rates, adjusted for this situation. **Re-score each column at Dec 31.**

| Outcome | Prob. | Profile |
|---|---|---|
| **Quiet death** — never reaches break-even, shelved | **40–50%** | Organic growth stays linear-trickle; founder capacity exhausts before traction |
| **Self-sustaining hobby** — covers costs + small profit | **25–35%** | A few hundred users, ₱5–30k/mo; runs indefinitely because burn ≈ 0 |
| **Real side income** — ₱30–100k/mo | **12–18%** | Wedge resonates; invite mechanics produce mild compounding |
| **Founder-replacing** — ₱100k+/mo sustained | **4–8%** | Stated target. Needs a growth engine that does not exist yet |
| **Breakout** — B2B/ZK/acquisition | **1–3%** | S5 ZK moat or S6 sari-sari vertical pays off |

**Center of mass:** a self-sustaining product covering its own costs + modest side income (₱5–40k/mo), reached ~2028.

---

## 4. The Dominant Strategic Fact

**~$120/mo burn against a personal budget means the app essentially cannot fail financially.** Most startups die because runway runs out before product-market fit. This one can't — it dies only if the founder stops. This:

- **Shifts probability mass** from "quiet death" toward "self-sustaining hobby." Survival is cheap; you can absorb 3–4 years of slow organic growth a funded startup couldn't.
- **Reframes the dominant risk** from *money* to **founder attrition + opportunity cost.** The real runway is measured in motivation-years, not dollars. Break-even is realistically 2–4 years out; the ₱100k target, if ever, is 4–7 years. The question is whether you're still doing this in 2029–2031.

---

## 5. The Four Needle-Moving Variables

1. **Free-to-paid conversion in a low-WTP market.** The wedge (thin-margin users) is also the monetization curse. Central tension of the whole business. *Mitigations explored in §7 (OTP vs subscription) and §8 (platform distribution).*
2. **Organic growth coefficient.** Does invite-sharing compound or trickle? F-014 will finally measure this. If each user brings <0.5 new users, you never escape gravity without a new channel (§6).
3. **Founder longevity.** 6hr/day with a newborn, sustained for years. The true runway.
4. **Whether the privacy/ZK moat is something PH users will *pay for*** — or founder ideology the market doesn't price.

---

## 6. Marketing Research Avenues & Growth Magnification (late S1.B / S1.C)

> Current marketing (family + tester invites, organic share) is **temporary scaffolding.** These are research avenues to evaluate before/at S1.C when there's a real user base to amplify. **None of these are committed — they are a research backlog.**

### 6.1 Organic amplification (zero/low cost — aligned with current burn discipline)
- **Founder content cadence** (already a draft S1.B gate): PH-personal-finance niche content — TikTok/FB Reels/YouTube Shorts on "safe-to-spend" budgeting for thin margins. PH is one of the highest social-media-usage markets globally; this is the natural organic channel.
- **Referral mechanics upgrade:** beyond passive invites — instrument the invite chain (F-014 `InviteChainEvent` already models this) and test incentivized referral (free Pro month for both sides, OTP credit grants). Measure the resulting growth coefficient.
- **Community seeding:** PH personal-finance FB groups, r/phinvest, local Discords. High-trust, low-cost, but labor-intensive (founder-time bottleneck).
- **SEO long-tail** (T16 work already in flight): "magkano safe to spend," peso-budgeting queries.

### 6.2 Growth magnification (evaluate at S1.C when there's something to magnify)
- **Viral loop tuning:** what makes a budgeting win *shareable*? A "safe-to-spend" screenshot card, a savings-goal-hit moment. Design for organic share artifacts.
- **Micro-influencer barter** (PH "finfluencers"): product access in exchange for content — cash-light, fits burn discipline.
- **Partnership distribution:** e-wallet ecosystems (GCash/Maya mini-app surfaces), local fintech cross-promotion, sari-sari/OFW community orgs.
- **Paid acquisition (currently ruled out):** flag for *explicit re-evaluation* at S1.C. A small test budget against measured LTV could be rational once conversion + retention data exists — but only if unit economics clear CAC. Do not commit pre-data.

### 6.3 Research deliverable
A scoped `distribution-channel-research/` extension (already draft) should produce: channel × CAC × expected-conversion matrix, ranked by cash-light-fit, with a go/no-go per channel keyed to the Dec 31 usage data.

---

## 7. Monetization Model Research — OTP vs Subscription

> **High-priority research note.** The default Western SaaS subscription model may be a poor fit for the PH market. This deserves real study before S1.C pricing goes live.

### 7.1 The PH prepaid-culture thesis
PH is a **structurally prepaid market** — mobile load, GCash/Maya top-ups, pay-as-you-go norms dominate. Recurring-subscription commitment carries higher psychological friction here than in subscription-saturated Western markets. **Hypothesis: a one-time payment (OTP) or credit/PAYG model may out-convert a ₱249/mo subscription in this specific audience**, even at lower lifetime value, because it removes recurring-commitment anxiety and matches cultural payment norms.

### 7.2 Trade-off frame
| Model | Pros | Cons |
|---|---|---|
| **Subscription** (₱249/mo) | Predictable MRR; higher LTV; standard valuation story | High friction in prepaid/low-WTP market; churn risk; subscription fatigue |
| **OTP / lifetime** (₱999–1,499) | Matches prepaid culture; removes commitment anxiety; higher conversion likely; **Founding SKU already is this** | Lower LTV; no recurring revenue; one-shot — must re-sell for new revenue |
| **PAYG / credits** (₱99/100 — already live) | Lowest entry friction; aligns with load-top-up behavior; pay-for-value | Revenue lumpiness; harder to forecast; may under-monetize heavy users |
| **Hybrid** | OTP/lifetime entry + optional AI credits (PAYG) + subscription for power users | Complexity; messaging clarity risk |

### 7.3 Research deliverable
- A/B or cohort test of OTP vs subscription conversion **once user base supports a test** (need ~hundreds of users for signal).
- Model **blended LTV** under each: e.g. is 1 OTP at ₱999 worth more or less than expected-subscription-lifetime at ₱249/mo × expected-months-retained? At PH churn risk, expected subscription lifetime may be short enough that OTP wins on *realized* revenue.
- The existing **Founding lifetime SKU (₱999–1,499)** is already an OTP instrument — its take-up vs Pro subscription take-up will be the first natural data point. **Instrument and watch this.**

---

## 8. Platform Distribution Research — Play Pass / Bundled Pickup

> **Speculative but worth a research note.** Could a platform bundle (Google Play Pass or similar) monetize users who would *never* pay directly?

### 8.1 The thesis
Google Play Pass (and analogues) bundle apps into a single user subscription; Google pays developers from a pool based on **engagement metrics**, not per-user purchase. For a **thin-margin PH audience that won't pay ₱249/mo directly, Play Pass could monetize them anyway — Google fronts the cost, the user pays nothing extra, and the developer earns on engagement.** This directly attacks the §5.1 low-WTP problem by decoupling the user's willingness-to-pay from the developer's revenue.

### 8.2 Feasibility considerations (research, not conclusions)
- **Curation, not application:** Play Pass is curated/invite-driven — you don't simply opt in. Historically games-heavy but includes utility apps. Inclusion likelihood for a niche PH PFM app is **uncertain and probably low early on.**
- **PH market availability:** confirm Play Pass is even available/meaningful in the PH market — its footprint is uneven by geography. **This may be a non-starter for a PH-first product.**
- **Android dependency:** requires a mature Android app. Currently `android:Scaffold` — Alpha not started. This is a **hard prerequisite** and pushes any Play Pass play well past S1.C.
- **Revenue shape:** engagement-pooled payout is **less predictable** than direct payments and you lose the direct customer relationship + data. Could pay more or less than direct — unknowable without being in it.
- **Strategic tension:** bundling cedes the relationship and the pricing power that the privacy/premium positioning is built on. May conflict with the ZK/premium brand thesis (S5).

### 8.3 Revenue feasibility vs raw payments — open question
The core research question: **for the specific thin-margin PH cohort, is expected engagement-pool revenue per user > expected direct-payment revenue per user (accounting for the low conversion rate)?** If direct conversion is ~1.5%, then 98.5% of users monetize at ₱0 — a bundle that pays *anything* on the other 98.5% could plausibly beat raw payments in aggregate. **This is a genuine open question worth modeling once usage/engagement data exists (F-014 provides the engagement signal).**

### 8.4 Research deliverable
- Confirm Play Pass PH availability + app-category eligibility (kill-fast check).
- If viable: model engagement-pool revenue vs direct-payment revenue at realistic conversion rates.
- Sequence behind Android Alpha — **not actionable until Android matures**, so this is an S2+ research item, flagged now so it's on the radar.

---

## 9. Candid Bottom Line

Most likely realistic outcome: **a self-sustaining product that covers its own costs and throws off modest side income (₱5–40k/mo), reached around 2028.** That's the ~50% center of mass.

The **₱100k/mo founder-replacing target is real but low-probability (~5%)** at baseline — not because the product is weak, but because the math requires growth volume that organic-only acquisition in a low-WTP market rarely produces. To make that tier *likely* rather than a long shot, **something has to change the model**: either monetization (§7 OTP fit, §8 platform bundling, or the §S6 B2B sari-sari vertical with better unit economics than thin-margin consumers), or acquisition (§6 a channel that compounds faster than invites).

The structural thing done right: **near-zero burn buys nearly unlimited time to find that answer.** Watch your own bandwidth and the Dec 31 usage data — compounding vs trickle — not the P&L.

---

## 10. Re-Score Worksheet (fill at Dec 31 2026)

| Metric | Baseline (2026-06) | Dec 31 actual | Δ |
|---|---|---|---|
| Active free users | single digits | | |
| Paying users | 0 | | |
| Net MRR | ₱0 | | |
| Invite growth coefficient (new users per user) | unknown | | |
| Founding (OTP) vs Pro (sub) take-up ratio | n/a | | |
| Prob. band shift (death / hobby / side / founder-replacing) | 45/30/15/6 (midpoints) | | |
| Decision: begin monetization infra? | deferred | | |
