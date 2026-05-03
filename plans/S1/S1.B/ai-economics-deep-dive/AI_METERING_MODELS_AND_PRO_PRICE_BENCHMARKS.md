# AI metering (prompts vs credits), model suitability, blends, PAYG — and Pro price benchmarks

**Purpose:** Support S1.B decisions on **which models are necessary** per workflow, **credit ledger** semantics, **tiered debit multipliers by model + session**, **pay-tier ceilings** (**Free mini-only** vs **Pro/Pro+**), canonical **₱99 → 100 credit** PAYG, **blend forecasts** vs **ledger truth**, and **₱149 / ₱200 / ₱250** Pro benchmarks. Telemetry hooks: `**01_unit_economics_and_costs.md` §3.4**.

**Companion math:** Token costs and vendor rates align with `LLM_PROVIDER_COST_SNAPSHOT.md` (same **Short S** assumption: **2k in / 500 out** unless stated).

**Constants used below (refresh often):**

- **FX:** ₱56 = $1 (illustrative).
- **PSP shortcut:** net subscription revenue ≈ list × **0.85** until PayMongo/Xendit/Stripe MDR is locked (`payment-provider-research`, `01_unit_economics_and_costs.md` §2).
- **Per-prompt API $ (Short S):** GPT‑5.4 **mini** ≈ **$0.00375**; Claude **Sonnet 4.6** ≈ **$0.0135**; Claude **Haiku 4.5** ≈ **$0.0045** (see snapshot §5).

---

## 1) What is actually necessary — model suitability by use case

PFM workloads are **not** one homogeneous “chatbot.” A practical split:


| Class                             | Examples                                             | Needs “frontier”? | Typical fit                                                                 |
| --------------------------------- | ---------------------------------------------------- | ----------------- | --------------------------------------------------------------------------- |
| **T0 — Classification / tagging** | Merchant → category, recurring guess, anomaly flag   | No                | Cheapest viable model + rules cache                                         |
| **T1 — Short Q&A / coaching**     | “Can I afford X this week?” with small context       | Rarely            | **Mini-class** handles most persuasive copy                                 |
| **T2 — Structured extraction**    | Parse messy memo into fields (still bounded context) | Sometimes         | Mini first; escalate on low confidence                                      |
| **T3 — Planning / narrative**     | Multi-account, horizon goals, scenario tradeoffs     | Often             | Stronger model **or** multi-step pipeline (cheap draft → cheap verify loop) |


**Working hypothesis (for cost discipline):**

- **GPT‑5.4 mini** (or equivalent small commercial model) is **likely sufficient for T1 and much of T2** once prompts are tightened and retrieval is deterministic (dashboard numbers from DB, not model memory).
- **Sonnet-class** should be **opt-in or routed**—e.g. user opens **“Planning session,”** confirms higher cost, or system escalates only when heuristics say context size / task type warrants it.
- **Haiku / mini** distinction: Haiku 4.5 is still cheap; **Haiku 3** is lower $/tok but weaker—use only if QA passes on PH financial wording.

This maps to deep-dive **Appendix A Q1–Q3**: provider + model ladder, cost per workload, cache ceiling—all must be answered **after** product pins T0–T3 flows.

---

## 2) Blended model mixes — cost distributions (why they matter)

A **blend** lets marketing say “smart AI” while **most** completions stay cheap.

**Example blends** (cost is **$/mo** at **100** Short‑S completions, i.e. Pro bucket):


| Mix (each completion drawn i.i.d.) | Formula (per completion)   | 100 completions $/mo |
| ---------------------------------- | -------------------------- | -------------------- |
| **100% mini**                      | × $0.00375                 | **0.375**            |
| **90% mini / 10% Sonnet**          | 0.9×0.00375 + 0.1×0.0135   | **~0.47**            |
| **85% mini / 15% Sonnet**          | 0.85×0.00375 + 0.15×0.0135 | **~0.52**            |
| **100% Sonnet**                    | × $0.0135                  | **1.35**             |


**Pro+ / 250 completions** scales vs Pro (**2.5×** the **100**-credit bucket): 85/15 blend → ~~**$1.30**/mo vs **~~$3.38** all‑Sonnet at full Short quota (see `LLM_PROVIDER_COST_SNAPSHOT.md`).

**How to decide if a blend is “useful”:**

1. **Measure** escalation rate in beta (what % of calls need Sonnet for acceptable quality).
2. **Cap** tail risk: max tokens per tier + hard throttle (`01_unit_economics_and_costs.md` §3.1).
3. **Compare** resulting $/sub to **net PHP** after PSP for each list price (§4 below).

Blends are a **cost distribution** problem: product picks the mix; finance checks **p95** cost, not just average.

Operational note: blends are useful for **forecasting**, but **customer-facing fairness and margin defense** come from **§2.5** (tiered debits)—not from pretending every completion costs the same.

---

## 2.5 Tiered BC debits — pay-tier **ceilings**, **stronger models = more credits**

**Goal:** Keep the **simple storefront** (**₱99 → 100 credits**) while preventing **Silent Sonnet**, **multi-turn bleed**, and **tier arbitrage**. **Credits are ledger units**, not fixed API dollars per click.

### A) Subscription **thresholds** (“what blend is even allowed?”)

Stronger backends are **gated by pay tier**. **Free stays on mini** for every path they’re allowed—so there is **no** Free-tier mix of Haiku vs Sonnet to subsidize.


| Tier        | Model **ceiling** (default policy — tune in S1.B)                                                                                                                          | T2 / T3 access                                     |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| **Free**    | **Mini-only**                                                                                                                                                              | **Blocked** — T2+ routes require **Pro**.          |
| **Pro**     | **Mini default**; **Haiku-class** optional for some T2; **Sonnet** only behind explicit gated flows (`AI planning` entry point, confirmations, or low-confidence escalate) | Yes for T2; T3 constrained or abbreviated vs Pro+. |
| **Pro+ AI** | **Sonnet / long-context** justified for declared planning + predictions                                                                                                    | Full T3 where product allows.                      |


Anything above the tier ceiling should fail at the **gateway with an explicit upgrade (or PAYG)** path—not silent permanent downgrades that erode trust.

### B) **Debit multipliers** (same **wallet credit**, asymmetric burn)

Define **1 credit** = ledger debit equal to **one mini Short‑S** completion (**~0.00375** COGS shorthand). Stronger backends **multiply burn**:


| Debit profile                     | Approx. multiplier vs mini Short‑S                                               | Notes                                                      |
| --------------------------------- | -------------------------------------------------------------------------------- | ---------------------------------------------------------- |
| **Mini Short‑S**                  | **1.0×**                                                                         | Baseline.                                                  |
| **Haiku Short‑S** (~0.0045/query) | **~1.2×**                                                                        | Rounded—recalibrate to rate card.                          |
| **Sonnet Short‑S**                | **~3.6×**                                                                        | 0.0135 ÷ 0.00375.                                          |
| **Long / planning template**      | **≥4×** + **optional turn surcharge**                                            | Use token bands or staged multipliers (`snapshot §7`).     |
| **Multi-turn continuity**         | **+increment per assistant turn** *or* **session token buckets** after `k` turns | Stops “one credit” absorbing a 40-message planning thread. |


**Effect:** Margin stays steady because **premium behavior spends down the wallet faster**—no need for a single hypothetical “85/15 blended dollar” embedded in **every** credit if **observed** escalation is-priced.

Pack **economics planning** (**§8**) can still cite an **expected mix** (“most users hover 70% 1×, 25% ~3×, 5% 8×”) — but **engineering truth** is the **tier + multiplier ledger**.

---

## 3) PAYG top-ups: “prompts” strongly imply **lowest-cost model**

**Canonical SKU:** **₱99 → 100 credits** grants **wallet balance**. **Burn** follows **§2.5** (tier ceiling + multipliers)—**Free purchasers** redeem almost entirely **1.0×** debits (**mini**) because T2+ is blocked; **Pro** purchasers owe **scaled debits** on Sonnet / long flows. Older wording about “budgeting the whole pack on a flat blended BC average” applies only to **rough capacity planning**, not ledger rules (`01_unit_economics_and_costs.md` §2; **§8**).

**Logic:**

- If **1 prompt** is an abstract debit and backend may run **Sonnet**, marginal cost **varies 3–4×** per Short completion—**unbounded** skew vs price.
- For a **prompt-based pack** to have predictable margin, define **standard prompt** as: *“Runs at **[mini or Haiku] default]** with **[token ceiling]** identical to tier default.”*

**Otherwise:** disclose **premium actions** costing extra (see credits, §5) or bleed margin on heavy users.

**Optional rule of thumb:** **PAYG prompt = cheapest production model satisfying T0/T1 QA** unless user explicitly consumes a labeled **“Deep”** interaction.

---

## 4) Prompts vs credits — realistic comparison

### 4.1 Definitions


| Meter       | User sees               | Server debits                                          | Pros                                               | Cons                                                                   |
| ----------- | ----------------------- | ------------------------------------------------------ | -------------------------------------------------- | ---------------------------------------------------------------------- |
| **Prompts** | N “questions” per month | 1 unit per surfaced action (internal model may vary)   | Simple; Cursor-adjacent                            | Hides token + model variance; heavy sessions erode margin if caps weak |
| **Credits** | Balance in **credits**  | Function of **model × tokens** (or tiered multipliers) | Aligns price to COGS; supports fair **escalation** | More UX + billing math; must explain burn rate                         |


### 4.2 Alignment with current roadmap language

- Strategic docs still say **“AI prompts/month”** for **included subscription allowances**; **PAYG** is now **canonical credits** (**₱99 → 100** per `01_unit_economics_and_costs.md` §2)—subscription copy may later align fully to credits.
- **Credit packs** require: API gateway **debit** function + **multiplier table** (mini = 1×, Sonnet = k×, Long = higher).

### 4.3 Converting thinking from prompts → credits (internal accounting)

Pick an internal **baseline unit** (= cheapest standard completion):

- Example: **1 credit** = debit for **one Short‑S completion on mini** (internal COGS baseline **~$0.00375**).

**Multiplier approach** (no user-facing tokens):


| Action / model                                        | Debit (credits)                             | Rationale vs mini Short‑S                                 |
| ----------------------------------------------------- | ------------------------------------------- | --------------------------------------------------------- |
| Mini, Short‑S                                         | **1**                                       | Baseline                                                  |
| Haiku Short‑S                                         | **~1.2**                                    | Order-of-magnitude vs mini; tighten to vendor rates       |
| Sonnet, Short‑S                                       | **~3.6**                                    | 0.0135 ÷ 0.00375                                          |
| Long / “planning” band (Sonnet-heavy)                 | **≥4×–15×** (tiered bands)                  | See `LLM_PROVIDER_COST_SNAPSHOT.md` §7—not one flat debit |
| **+ extra assistant turns** (same session beyond `N`) | **+0.25–1.0** debit / turn (policy example) | Counters endurance chats at fixed 1 credit/turn           |


Then **monthly allowance** is a **credit pool** (e.g. Pro = **100 credits** only if you keep 1:1 with old “100 mini shorts”; or **300–400 credits** if you want the same UX label but subsidize escalation).

### 4.4 How to benchmark vs subscription (determination recipe)

For either meter:

1. **Choose** allowance (prompts **or** credits/month per tier).
2. **Define** routing policy (baseline model, escalate rules, caps).
3. **Estimate distribution** — at minimum **p50 and p95** cost per active user/month from beta logs.
4. **Compute**
  `variable_AI_COGS_usd ≈ Σ (probability × completions × $/completion)`
5. **Compare**
  `**AI_share_list = COGS / (PHP_list / FX)`** and `**AI_share_net = COGS / (PHP_list × net_factor / FX)`**.
6. **Add** PSP and fixed overhead mentally: sustainable if **AI + infra + risk buffer < net sub** for target mix.

**Credit packs (₱99 → 100):** model **effective** withdrawals with **distribution** over multipliers (**§2.5**)—not assuming every completion is **1 debit**.

### 4.5 Recommendation phasing

1. **Ship credits ledger** + **§2.5 tier ceilings + debit multipliers** (Free **mini-only**; Pro/Pro+ wider model access with **scaled burn**).
2. Subscription rows can still display **included “AI allowances”** in familiar language (# prompts) while internals map to **estimated credit pools** aligned to multiplier policy.
3. **Instrument** token + model_id + debit amount per interaction (`01_unit_economics_and_costs.md` §3.4).
4. Surface **“this action costs ~X credits”** UX on heavy flows so power users predict wallet drain.

---

## 5) Pro list price benchmarks — ₱149, ₱200, ₱250

Assumptions: **100** included AI actions/month (Pro); each action = **Short S**; **net** = list × **0.85** ÷ **56** USD.


| Pro list (₱/mo) | List $/mo | Net $/mo (~0.85) |
| --------------- | --------- | ---------------- |
| 149             | 2.66      | 2.26             |
| 200             | 3.57      | 3.04             |
| 250             | 4.46      | 3.79             |


### 5.1 AI cost as % of subscription (Pro, 100 × Short S)


| Pro ₱/mo | 100% mini COGS $ | % of **list** | % of **net** | 100% Sonnet COGS $ | % of **list** (Sonnet) |
| -------- | ---------------- | ------------- | ------------ | ------------------ | ---------------------- |
| 149      | 0.375            | **14.1%**     | **16.6%**    | 1.35               | **50.8%**              |
| 200      | 0.375            | **10.5%**     | **12.4%**    | 1.35               | **37.8%**              |
| 250      | 0.375            | **8.4%**      | **9.9%**     | 1.35               | **30.2%**              |


**85% mini / 15% Sonnet** at 100 completions: **~$0.52/mo**  


| Pro ₱ | % of list | % of net |
| ----- | --------- | -------- |
| 149   | 19.5%     | 23.0%    |
| 200   | 14.6%     | 17.2%    |
| 250   | 11.7%     | 13.8%    |


**Readout:**

- At **mostly mini**, **AI is a small slice** of Pro revenue at ₱149–₱250—**PSP fees** often matter as much once MDR is real.
- At **mostly Sonnet for every tap**, AI **dominates or exceeds** subscription at ₱149—still margin-hostile unless **price rises** or **routing changes**.

### 5.2 Gate / affordability cross-check

- `**validation_gates.md`** paying-user indexing uses anchor **₱199** vs locked Pro (not ₱200 exactly—**₱200** is ~**+0.5%** vs anchor, negligible for gates).
- **₱149** lowers net per sub → **more users** needed for revenue-equivalent exits (already encoded in indexing rule).

### 5.3 Canonical top-up recap (**₱99 → 100 credits**)

See **§8**. **Margins depend on ledger debits**: **Free / mini-heavy** ⇒ **~75%** API-only CM illustrative; **reference 85/15 blend forecast** ⇒ **~65%**; **all-Sonnet stress** ⇒ **~10%**—tiered burn (**§2.5**) aligns realized COGS toward the healthy columns.

---

## 6) Pro+ AI (single reference row)

**₱349** list → **$6.23**; net **~$5.30**. **250 × Short S**:


| Backend           | COGS $/mo | % of list  | % of net   |
| ----------------- | --------- | ---------- | ---------- |
| 100% mini         | ~0.94     | **~15.1%** | **~17.7%** |
| 85/15 mini/Sonnet | ~1.30     | ~20.9%     | ~24.6%     |
| 100% Sonnet       | ~3.38     | **~54.2%** | **~63.8%** |


Heavy **Long** completions (planning) scale worse—see snapshot §7; **routing + caps** are required for ₱349 to remain viable. (**500 → 250** credits restores margin headroom.)

---

## 8) Canonical PAYG — **₱99 → 100 credits** (**tiered debits**, **Free mini-only**, **T2+ Pro-only**)

### 8.0 Retail line + ledger reality


| Field               | Value                                                                                                                           |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **Price**           | **₱99**                                                                                                                         |
| **Credits granted** | **100 wallet units**                                                                                                            |
| **Mental math**     | **~1 peso ≈ 1 credit** (exact list **~₱0.99**/credit before PSP)                                                                |
| **Spend rules**     | **§2.5** applies: **tier ceiling**, then **scaled debits per model/session**—**not** flat “1 completion = 1 credit” everywhere. |


**Why this SKU:** Storefront stays a **single crisp line**. **Margin stability** comes from **debit tiers**: Sonnet ≈ **3.6×** mini Short‑S, **long-planning bands**, **per-turn surcharges**—not from assuming users rarely escalate.

---

### 8.0.1 Forecasting shorthand (finance only): “reference blend”

For **budgeting** spreadsheets you may still assume an **aggregate mix** (e.g. **85/15 mini/Sonnet** on Short‑S) to get **~$0.0052**/expected debit—as in **§2**. Treat as **forecast**, never as **immutable ledger law**. When telemetry lands, swap in **histogram-weighted** expected cost per wallet debit.

---

**Net revenue (PSP ×0.85 placeholder, ₱56/$)**


| Pack | Gross $ | Net $      |
| ---- | ------- | ---------- |
| ₱99  | ~1.768  | **~1.503** |


**Illustrative API COGS (API-only)—only if literally every debit were 1.0× mini Short‑S**

- **100 × $0.00375 ≈ $0.375** → **~75% CM vs net** (API-only).

**Illustrative—if averaged burn matched old flat “85/15 Short‑S blend” per unit (legacy planning row)**

- **100 × $0.0052125 ≈ $0.521** → **~65% CM vs net** (API-only).

**Stress:** a user who exhausts the pack on **Sonnet Short‑S** only would land **100 × $0.0135 ≈ $1.35** API → **~10% CM vs net** (API-only)—**multipliers + gated planning** prevent that becoming the **modal** story.

---

### 8.1 Product rules (pay tier × model access)


| Rule            | Effect                                                                                                |
| --------------- | ----------------------------------------------------------------------------------------------------- |
| **Free**        | **Mini-only** debits for allowed paths; **T2+ blocked**—no Sonnet escape hatch on Free.               |
| **Pro / Pro+**  | May execute **T2+** where product allows; **each** completion debits per **§2.5** multipliers.        |
| **PAYG wallet** | Same **100** balance string; **who** is spending determines **max model** and thus **debit ceiling**. |


---

### 8.2 Ledger definition (single “credit” unit)

**1 credit** = **1.0× debit** = **one mini Short‑S**-shaped completion **API cost baseline** (~$0.00375). All other routes convert to **fractional or multiple debits** before balance deduct.

There is **no separate “BC vs MMC” product SKU**—only **multipliers** on the same wallet for **Pro-tier** heavy actions.

---

### 8.3 Pack capacity reference (variable—depends on burn mix)

Breakeven on **API-only** vs **~$1.503** net if **every** debit were **1.0× mini**: **$1.503 / $0.00375 ≈ 401** debits.


| If every debit were…               | ~API for 100-grant pack | ~CM% vs net (API-only) |
| ---------------------------------- | ----------------------- | ---------------------- |
| **1.0× mini Short‑S**              | **$0.375**              | **~75%**               |
| **85/15 Short‑S blend** (forecast) | **$0.521**              | **~65%**               |
| **3.6× Sonnet Short‑S** only       | **$1.35**               | **~10%**               |


**Free buyer with pack:** expect distribution near **column 1** (mini-only paths). **Pro buyer:** **column 2–3** unless UX steers them to cheap defaults.

---

### 8.4 Supersedes draft **₱49 / 100 prompts** (`01_unit_economics_and_costs.md` §2)

Early napkin row used ₱49; **canonical floor** SKU is **₱99 → 100 credits** (locked 2026-05-01) with **§2.5 tier ceilings + scaled debits** (plus optional **§8.0.1** blend for finance forecasts). Older math is historical only.

---

### 8.5 Volume bundles (optional SKUs — research, not locked)

**Baseline floor pack stays ₱99 → 100.** Larger packs (e.g. 250 / 500 credits) and **per-credit volume discounts** must clear **PSP fee structure**, **effective debit mix `m`**, and **founder discount stacking** rules before storefront listing. Worked constraints and sample breakeven algebra: `PAYG_VOLUME_BUNDLES_RESEARCH.md`.

---

## 9) Deliverables checklist (for locking S1.C)

- T0–T3 flow list with **default model** + **escalation** criteria.
- **Pay-tier model ceilings** + **debit multiplier table** + **per-turn / long-session** rules (**§2.5**).
- Canonical PAYG floor **₱99 → 100 credits** wired to the same ledger + multipliers; optional volume packs per **§8.5** after economics signoff.
- Pilot **histogram**: tokens/completion + model_id + **debits charged** (p50 / p95).
- Blended **forecast** target (e.g. **85/15**) for capacity planning only; validate against live debit histogram.
- **AI observability pipe** (`01_unit_economics_and_costs.md` §3.4): aggregate/pseudonymous metrics—invocations, **multi-turn session length**, **credits burnt per interaction**, **T0–T3 bucket counts**, top-up attach/burn—not raw chat retention by default.
- **Dynamic pricing playbook:** trigger + owner for revising ₱-per-credit **after** telemetry baseline (still through affordability + gate review).
- Re-run §5–§8 with **locked FX**, **real MDR**, and **measured** $/completion (replace Short‑S assumptions with production p50/p95).