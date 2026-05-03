# Credit floor (₱99→100), subscription parity, founder Pro vs Pro+ — revenue vs COGS per credit

**Purpose:** Hard numbers for **discount design**: what **one wallet credit** earns (net) at the **PAYG floor**, what it **costs** under the **BC ledger** (1× = mini Short‑S baseline), and how **included subscription credits** compare. Scenarios: **founder maps to Pro** (100 credits/mo) vs **founder maps to Pro+** (**250** credits/mo — **cut from 500** for subscription margin headroom).

**Not legal/accounting advice:** API-only variable cost; excludes full PSP nuance beyond **0.85 net placeholder**, infrastructure, support, taxes.

**Locked assumptions (same as sibling docs — refresh often):**


| Assumption                                  | Value                                                                                                                                                                   |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| FX                                          | **₱56 = $1**                                                                                                                                                            |
| Net after processor                         | **gross PHP × 0.85** (placeholder until MDR locked)                                                                                                                     |
| **1 wallet credit**                         | Ledger **1.0× debit** = **one GPT‑5.4 mini Short‑S** completion ≈ **$0.00375** API COGS                                                                                 |
| **Sonnet Short‑S**                          | **~3.6× debits** same shape (or **~$0.0135** API per full Sonnet completion)                                                                                            |
| **Reference blend** (finance forecast only) | **85% mini / 15% Sonnet** on Short‑S → **~$0.00521** **expected API per 1.0× debit drawn** from mix *or* **E[debits]×0.00375** — here **~1.39× effective** vs pure mini |
| **Gating**                                  | **Free:** mini-only, **no T2+**; **Pro:** T2+ with **scaled debits** (`AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md` **§2.5**)                                        |


---

## 1) PAYG floor — canonical **₱99 → 100 credits** (discount anchor)


| Metric                     | Per **wallet credit** (100-pack) |
| -------------------------- | -------------------------------- |
| List PHP                   | **₱0.99** (= 99/100)             |
| Gross USD                  | **~$0.0177** (= 0.99/56)         |
| **Net USD** (×0.85 on PHP) | **~$0.0150**                     |


**Variable API COGS** depends on **how credits are spent** (debit multipliers), not on pack list price:


| Redemption pattern                          | API COGS **per wallet-credit sold** (approx.)                         | **Net − API** per wallet-credit (USD) | Notes                                                              |
| ------------------------------------------- | --------------------------------------------------------------------- | ------------------------------------- | ------------------------------------------------------------------ |
| **Only 1.0× mini** debits                   | **$0.00375**                                                          | **~$0.0113**                          | Free-tier paths; idealized “all mini”                              |
| **E ~1.39×** (85/15 Short‑S blend on spend) | **~$0.00521**                                                         | **~$0.0098**                          | Pro-typical **forecast**                                           |
| **Only 3.6× (Sonnet Short‑S)** per turn     | **User burns 3.6 credits/turn** — **not** $0.0135 per credit **sold** | —                                     | **$0.0135 API per Sonnet completion** = **3.6 credits** off wallet |


**Rule:** A **discount** on the **pack** is safe on the **API line** while **(net $ per wallet-credit sold) > (expected API $ per wallet-credit redeemed)** for the **mix you’re discounting to** (e.g. founders only Pro-gated → closer to **1.0–1.4×** than **3.6×**).

---

## 2) “What does a credit cost us?” — summary row


| Cost concept                                                          | USD (API variable)             |
| --------------------------------------------------------------------- | ------------------------------ |
| **Marginal COGS, 1.0× debit** (mini Short‑S)                          | **$0.00375**                   |
| **Marginal COGS, one Sonnet Short‑S completion**                      | **~$0.0135** (= 3.6 × 0.00375) |
| **Expected COGS per wallet-credit *redeemed*** at **1.39× effective** | **~$0.00521**                  |


---

## 3) Subscription **included credits** (**10 / 100 / 250**)

Tier copy is **credits/month** at **baseline wallet units** (1× = mini Short‑S debit). Stronger routes **consume more credits** before balance hits zero.

### 3.1 PAYG **value floor** vs **included allowance** (parity story)

Retail says **₱99 buys 100 credits** → **₱0.99/credit** list.


| Tier    | Included credits/mo | **Implied retail parity** of AI bucket alone (floor) |
| ------- | ------------------- | ---------------------------------------------------- |
| Free    | **10**              | **~₱9.90**/mo equivalent at PAYG list                |
| Pro     | **100**             | **~₱99**/mo equivalent                               |
| Pro+ AI | **250**             | **~₱248**/mo equivalent                              |


Full subscription price covers **much more than AI**; this row is **“if they bought credits at the shelf PAYG rate.”**

### 3.2 Pro subscription — net $/month and **included credits** economics (illustrative Pro prices)

**Net subscription $/mo** = `PHP × 0.85 / 56`.


| Pro list ₱/mo | Net $/mo (sub total) | **100 credits/month**                                                                     |
| ------------- | -------------------- | ----------------------------------------------------------------------------------------- |
| 149           | 2.26                 | If API **full 1× mini** ceiling: **100×0.00375 = $0.375** ⇒ **~16.6%** of net to API-only |
| 199           | 3.02                 | Same API floor **$0.375** ⇒ **~12.4%**                                                    |
| **249** (locked 2026-05-01) | **~3.78**            | Same API floor **$0.375** ⇒ **~9.9%**                                                     |


At **forecast blend ~$0.00521 per credit-month** (if every included credit were drawn at that intensity — **overstatement** if many users under-use):


| Pro ₱/mo | Net $/mo | API **~1.39×** on 100 credits |
| -------- | -------- | ----------------------------- |
| 149      | 2.26     | **~$0.521** ⇒ **~23%** of net |
| 199      | 3.02     | **~$0.521** ⇒ **~17%**        |
| **249**    | **~3.78** | **~$0.521** ⇒ **~14%**        |


### 3.3 Pro+ **₱349** — **250 credits/mo**


|                               |                                         |
| ----------------------------- | --------------------------------------- |
| Net $/mo (sub)                | **~$5.30**                              |
| API if **250 × 1× mini**      | **~$0.94** ⇒ **~18%** of net (API-only) |
| API if **250 × ~1.39× blend** | **~$1.30** ⇒ **~25%** of net            |


**Sonnet-heavy** Pro+ still dangerous without **routing + debit bands** — see `LLM_PROVIDER_COST_SNAPSHOT.md` §6–7. **Cutting 500→250** halves the **best-case blended** AI load vs the old illustration.

---

## 4) Founder positioning — **Pro (100 credits)** vs **Pro+ (250 credits)**

Assume **lifetime** founder gets **monthly included bucket** equal to active tier (until you lock a different rule in Appendix A Q14–Q16).


| Path                | Included AI / mo | **API $/mo** @ **1.39×** on full draw | **API $/mo** @ **1× mini** full draw |
| ------------------- | ---------------- | ------------------------------------- | ------------------------------------ |
| **Founder-as-Pro**  | **100 credits**  | **~$0.52**                            | **~$0.38**                           |
| **Founder-as-Pro+** | **250 credits**  | **~$1.30**                            | **~$0.94**                           |


**Ratio:** Pro+ path is **~2.5×** the Pro **bucket** (and **~2.5×** variable LLM at same debit intensity) vs **100** credits—not **~5×** as under the retired **500** allowance.

**One-time cash (illustrative):** ₱999 net ~~**$15.2**. Even **two years** of **Pro-path** inference at **~~$0.52/mo** ≈ **$12.5** API-only — **ordering comparison only** (does not allocate ₱999 to AI alone or cover non-AI infra).

---

## 5) Founder **credit-pack discount** — breakeven on **API-only** marginal pack

Selling **additional** discounted credits beyond included allowance:

- Let **r** = your **discount vs PAYG list** per credit (**0 ≤ r ≤ 1**).
- **Net $/wallet-credit** ≈ **0.01503 × (1 − r)**.
- Set **≥ expected API $/credit redeemed** for the founder cohort mix **m**:

`0.01503 × (1 − r) ≥ m × 0.00375`  

→ `(1 − r) ≥ (m × 0.00375) / 0.01503`


| Expected **effective debit multiplier** `m` on discounted spend | Max **r** before API-only marginal loss (pure math) |
| --------------------------------------------------------------- | --------------------------------------------------- |
| **1.0** (mini-only)                                             | **r ≤ ~75%** off PAYG net/credit                    |
| **1.39** (blend)                                                | **r ≤ ~65%**                                        |
| **2.0**                                                         | **r ≤ ~50%**                                        |
| **3.0**                                                         | **r ≤ ~25%**                                        |


**Interpretation:** **50% off** PAYG-equivalent is still **API-positive** for **Pro-gated** usage around **~1.4–1.5×** effective intensity; it **fails** if discounted users spend at **~3×+** effective without raising price.

Always recompute with **real PSP net** (replace **0.01503**) and **measured m** (`01_unit_economics_and_costs.md` §3.4).

---

## 6) Cross-links

- Debit policy & PAYG SKU: `AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md` **§2.5**, **§8**
- Vendor rates snapshot: `LLM_PROVIDER_COST_SNAPSHOT.md`
- Strategic tier table (credits wording): `01_unit_economics_and_costs.md` §2, §3.1