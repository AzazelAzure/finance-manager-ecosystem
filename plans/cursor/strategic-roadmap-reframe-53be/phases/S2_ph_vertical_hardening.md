# Phase S2: PH Public Launch + Scaling

**Re-scoped 2026-04-30 post-beta huddle.** Original framing was "PH Vertical Hardening" with three pillars: GCash/Maya, AI tier, JS pivot. The JS pivot landed in S1.A; AI tier launches in S1.C. S2 is now about **active distribution and scaling**.

## Objective

Convert the Founding Beta + Soft Public Open momentum into **active PH market presence**: real distribution effort, content cadence, micro-influencer partnerships, retention investment, and the GCash/Maya direct-integration deepening.

This is the phase where the wedge moves from "validated by 30+ Founding/Soft Public users" to "actively pursued PH market."

## Entry Criteria

- S1.D exit met (≥10 paying PH users active OR ≥50 active free PH users with retention day-30 ≥30%).
- S2-specific feature roadmap drafted (Topic 11 deliverable).
- Velocity controls operational and proven through S1 (Cursor cap discipline; sprint duration minimums; family/health gate functioning).

## Exit Criteria (all required)

- GCash/Maya **direct integration** live and accurate (≥95% test transactions correctly parsed). Not just CSV import — full SMS parsing pipeline (per `_governance/branching_guidelines.md` for multi-repo coordination).
- AI tier mature with ≥10 paid Pro+ AI subscribers.
- ≥100 paying users total.
- Active PH content cadence sustained for ≥3 months (≥2 PH-local touchpoints per week).
- PH-local distribution showing ≥20% of new users from non-direct channels.

## Workstreams

### W1 — GCash/Maya Direct Integration (P0)

S1.B/C had CSV import (free for PH users). S2 brings **full direct integration** — SMS parsing on Android (web continues with CSV).

- [ ] SMS parser per sender (GCash, Maya, BPI, BDO, etc.) — versioned, server-pushed updates.
- [ ] Permissions handling: minimal SMS read scoped to known sender IDs.
- [ ] Privacy guardrails: parsed transaction data lives locally first, syncs only on user opt-in.
- [ ] Edge cases: failed parses, deduplication, transaction reversals, ambiguous merchant names.
- [ ] No GCash/Maya credentials handled by PFM. HitM does not become a money-services entity.

### W2 — AI Tier Maturation (P0)

Pro+ AI shipped in S1.C; S2 deepens.

- [ ] Refine free tier limit based on S1.C usage data (10/mo holds, or adjust).
- [ ] Add "AI planning sessions" feature (named tier upgrade per pricing).
- [ ] Caching effectiveness measured and improved (target: ≥60% prompts cache-served).
- [ ] Per-user AI cost cap holding for ≥95% of paying users.
- [ ] Free tier subsidy ceiling: ≤30% of paid MRR (per `01_unit_economics_and_costs.md` §3.2).

### W3 — Distribution Scaling (P0, sustained)

Founder content cadence established in S1.C; S2 grows it.

- [ ] PH micro-influencer outreach: identify ≥10 PH personal-finance creators on TikTok/YouTube/FB. Co-marketing pitches, not paid placements.
- [ ] Affiliate program (PH-friendly): 30% revenue share for first 3 months of referred user.
- [ ] Founder content cadence increased: ≥2 PH-local touchpoints per week.
- [ ] First long-form content piece: blog post or YouTube short on "how safe-to-spend math actually works" — timeless, persona-honest.
- [ ] PH-local community presence in r/phinvest, OFW FB groups, Filipino freelancer Discord/FB groups, etc. (specific channels per S1.B research output).

### W4 — Pricing & Billing Hardening (P1)

- [ ] Annual plan auto-renew with reminder.
- [ ] Pro+ AI tier billing reconciliation including credit pack upgrades.
- [ ] PH payment alternatives evaluated and live (Xendit, PayMongo, GCash direct) per S1.B research.
- [ ] Family-share plan (up to 3 members) — operationalized.
- [ ] Honorary US Founder asymmetric pricing path live (USD-equivalent if AI tier opens to US per P-6 trigger).

### W5 — Retention Investment (P1)

- [ ] Day-7 onboarding email/notification series.
- [ ] Weekly digest "smart predictions" (uses cached batch job).
- [ ] Re-engagement flow for users who lapse at day-30.
- [ ] In-app "what's safe to spend this week?" notification (push for mobile, email for web).

### W6 — Android Continuity (P1)

Android shipped in S1.B/C. S2 maintains and grows it but doesn't make it primary (S3 does that).

- [ ] Android continues feature parity work; web is still flagship.
- [ ] Crash-free rate ≥99% maintained.
- [ ] Sync reliability validated against expanded scenarios.

### W7 — S3 + S4 Prep (P1)

- [ ] S3 entry (Android scaling): when S2 paying user count + PH-local growth signals readiness.
- [ ] S4 entry (Trust & Reputation): early prep — security baseline, threat model drafting.

### W8 — Documentation Sync (P1, at exit)

- [ ] Update `design_docs/api_docs/` with GCash/Maya ingestion contracts.
- [ ] Update `design_docs/web_docs/` (or equivalent) with retention infrastructure.
- [ ] Update `design_docs/20_Roadmap/` to reflect S2 outcomes.

## Constraints

- **AI cost cap is non-negotiable.** Free-tier LLM cost ≤30% of paid MRR.
- **No new product personas in S2.** Wedge stays as written.
- **PH-only market focus continues.** US re-engagement deferred behind P-6 trigger.
- **One feature at a time on inactive color** per `_governance/branching_guidelines.md`.
- **Velocity ceiling holds:** 10hr/day, 55hr/week (Sprint); 6hr/day, 30hr/week (decompression).

## Risks and Mitigations

| Risk | Mitigation |
|---|---|
| LLM costs exceed cap with growing free users | Auto-trigger halves prompts per `kill_commit_gates.md` §7. |
| GCash/Maya parsing unreliable, damages user trust | Privacy-respecting opt-in; clear "verify with bank" disclaimer; feedback path for parse errors. |
| Pro+ AI tier doesn't convert at expected rate | Re-evaluate AI features against actual user requests; reposition AI value prop. |
| Distribution doesn't scale beyond founder posting | Introduce micro-influencer affiliate; slow founder pace if exhaustion shows. |
| PH micro-influencer outreach has low conversion | Acceptable; expand channel list rather than pour effort into low-yielding channels. |
| Founding members churn at higher rate than expected | Investigate at S1 → S2 transition; not S2 problem if S1 retention validated. |

## Verification Gate

Per `validation_gates.md` Phase S2 exit triggers.

## Definition of Done for Phase S2

- All exit triggers met.
- AI cost discipline auto-triggers have not fired more than once during the phase.
- PH-local distribution shows ≥20% of new users from non-direct channels.
- S3 entry decision recorded in `kill_commit_gates.md` outcomes log.
- US re-engagement P-6 trigger evaluated (may not fire; document either way).
