# Phase S2: PH Vertical Hardening

## Objective

Take a wedge that has been validated by S1 retention and **build the PH-vertical-specific moat** around it: GCash/Maya ingestion (free for PH), AI-assisted planning tier (paid), and the Reflex→JS pivot to lift the polish bar.

This is the phase where the product becomes structurally hard to copy without local PH presence and where the AI-credits monetization model proves itself.

## Entry Criteria

- S1 exit met (per `validation_gates.md` S1 exit triggers).
- S2-specific feature list capped to: GCash/Maya ingestion, AI tier MVP, JS pivot kickoff. Anything else is rejected.
- AI cost cap model from `01_unit_economics_and_costs.md` §3 validated against current LLM pricing.

## Exit Criteria (all required)

- GCash/Maya ingestion live and accurate (≥95% test transactions correctly parsed).
- AI tier MVP live with ≥3 paid Pro+ AI subscribers.
- ≥30 paying users total.
- JS pivot at "feature parity demo" milestone OR explicitly deferred to S3 with documented reason.

## Workstreams

### 1. GCash/Maya Ingestion (P0)

- [ ] Decide ingestion source: SMS parsing, email parsing, manual CSV import, screenshot OCR. Most likely combo: CSV-friendly export workflow + SMS parsing on Android (S3).
- [ ] Implement parser per chosen source with high test coverage (sample real transactions).
- [ ] IP + user-declared region gating to make GCash/Maya feature visible only to PH users.
- [ ] Privacy review: no GCash/Maya credentials handled by PFM. Owner does not become a money-services entity.
- [ ] Edge cases: failed parses, deduplication, transaction reversals, ambiguous merchant names.

### 2. AI Planning Tier (P0)

- [ ] Tier structure live per `01_unit_economics_and_costs.md` §2: Pro+ AI, AI Credits PAYG.
- [ ] Per-user AI cost cap enforcement at API gateway (not in model call).
- [ ] Model tier rotation: small for free, mid for Pro, mid+large for Pro+ AI planning sessions.
- [ ] Caching: merchant→category cache (forever), recurring-prediction cache (24h), safe-to-spend forecast cache (1h).
- [ ] Batched weekly digest job (off-peak hours) instead of per-action calls where possible.
- [ ] Free-tier 10-prompts/mo limit enforced; throttle + top-up offer when exceeded.
- [ ] System-level monthly cap monitor + auto-trigger from `kill_commit_gates.md` §7.

### 3. Reflex → JS Pivot (P0–P1)

Decision to fully pivot or partially pivot is itself a workstream item.

- [ ] Choose target: Next.js + TypeScript, SvelteKit, or Astro+islands. Anchor decision in: hireability, AI agent productivity (current LLMs strongest at React/Next.js), polish ceiling.
- [ ] Spike: build one screen (probably the dashboard with safe-to-spend KPI) in chosen stack. Compare side-by-side with Reflex equivalent.
- [ ] Decision: full pivot vs hybrid (Reflex for admin/internal, JS for marketing/dashboard).
- [ ] Migration plan: API contract is unchanged. JS frontend re-implements against same OpenAPI surface.
- [ ] Sequencing: marketing pages → public dashboard → authenticated dashboard → settings → onboarding.

### 4. Pricing & Billing Hardening (P1)

- [ ] Annual plan auto-renew with reminder.
- [ ] Pro+ AI tier billing reconciliation including credit pack upgrades.
- [ ] PH payment alternatives evaluated (Xendit, PayMongo, GCash direct) — Stripe-only may be friction for PH users.
- [ ] Family-share plan (up to 3 members) — operationalized.

### 5. Retention Investment (P1)

- [ ] Day-7 onboarding email/notification series.
- [ ] Weekly digest "smart predictions" (uses cached batch job).
- [ ] Re-engagement flow for users who lapse at day-30.
- [ ] In-app "what's safe to spend this week?" notification (push for mobile, email for web).

### 6. Distribution Scaling (P0–P1, sustained)

- [ ] PH micro-influencer outreach: identify ≥10 PH personal-finance creators on TikTok/YouTube. Co-marketing pitches, not paid placements.
- [ ] Affiliate program (PH micro-influencer-friendly): 30% revenue share for first 3 months of referred user.
- [ ] Founder content cadence increased: ≥2 PH-local touchpoints per week.
- [ ] First long-form content piece: blog post or YouTube short on "how safe-to-spend math actually works" — timeless, SEO-friendly, persona-honest.

### 7. Mobile Architecture Design (P1, gates S3)

- [ ] Sync architecture document drafted (does not require implementation in S2).
- [ ] SQLite schema design for offline-first.
- [ ] Conflict resolution rules drafted.
- [ ] Battery/data budget research for PH context.

### 8. Documentation Sync (P1, at exit)

- [ ] Update `design_docs/api_docs/` with GCash/Maya ingestion contracts.
- [ ] Update `design_docs/reflex_docs/` (or create `design_docs/web_docs/` if pivot complete) with new frontend architecture.
- [ ] Update `design_docs/20_Roadmap/` to reflect S2 outcomes.

## Constraints

- **AI cost cap is non-negotiable.** Free-tier LLM cost ≤30% of paid MRR.
- **JS pivot may slip to S3 if AI tier or GCash/Maya are at risk.** Document the deferral; do not suppress it.
- **No new product personas in S2.** Wedge stays as written.
- **Owner velocity assumption:** still post-baby (≤6 months). Continue reduced-scope cadence assumption.

## Risks and Mitigations

| Risk | Mitigation |
|---|---|
| LLM costs exceed cap with growing free users | Auto-trigger halves prompts per `kill_commit_gates.md` §7. |
| GCash/Maya parsing is unreliable, damages user trust | Privacy-respecting opt-in; clear "verify with bank" disclaimer; feedback path for parse errors. |
| JS pivot drains S2 velocity | Time-box spike; allow deferral to S3. |
| Pro+ AI tier doesn't convert | Re-evaluate AI features against actual user requests; reposition AI value prop if needed. |
| Distribution doesn't scale beyond owner posting | Introduce micro-influencer affiliate; slow founder pace if exhaustion shows. |

## Verification Gate

Per `validation_gates.md` Phase S2 exit triggers.

## Definition of Done for Phase S2

- All exit triggers met.
- AI cost discipline auto-triggers have not fired more than once during the phase.
- PH-local distribution shows ≥20% of new users from non-direct channels.
- S3 entry decision recorded in `kill_commit_gates.md` outcomes log.
