---

plan_id: PLAN_RESEARCH_AI_ECONOMICS_2026-04-30
status: shelved
priority: P0
created: 2026-04-30
updated: 2026-05-01
owner: pproctor

plan_root: plans/S1/S1.B/ai-economics-deep-dive/
intended_branch: cursor/s1b/ai-economics-deep-dive
parent_plan: plans/S1/S1.B/
target_repos: []

strategic_phase: S1
strategic_link: plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on:

- PLAN_RESEARCH_ENTITY_FORMATION_2026-04-30
- PLAN_RESEARCH_PAYMENT_PROVIDER_2026-04-30

blocks: []
parallel_safe_with:

- PLAN_RESEARCH_DISTRIBUTION_CHANNEL_2026-04-30
conflicts_with: []

slack_gates:
  pre_execution: required
  pre_merge: none
  pre_close: required

deployment:
  required: false

## standalone: true

standalone_notes: "Shelved 2026-05-01: resume after entity formation + payment provider decisions so PSP net, bundle economics, and cross-tree locks can close Appendix A without rework."

# S1.B Sub-Plan — AI Economics Deep-Dive

## Status — shelved (2026-05-01)

**Execution paused** until **`entity-formation-research/`** and **`payment-provider-research/`** advance (interconnected: real **MDR**, wallet rails, volume PAYG SKUs in `PAYG_VOLUME_BUNDLES_RESEARCH.md`, gate indexing). **Already landed** and **not** waiting on this plan: **§2.0 locks** in `01_unit_economics_and_costs.md` (Pro **₱249**, Pro+ **₱349**, credits **10/100/250**, PAYG floor **₱99→100**, **≤100** founding seats), Appendix A snapshot refresh, forecast + bundle research artifacts under this folder.

**S1.B exit** still requires **Appendix A / 16-question closure** before S1.C — this shelf defers **remaining** open rows, not a repeal of the gate.

## 0) Strategic Inheritance

- **Wedge respected:** yes — AI tier is the upsell that makes Pro+ subscriptions worth paying for; AI cost discipline keeps free tier sustainable.
- **Locked decisions touched:**
  - `00_strategic_context.md` §3.5 (AI Credits Model; tier ships at S1.C tentative)
  - `00_strategic_context.md` §3.11 (Lifetime Founding Beta definition; AI gating + discounts)
  - `01_unit_economics_and_costs.md` §3 (AI Cost Cap Model)
- **Cost cap impact:** entire purpose of this plan is to validate cost cap assumptions before AI tier launches.
- **Validation gates affected:** S1.B exit requires this deep-dive complete; S1.C entry requires AI tier final commitment.

## 1) Objective

Resolve the 16 interlocking AI-economics decisions captured at huddle Topic 4 Q4 (full list in `phases/S1_public_beta_position.md` Appendix A). Output: HitM-locked answers with documented rationale and unit-economic projections.

## 2) Scope

### In scope (the 16 questions per Appendix A)

- LLM provider + model selection per tier.
- Per-prompt cost estimates per workload.
- Caching effectiveness ceiling.
- Pro+ AI monthly price (₱349 holds or revise).
- Founder credit-pack discount structure.
- Free tier prompt limit (10/mo holds or revise).
- Hard cap before throttle.
- Profitability bounds (margin per Pro+ AI sub; free tier subsidy ceiling).
- Founder cumulative inference cost commitment.
- Cap-hit UX (throttle / blocked / upsell).
- Credits-remaining UI visibility.
- Reset cadence (calendar / rolling / anniversary).
- "Lifetime access to all future features" precise definition.
- Founder credit-pack gating.
- Founder monthly allocation exhaustion behavior.

### Out of scope

- Actual AI implementation (S1.C feature work).
- Founder marketing copy (S1.D outreach).

## 3) Source Evidence

- `01_unit_economics_and_costs.md` §3 (current AI Cost Cap Model).
- `phases/S1_public_beta_position.md` Appendix A (16 questions detailed).
- LLM provider pricing (Anthropic, OpenAI, local Llama via Ollama for self-hosted option).
- Cursor's AI tier model as comparable (HitM has direct experience).
- **Working cost snapshot (refresh rates often):** `LLM_PROVIDER_COST_SNAPSHOT.md` — full-bucket prompt usage vs **₱ list** and **~net after 0.85**; % of subscription eaten by API at **Short** vs **Long** token assumptions; ties to Appendix A **Q2/Q8**.
- **Metering + model routing + Pro benchmarks:** `AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md` — BC ledger, **T2+ gating**, canonical **₱99 → 100 credits**, **₱149 / ₱200 / ₱250**, telemetry (Appendix A **Q4–Q8** adjacent).
- **PAYG floor vs sub vs founder discount breakeven:** `CREDIT_FLOOR_SUBSCRIPTION_AND_FOUNDER_MATH.md` — **net $/credit**, **COGS/credit**, Pro **100** vs Pro+ **250**, max discount vs API at spend mix (**Q5/Q10 adjacent**).
- **PHP MRR + PAYG mix + churn vs ₱7k / ₱200k benchmarks:** `FOUNDER_AND_MRR_PATH_FORECAST_PHP.md` — Pro **₱249**, Pro+ **₱349**, PAYG **₱99**, 100 founders one-time envelope, optional **10% paid / 10% Pro+ among paid** funnel vs **U**, churn **`a = c × N`**, launch analytics §8.
- **PAYG volume bundles (discount depth, larger packs, founder stack):** `PAYG_VOLUME_BUNDLES_RESEARCH.md` — baseline **₱99→100** locked; optional SKUs **not** locked until PSP + telemetry.

## 4) Deliverables

A research document with:

- Per-question answer with reasoning (may incorporate or supersede spreadsheet rows in `LLM_PROVIDER_COST_SNAPSHOT.md`).
- Updated Pro+ AI pricing if revised from ₱349.
- Updated free-tier prompt limit if revised from 10/mo.
- Founder lifetime-access definition (likely "Pro tier + Pro+ AI features + 50% PAYG discount on credits").
- Founder credit-pack mechanics decision.
- HitM final signoff.

## 5) Verification Gates

- All 16 questions have a documented answer.
- HitM has signed off.
- Migration to `01_unit_economics_and_costs.md` §3 + §2 complete.

## 6) Documentation Sync Required

- `01_unit_economics_and_costs.md` §2 (pricing tiers) updated with revised AI pricing if any.
- `01_unit_economics_and_costs.md` §3 (AI cost cap model) updated with locked tier limits.
- `00_strategic_context.md` §3.5 updated to remove "tentative" qualifier on AI tier S1.C timing.
- `00_strategic_context.md` §3.11 updated with locked Founding Beta lifetime definition.

## 7) Strategic Phase Impact

- S1.B exit: AI economics deep-dive complete ✅
- S1.C entry: AI tier final commitment locked → either ships in S1.C (Q4 Option (b)) or slips to S2 (Q4 Option (a) fallback).

## 8) Risks


| Risk                                                                        | Trigger                                                      | Mitigation                                                       |
| --------------------------------------------------------------------------- | ------------------------------------------------------------ | ---------------------------------------------------------------- |
| Cost analysis shows AI tier unprofitable at PH pricing                      | Math doesn't work                                            | Slip AI to S2 per Q4 fallback; revise Founding Beta value prop   |
| Lifetime founder + AI commitment is too generous; long-tail cost concerning | Math shows founders cost $X over lifetime > one-time payment | Revise founder lifetime definition (the Q4 pushback alternative) |
| Self-hosted Llama option viable but too operational                         | HitM doesn't have bandwidth to run own GPU/inference         | Default to managed Anthropic/OpenAI                              |


## Estimated Effort

HitM: 6–10 hours.
Agent: 6–10 hours research + cost modeling + spreadsheet build.