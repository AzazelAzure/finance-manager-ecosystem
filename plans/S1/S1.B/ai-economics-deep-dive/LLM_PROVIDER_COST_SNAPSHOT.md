# LLM provider cost snapshot vs subscription pricing

**Purpose:** Working math for S1.B **AI Economics Deep-Dive** (Appendix A Q1–Q3, Q8). Compare **API inference cost** if a user consumes the **full monthly prompt allowance** to **PHP list price** and illustrative **net after processor**—so you can see **what share of subscription is consumed by LLM spend alone** (before VPS, support, tax, etc.).

**Not a commitment:** Model names, public rates, and FX move. Reconcile before S1.C launch.

---

## 1) Sources and rates used (standard API, not Batch)

Official list pricing (retrieve current numbers before locking):

- **Anthropic:** [Claude API pricing](https://platform.claude.com/docs/en/about-claude/pricing) (per million tokens, USD).
- **OpenAI:** [OpenAI API pricing](https://openai.com/api/pricing/) (per million tokens, USD).

**Snapshot table (this file written 2026-05-01):**


| Provider  | Model (role in this doc) | Input $/MTok | Output $/MTok | Notes                                     |
| --------- | ------------------------ | ------------ | ------------- | ----------------------------------------- |
| Anthropic | Claude Haiku 4.5         | $1.00        | $5.00         | “Small / cheap” tier candidate            |
| Anthropic | Claude Haiku 3           | $0.25        | $1.25         | Lower-cost legacy small model             |
| Anthropic | Claude Sonnet 4.6        | $3.00        | $15.00        | “Mid / smart” tier candidate              |
| Anthropic | Claude Opus 4.6          | $5.00        | $25.00        | “Heavy reasoning” reference (expensive)   |
| OpenAI    | GPT-5.4 mini             | $0.75        | $4.50         | Strong low-cost candidate for high volume |


**Leverage not modeled here (often material):**

- **Prompt caching** (Anthropic/OpenAI): repeated system / context prefixes pay at cache-read fractions.
- **Batch API (~50% off)** where latency allows (digests, backfills).
- **Routing**: cheap model for classify/extract; expensive model only for multi-step planning.

---

## 2) Included allowance (`01_unit_economics_and_costs.md`)


| Tier    | **Credits** / month (wallet **1×** baseline) | Routing (metering §2.5)                                                   |
| ------- | -------------------------------------------- | ------------------------------------------------------------------------- |
| Free    | 10                                           | Mini-only; **no T2+**                                                     |
| Pro     | 100                                          | T2+; scaled debits for stronger routes                                    |
| Pro+ AI | 250                                          | Planning / higher ceilings; strict caps (**cut from 500** for sub margin) |


*Legacy tables in this file still say “completion” — map to **debit multipliers** on those credits.*

---

## 3) Token assumptions per “prompt”

There is **no single answer** until product defines average prompt shapes. Two explicit scenarios:


| Scenario      | Input tokens | Output tokens | Tokens / prompt | Typical use                                               |
| ------------- | ------------ | ------------- | --------------- | --------------------------------------------------------- |
| **S — Short** | 2,000        | 500           | 2,500           | Categorization, short Q&A, one-shot tips                  |
| **L — Long**  | 8,000        | 2,000         | 10,000          | Multi-transaction context, “planning session”, long reply |


**Formula (USD per prompt):**

`cost = (input_tokens / 1e6) × price_in + (output_tokens / 1e6) × price_out`

**Monthly API cost** = `prompts_per_month × cost_per_prompt`.

---

## 4) Subscription reference (illustrative FX)

- **FX:** **₱56 = $1** (placeholder; refresh at pricing lock).
- **List price in USD:** `PHP / 56`.
- **Net after processor (placeholder):** `PHP × 0.85 / 56` (same **0.85** shortcut as unit economics until PSP MDR is real).


| SKU         | PHP / mo | ~List USD/mo | ~Net USD/mo (×0.85) |
| ----------- | -------- | ------------ | ------------------- |
| Pro (floor) | 149      | 2.66         | 2.26                |
| Pro (mid)   | 199      | 3.55         | 3.02                |
| Pro (high)  | 249      | 4.45         | 3.78                |
| Pro+ AI     | 349      | 6.23         | 5.30                |


---

## 5) Full-bucket API cost by tier and model (Short **S** scenario)

All prompts use **S (2k in / 500 out)**; user maxes the tier every month.

### Free — 10 prompts / month


| Model        | $/mo API |
| ------------ | -------- |
| Haiku 3      | 0.01     |
| Haiku 4.5    | 0.05     |
| GPT-5.4 mini | 0.04     |
| Sonnet 4.6   | 0.14     |


### Pro — 100 prompts / month


| Model        | $/mo API |
| ------------ | -------- |
| Haiku 3      | 0.11     |
| Haiku 4.5    | 0.45     |
| GPT-5.4 mini | 0.38     |
| Sonnet 4.6   | 1.35     |
| Opus 4.6     | 2.25     |


### Pro+ AI — 250 prompts / month


| Model        | $/mo API |
| ------------ | -------- |
| Haiku 3      | 0.28     |
| Haiku 4.5    | ~1.13    |
| GPT-5.4 mini | ~0.94    |
| Sonnet 4.6   | ~3.38    |
| Opus 4.6     | ~5.63    |


---

## 6) “AI eats what % of subscription?” — Short **S**, full usage

Percentages use **Pro mid ₱199** and **Pro+ AI ₱349** only; extend mentally for floor/high Pro.

**Definition:** `AI % of list` = `(monthly API $) / (list USD sub $)`.  
**Definition:** `AI % of net` = `(monthly API $) / (net USD sub $ with 0.85)`.

### Pro (100 × **S**), ₱199 list → $3.55 list, $3.02 net


| Model        | $/mo API | % of list | % of net |
| ------------ | -------- | --------- | -------- |
| Haiku 3      | 0.11     | 3.1%      | 3.7%     |
| Haiku 4.5    | 0.45     | 12.7%     | 14.9%    |
| GPT-5.4 mini | 0.38     | 10.7%     | 12.6%    |
| Sonnet 4.6   | 1.35     | 38.0%     | 44.7%    |
| Opus 4.6     | 2.25     | 63.4%     | 74.5%    |


### Pro+ AI (250 × **S**), ₱349 list → $6.23 list, $5.30 net


| Model        | $/mo API | % of list | % of net |
| ------------ | -------- | --------- | -------- |
| Haiku 3      | 0.28     | ~4.5%     | ~5.3%    |
| Haiku 4.5    | ~1.13    | ~18.1%    | ~21.2%   |
| GPT-5.4 mini | ~0.94    | ~15.1%    | ~17.7%   |
| Sonnet 4.6   | ~3.38    | ~54.2%    | ~63.8%   |
| Opus 4.6     | ~5.63    | ~90.4%    | ~106.2%  |


**Readout:** At **full bucket** on **short S** completions, **Opus-class** still **stress-tests** subscription net (**~106%** of net); **Sonnet-all** falls to **~64%** of net (**~half** the old **500**‑credit row’s **~127%**)—routing/caching still mandatory for planning-heavy mixes. **Mini-class** lands **~15–21%** of net (**~half** vs the prior **500** illustration).

---

## 7) Pro+ stress — Long **L** (250 × 10k tokens)

If “planning sessions” dominate and each call looks like **L**:


| Model        | $/mo API (250×L) |
| ------------ | ---------------- |
| Haiku 4.5    | ~4.50            |
| GPT-5.4 mini | ~3.75            |
| Sonnet 4.6   | ~13.50           |
| Opus 4.6     | ~22.50           |


vs Pro+ **$6.23** list → **mini** lands **~60%** of list at **full heavy** draw (**250** calls); Sonnet-heavy still **>** list—**mandatory** mitigations: strict caps, heavy routing to cheaper models, session limits, caching, batch digests—not optional polish.

---

## 8) Free tier quick check (10 × **S**)


| Model      | $/mo API |
| ---------- | -------- |
| Haiku 4.5  | 0.045    |
| Sonnet 4.6 | 0.135    |


At 10k–100k free users, **aggregate** matters (`01_unit_economics_and_costs.md` §3.2 system cap)—per-user negligible if truly capped at 10 prompts and small models.

---

## 9) Alternatives (qualitative)


| Option                       | Economics                                                                                                             | Operational load                     |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| **Self-hosted Llama / vLLM** | Low $/token; GPU/colocation/hosting replaces API                                                                      | Engineering + uptime + model refresh |
| **Bedrock / Vertex Claude**  | Often **≠** 1P API price—compare list for your route                                                                  | Fits AWS/GCP-heavy stacks            |
| **Gemini (Google)**          | Competitive small-model tiers historically; verify [Google AI pricing](https://ai.google.dev/gemini-api/docs/pricing) | Separate integration surface         |


---

## 10) Actions for the deep-dive

1. Replace **S / L** with **measured p50/p95 tokens** from a pilot on real flows (categorize, forecast, planning).
2. Pick **default model per tier** + **escalation** path (e.g. mini → Sonnet only when user opens “planning”).
3. Recompute this table with **locked FX**, **real PSP net %**, and **Batch/caching** factors where applicable.
4. Align with Appendix A: **Q1** provider/model, **Q2** per-workload $, **Q3** cache ceiling, **Q8** margin floor after **both** PSP and LLM.
5. For **metering** (stay on **prompts** vs move to **credits**), **blended mixes**, **PAYG rules**, and **₱149/200/250** benchmarks, use `AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md`.