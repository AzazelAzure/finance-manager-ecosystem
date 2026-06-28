# Forecast: PH MRR benchmarks, PAYG mix, churn, founders (100 seats)

**Purpose:** Scenario math for **gross recurring revenue (PHP/month)** vs **capital benchmarks ₱7,000/mo** and **₱200,000/mo**, using **locked list prices Pro ₱249** and **Pro+ AI ₱349**, **PAYG ₱99 → 100 credits**, **included credits** 10 / 100 / 250, and founders **first 100** as **one-time** cash (not MRR).

**Not accounting/tax advice:** Uses `**gross × 0.85` net-placeholder** until PSP MDR is locked (`CREDIT_FLOOR_SUBSCRIPTION_AND_FOUNDER_MATH.md`).

---

## 1) Assumptions (this forecast)


| Line                      | Value                  | Notes                                                                       |
| ------------------------- | ---------------------- | --------------------------------------------------------------------------- |
| **Pro list**              | **₱249/mo**            | **Strategic lock** (`01_unit_economics_and_costs.md` **§2.0**, 2026-05-01). |
| **Pro+ AI list**          | **₱349/mo**            | Same lock (**§2.0**).                                                       |
| **PAYG pack**             | **₱99** → 100 credits  | Gross per successful pack purchase.                                         |
| **Processor placeholder** | **Net = gross × 0.85** | Same shortcut as unit economics §4.1.                                       |
| **FX (context only)**     | **₱56 = $1**           | For USD overhead comparison.                                                |
| **Founding cohort**       | **100 seats**          | One-time **₱999–₱1,499** gross — midpoint **₱1,249** in §3.                 |


**Founders do not add to MRR** internally (`01_unit_economics_and_costs.md` §7) unless you add a recurring line; they are **capital** + **lifetime entitlement** (see CREDIT-FLOOR §4).

---

## 2) Per-unit recurring revenue

### 2.1 Gross PHP per billed month


| SKU     | Gross ₱ / mo (or per pack) |
| ------- | -------------------------- |
| Pro     | **249**                    |
| Pro+ AI | **349**                    |
| PAYG    | **99** per pack            |


### 2.2 Net PHP (after ×0.85 placeholder)


| SKU       | Net ₱ / mo (or per pack) |
| --------- | ------------------------ |
| Pro       | **211.65**               |
| Pro+      | **296.65**               |
| PAYG pack | **84.15**                |


---

## 3) One-time capital — first **100** founding members


| Seat price (gross ₱) | 100 seats gross | ×0.85 net placeholder |
| -------------------- | --------------- | --------------------- |
| 999                  | **₱99,900**     | **₱84,915**           |
| 1,249 (mid)          | **₱124,900**    | **₱106,165**          |
| 1,499                | **₱149,900**    | **₱127,415**          |


**Order-of-magnitude:** ~~**₱100k–₱150k gross** — multi-year infra breathing room vs **`~~$102–125/mo`** overhead in isolation, **before** lifetime AI burn (priced via strategy + debit discipline).

---

## 4) Recurring benchmarks — **gross PHP / month** (subscriptions + PAYG)

Let **P** = active **Pro** subs, **Q** = **Pro+** subs, **B** = **PAYG packs** sold in the month.

**Gross MRR_proxy** = **249·P + 349·Q + 99·B**

### 4.1 **₱7,000/mo gross** — boundary compositions


| Scenario  | Composition                     | Check                                                                          |
| --------- | ------------------------------- | ------------------------------------------------------------------------------ |
| Pro only  | **P = 29** (integer), Q = B = 0 | 29×249 = **7,221** (28×249 = 6,972 **<** 7k)                                   |
| Pro+ only | **Q = 21**                      | 21×349 = **7,329** (20×349 = 6,980 **<** 7k; exact continuous **≈20.06** subs) |
| PAYG only | **B ≈ 70.71**                   | 7 000÷99                                                                       |
| Mix       | P=10, Q=12, B=0                 | 2 490 + 4 188 = **6,678**; add **B=4** → +396 → **7,074**                      |


**Interpretation:** **₱7k gross/mo** ≈ **$125/mo @ ₱56** — overhead-band check (subscription line only; margin still needs AI + real PSP).

### 4.2 **₱200,000/mo gross** — boundary compositions


| Scenario  | Composition   | Check                                                |
| --------- | ------------- | ---------------------------------------------------- |
| Pro only  | **P = 804**   | 803×249 = 199 947 **<** 200k → **804×249 = 200 196** |
| Pro+ only | **Q = 574**   | 573×349 = 199 977 **<** 200k → **574×349 = 200 326** |
| PAYG only | **B ≈ 2 020** | 200 000÷99                                           |


**Net (×0.85):** ₱200k gross → **~₱170k** placeholder before AI COGS/tax.

**Vs ₱250 Pro hypotheticals:** One peso lower on Pro **raises** integer Pro count needed for the same gross by **~1** at these plateaus — **not** a material panic vs the old **₱250** scratch model.

---

## 5) Funnel hypothesis — **10% subscribed**, **10% of subscribers Pro+**

**Definitions (must match product analytics later):**

- **U** = count of **active users** in period (recommend **MAU** as primary; **DAU** for engagement health).
- **Subscription rate:** **10%** of **U** pay a recurring sub → **paid = 0.10·U**.
- **Tier split among paid:** **10%** Pro+, **90%** Pro →  
**Q = 0.10 × 0.10·U = 0.01·U**, **P = 0.90 × 0.10·U = 0.09·U**.

**Implied gross subscription MRR** (ignores PAYG, founders, annual plans):


\text{MRR}_{\text{sub}} \approx U \cdot (0.09 \times 249 + 0.01 \times 349) = U \cdot 25.90 \text{₱/mo}.



| Total active users **U** | Paid (10%) | Pro (9% of **U**) | Pro+ (1% of **U**) | Gross sub MRR (₱/mo) |
| ------------------------ | ---------- | ----------------- | ------------------ | -------------------- |
| **271** (~ceil for ₱7k)  | 27         | 24.4→24           | 2.71→3             | ~**7.0k** tier       |
| **7,723** (~for ₱200k)   | 772        | 695               | 77                 | ~**200k** tier       |
| **10,000**               | 1 000      | 900               | 100                | **~₱259,000**        |


**Breakpoint back-solve:**

- **₱7,000** gross from subs-only at this funnel: **U ≥ 7000 / 25.90 ≈ 270.3** → **~271 MAU** (with integer rounding on tiers, treat as **order-of-magnitude**).
- **₱200,000:** **U ≥ 7722** → **~7.7k MAU**.

**Is 10% free→paid optimistic or pessimistic?**  
For many consumer freemium apps, **≤5%** paid of MAU is common until retention and wedge are proven; **10%** is **ambitious** — treat as a **working upper hypothesis** until launch telemetry replaces it. If realized conversion is **5%**, double these **U** estimates for the same sub MRR (holding tier split).

**Android:** Larger addressable MAU pool and mobile-native habit loops can **lift U** faster than breakpoints move; breakpoints here are **revenue Algebra**, not a cap on aspiration.

---

## 6) PAYG equivalences (mental model only)

Rough gross equivalence: **one Pro sub ≈ 249/99 ≈ 2.52** PAYG packs/mo on the **storefront line** only.

**PAYG** adds on top of the funnel above; heavy pack buyers **front-load** gross without being in **P** or **Q**.

---

## 7) Churn — steady paid base **N**, replacement **a = c·N**

**c** = monthly churn on **paid** base; **N** = paid count (tier-specific in real ops).

### 7.1 Pro-only sustain (gross ARPU **₱249**)


| Target gross MRR | Paid Pro **N** (all Pro) | New Pro/mo @ **c=3%** | @ **c=5%** | @ **c=7%** |
| ---------------- | ------------------------ | --------------------- | ---------- | ---------- |
| **₱7,000**       | **29** (integer ≥7k)     | **0.87**              | **1.45**   | **2.03**   |
| **₱200,000**     | **804**                  | **24.1**              | **40.2**   | **56.3**   |


**Mean lifetime ≈ 1/c months** (same as prior doc: 5% churn → ~20 mo).

### 7.2 Pro+-only sustain @ **₱349** for **₱200k**

**Q ≈ 574** → new Pro+/mo: **~17 / ~29 / ~40** at **3% / 5% / 7%** churn.

---

## 8) Launch & ongoing analytics (required)

Breakpoints and funnel ratios are **junk without definitions**. Ship or specify **early**:


| Metric                     | Purpose                                                                                                                    |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| **MAU / DAU**              | **U** and engagement; funnel denominator.                                                                                  |
| **Free vs paid**           | Paid = recurring sub active in period (exclude honorary US unless you segment).                                            |
| **Pro vs Pro+**            | Tier ARPU and **Q/P** split.                                                                                               |
| **Founders**               | Segment **out** of “paid MRR” if using `01_unit_economics` §7 recognition; track **lifetime entitlement cost** separately. |
| **PAYG buyers & packs/mo** | Top-up revenue and **burn vs purchase** (`01_unit_economics_and_costs.md` §3.4).                                           |
| **Churn**                  | Cancel / failed renewal by tier (not just aggregate).                                                                      |


Align implementation with `**01_unit_economics_and_costs.md` §3.4** (aggregate/pseudonymous default; no raw chat in analytics pipes unless policy says otherwise).

---

## 9) How founders change the picture

- **MRR rails:** Lifetime founders **≠** monthly bill.  
- **PAYG:** Founder discount band (`S1_public_beta_position.md` Appendix A) lowers gross per founding pack — model separately.  
- **Load:** **100 ×** full **250‑credit** Pro+ bucket API stress **~$94–130/mo** if everyone maxed (unrealistic); real mix lower (`CREDIT_FLOOR_`* §4).

---

## 10) Net vs gross quick map


| Gross goal (₱/mo) | Net placeholder (₱/mo) |
| ----------------- | ---------------------- |
| 7,000             | **5,950**              |
| 200,000           | **170,000**            |


---

## 11) Cross-links

- Tier + credits: `01_unit_economics_and_costs.md` §2, §3.1, §3.4  
- PAYG + parity: `CREDIT_FLOOR_SUBSCRIPTION_AND_FOUNDER_MATH.md`  
- Appendix A: `phases/S1_public_beta_position.md`  
- Gate indexing: `validation_gates.md` (if Pro ASP lock **≠ ₱199** anchor)

---

## 12) Refresh checklist

Recompute when: Pro **≠ ₱249**, Pro+ **≠ ₱349**, PAYG or PSP net changes, funnel **10%/10%** is replaced by measured rates, or founder cohort size/price shifts.

**Updated:** 2026-05-01 — **₱249 / ₱349** baseline; **10%/10%** funnel + **~10k MAU** illustration; instrumentation §8.