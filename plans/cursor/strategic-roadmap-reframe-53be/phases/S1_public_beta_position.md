# Phase S1: Public Beta Launch + Position Lock-in

## Objective

Take the working Beta artifact (already being prepared by `plans/cursor/api-reflex-beta-readiness-plan-53be/` and `plans/cursor/vps-beta-rollout-ops/`) and **wrap it in real positioning**. Get the wedge in front of real PH users, validate retention, and acquire the first paying users.

This phase is **not** about new features. It is about closing the gap between "the software works" and "people who match the persona find it, try it, and stay."

## Entry Criteria

- VPS baseline runtime stable (per `vps-beta-rollout-ops` Phase A).
- API + Reflex passing smoke (per `api-reflex-beta-readiness-plan-53be`).
- Owner has explicitly committed to the wedge sentence in `00_strategic_context.md` §1.
- Founding-member program seat count + price decided (recorded in `01_unit_economics_and_costs.md`).

## Exit Criteria (any one)

- ≥10 paying PH users active in the prior 30 days, OR
- ≥50 active free users with retention day-30 ≥30%.

## Breakpoints

- **Brand audit:** before public landing goes live, every surface leads with the wedge sentence.
- **Pricing live:** Stripe (or PH-friendly alternative like Xendit) is live with PHP-anchored Pro tier.
- **First post:** owner posts to first PH-local community with the wedge as the hook.
- **First paying user:** validates the entire pipeline.
- **Founding-member program closes:** hard cap reached or 6-month window elapsed.

## Triggers (Move to S2 or Stay/Reposition)

See `kill_commit_gates.md` §2.

## Workstreams

### 1. Brand & Positioning (P0, immediate)

- [ ] One-sentence wedge committed and reviewed (`00_strategic_context.md` §1).
- [ ] Landing page copy authored around wedge. Hero: wedge sentence verbatim. Sub-hero: "for people on thin margins, not for surplus optimizers."
- [ ] App store / Play Store description prepared, wedge in first sentence.
- [ ] Social media handles registered (PH-relevant: Reddit account warmed up, FB page or personal account, X/Threads optional).

### 2. Pricing & Billing Infrastructure (P0)

- [ ] Stripe (or PH alternative) account ready, business compliant.
- [ ] Tiers per `01_unit_economics_and_costs.md` §2 implemented: Free, Pro PH, Pro US/EU, Pro Annual, Founding Lifetime.
- [ ] PHP-anchored display pricing on landing.
- [ ] Cancellation/refund policy drafted and linked.
- [ ] Founding-member program live with hard seat cap enforced server-side.

### 3. Public Beta Launch Prep (P0)

- [ ] Landing page deployed; sign-up form functional.
- [ ] Email transactional flow working (welcome, password reset, billing receipts).
- [ ] Privacy policy and terms drafted (PH-relevant; US/EU compliant for ZK-future-proofing).
- [ ] Bug-report path live (already partially exists per `vps-beta-rollout-ops` Phase B).
- [ ] One canary metric configured (e.g. daily transaction count) with paging on deviation.

### 4. Distribution Activation (P0, sustained)

- [ ] First PH-local community post (r/phinvest, "Filipino Freelancers" FB group, OFW community, or thrift-living audience).
- [ ] Founder content cadence: ≥1 PH-local touchpoint per week, every week, throughout S1.
- [ ] First 10 founding-member outreach: personal network, not cold.
- [ ] Track conversion: where did each sign-up come from?

### 5. Retention Instrumentation (P1)

- [ ] User-level events: sign-up, first-transaction-entered, first-safe-to-spend-viewed, day-7-return, day-30-return.
- [ ] Weekly retention report (manual is fine; automate if needed).
- [ ] Cohort tracking: founding members vs free signups vs paid converters.

### 6. Documentation Sync (P1, at exit)

- [ ] Update `design_docs/01_Business_Vision.md` with the wedge and primary-persona reframe.
- [ ] Update `design_docs/20_Roadmap/Roadmap_Overview.md` to reference this strategic roadmap.
- [ ] Archive obsolete "Average Joe vs Finance Bro" framing.

## Constraints

- **Baby due 2026-06.** Plan assumes ~30–50% velocity loss from 2026-06 through 2026-12. Calendar dates are loose; exit triggers are firm.
- **No paid ads.** Period.
- **Do not launch new features in S1** beyond what's needed for billing/auth/retention. Feature pressure is rejected automatically until exit triggers met.
- **AI tier is not in S1.** It's S2. Resist the temptation to build it before validating retention.

## Risks and Mitigations

| Risk | Mitigation |
|---|---|
| Public launch flops; <5 paying users at month 9 | Reposition flow per `kill_commit_gates.md` §2. |
| Owner velocity collapses post-baby | Reduced-scope mode; canary metric + minimal owner intervention. |
| Stripe / billing infrastructure breaks under real users | Test thoroughly with founding-member program before opening to public. |
| Free-tier LLM cost spikes | Auto-trigger from `kill_commit_gates.md` §7 halves prompts. |
| Brand drift (feature names overshadow wedge) | Brand audit gate at every phase transition. |

## Required Implementation Updates

Subordinate plans feed into S1 exit:

- `plans/cursor/api-reflex-beta-readiness-plan-53be/` — API + Reflex beta-readiness.
- `plans/cursor/vps-beta-rollout-ops/` — VPS baseline + feedback pipeline.
- `plans/cursor/server-beta-install-bluegreen-53be/` — blue/green runtime.

S1-specific tasks (not yet broken into subplans):

- Brand & positioning task packet (to be created if needed).
- Pricing/billing task packet (to be created if Stripe integration is non-trivial).
- Distribution activation task packet (lightweight; mostly owner content cadence).

## Verification Gate

Per `validation_gates.md` Phase S1 exit triggers.

## Definition of Done for Phase S1

- All exit triggers met.
- All workstreams 1–4 complete or explicitly deferred to S2 with reason.
- `design_docs/` updated to reflect wedge and reframe.
- S2 entry gate evaluated; commit/extend/reposition decision recorded in `kill_commit_gates.md` outcomes log.
