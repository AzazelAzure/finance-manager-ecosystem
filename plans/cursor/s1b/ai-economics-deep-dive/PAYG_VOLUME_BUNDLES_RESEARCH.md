# PAYG volume bundles — research (baseline floor is locked)

**Status:** **Research / decision pending.** The **price floor** SKU is **locked**: **₱99 → 100 credits** (~**₱0.99/credit** list) per `01_unit_economics_and_costs.md` §2 (2026-05-01). This note explores **larger packs** and **how deep a volume discount** can go before **API + PSP** eat the business.

**Companion math:** `CREDIT_FLOOR_SUBSCRIPTION_AND_FOUNDER_MATH.md` (net $/credit at floor), `AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md` §8 (baseline pack).

---

## 1) Why consider larger bundles?

- **Lower PSP friction per credit** if fixed fees exist (depends on provider — model explicitly when PayMongo/Xendit MDR is locked).
- **Whale / power-user** convenience (fewer checkout events).
- **Marketing:** “best value” anchor without changing the **mental ₱1 ≈ 1 credit** story if copy stays disciplined.

**Risks:** Deep per-credit discounts **compress margin** on the same **ledger debits** as the baseline pack. A **500-credit** pack at “20% off” per credit is only safe if **redemption `m`** stays in the band you modeled for discounts.

---

## 2) Baseline reference (locked floor)

| Pack | Credits | List ₱ | ₱/credit (list) |
|------|--------:|-------:|----------------:|
| **Baseline** | **100** | **99** | **0.99** |

**Net $ per credit sold** (placeholder **×0.85** on PHP, **₱56/$**), before variable API:

\[
\text{netUSD/credit} \approx \frac{\text{pack\_gross\_PHP} \times 0.85}{56 \times \text{credits}}.
\]

For **₱99 / 100**: **~$0.0150** net USD per credit sold (matches CREDIT-FLOOR §1 table).

**Expected API $ per credit redeemed** (forecast, not ledger law): **~$0.00521** at **~1.39×** effective intensity; **$0.00375** if all **1.0× mini**.

---

## 3) Volume SKU examples (illustrative — do not ship without PSP + telemetry)

Assume only **multiplier**: more credits, **same ₱/credit as baseline** (= no volume discount):

| Credits | List ₱ (= 0.99×credits) | Notes |
|--------:|------------------------:|-------|
| 250 | 247.50 | Round in UX to **₱249** or **₱247** — **policy choice** |
| 500 | 495.00 | Round to **₱499** anchor common in retail |

**Volume discount:** reduce **₱/credit** vs **0.99**. Cap discount by comparing **net USD/credit sold** to **expected API USD/credit redeemed** for the **buyer cohort** (Free-heavy vs Pro-heavy purchasers differ).

**Breakeven discipline (API-only, conservative):**

- Require **net USD/credit sold** ≥ **`k` × expected API USD/credit redeemed** for the **minimum `k`** you accept (e.g. **k = 1.2** for headroom vs infra/support).
- **Founder ~50% off PAYG** applies on top of whatever shelf price you set — model **stacked** worst case (founder buys largest pack at deepest volume discount).

---

## 4) Sample “max discount” algebra (placeholder rates)

Let **r** = your allowed **discount vs baseline list** on a **volume** pack, expressed as **effective ₱/credit** = **0.99 × (1 − r)**.

At **₱56/$** and **0.85** net, **net USD/credit** ≈ **0.01503 × (1 − r)** (same as CREDIT-FLOOR’s **0.01503** at **r=0** for the baseline pack shape).

Set **≥ 1.2 × 0.00521** (20% buffer over **1.39×** blend COGS):

\[
(1 - r) \geq \frac{1.2 \times 0.00521}{0.01503} \approx 0.416 \Rightarrow r \lesssim 58\%.
\]

That is **not** a permission to discount **58%** blindly — it ignores **founder stacking**, **Sonnet-heavy tails**, and **non-AI costs**. Use as **order-of-magnitude**: **large volume discounts need small `r` steps** and **measured `m`**.

---

## 5) Decisions to make before listing volume SKUs

1. **PSP:** fixed fee per transaction? If yes, **larger packs** improve **net %** on small-metric checkouts.
2. **Product:** do **Free** users get the same volume SKUs as **Pro** (mini-only burn) — if yes, **safer** volume discount; if **Pro** buys bulk, **tail risk** rises.
3. **Founder:** does **50% off** apply to **all** pack sizes equally? If yes, **do not** deep-discount large packs for non-founders without re-running stacked math.
4. **UX:** keep **₱99 → 100** as the **default** in upgrade paths; volume offers as **secondary** (“power refill”) to avoid confusing the floor anchor.

---

## 6) Outcome

- **Lock:** baseline **₱99 → 100** remains the **floor** and **parity anchor** for subscription vs PAYG parity rows.
- **Open:** optional **bundles** (credits × N, tiered shelf prices); **discount depth** gated on **telemetry `m`** + **real PSP net** + **founder stacking** rules.

**Next:** After first **60–90 days** of top-up telemetry, populate a **recommended SKU grid** (2–3 packs max) with **explicit CM% range** per cohort.
