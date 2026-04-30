# Phase S1: Public Beta Launch + Position Lock-in (PH-Only)

**Major revision:** 2026-04-30 post-beta huddle. Split into 4 Stages (A/B/C/D); PH-first market focus locked; mobile-wallet payment as hard constraint; Android pull-forward; AI tier S1.C tentative.

## Status snapshot

- **S1.A (Tight Invite Beta):** **completed 2026-04-30**. Beta live on VPS since 2026-04-29; flagship `web` (React+Vite); Reflex archived.
- **S1.B (Distribution Readiness):** **active 2026-04-30 →**. Research-heavy; "worth paying for" feature work; founding member program backend.
- **S1.C (Founding Beta):** pending; estimated August 2026.
- **S1.D (Soft Public Open, PH-only):** pending; estimated November 2026 → February 2027.

## Objective

Take the working Beta artifact and **wrap it in real positioning + a payable product**. Get the wedge in front of real PH users, validate retention, acquire the first paying users via Founding Beta, then open PH-only soft public.

This phase is **not** about new features for their own sake. It is about closing the gap between "the software works" and "PH users find it, pay for it, and stay." Features in S1.B exist specifically to justify ₱200/mo paid tier.

---

## Stage S1.A — Tight Invite Beta

**Status:** completed 2026-04-30.

### Outcome
- Live VPS deployment with web (flagship), API, blue-green proxy, db.
- Tight invitation cohort (HitM personal network, mostly US-based testers).
- Reflex archived; JS pivot completed in 3-day sprint.
- BP7 polish snapshot per `design_docs/10_Current_State/01_Runtime_Validation_Checklist.md` §H.

### Lessons captured (`00_strategic_context.md` §6)
- AI-orchestrated frontend dev is feasible at velocity.
- API-first discipline pays off.
- Multi-agent parallel coordination works at execution level; handoffs need work.
- Conscious owner-approved deviations need automatic follow-up tracking.
- Sprint compression is real and dangerous (Topic 8 mechanisms now operational).

---

## Stage S1.B — Distribution Readiness

**Status:** active 2026-04-30 → estimated July 2026.

**Entry criteria (all met):**
- S1.A exit met.
- Strategic Plan revision complete (huddle output).
- Topic 8 velocity controls operational (10/55 ceiling, time-clock agent setup queued).

**Exit criteria** (all required, gate to S1.C):
- Email uniqueness S0 fix shipped.
- `+Bill` hotfix retroactively committed; Reflex archival complete; pre-governance plans formally closed.
- Bug fixes for Issues #1, #4, #7 shipped (per `KNOWN_ISSUES.md` triage).
- AI Economics Deep-Dive complete with 16 decisions resolved.
- Entity formation decision made (US LLC vs OPC).
- Payment provider decision made with mobile-wallet primary path defined.
- Distribution channel research complete; founder content cadence defined.
- Wedge consistency audit complete; landing-page polish landed.
- Founding member program backend ready (seat cap + lifetime SKU + badge system).
- "Worth paying for" feature work complete (Pro tier demonstrably worth ₱200/mo).
- ToS + Privacy + Refund policies drafted and live.

### S1.B Workstreams

#### W1 — Drift Cleanup (Group B from huddle Topic 9)

P0 / S1. Order locked at huddle.

- [ ] `+Bill` hotfix → git (5-minute commit; HitM-approved deliberate deviation per Lesson 6.4)
- [ ] Email uniqueness S0 fix (`KNOWN_ISSUES.md` Issue 5; before any new invitee)
- [ ] Reflex archival per Topic 2 detailed scope (compose + proxy + scripts + env)
- [ ] Pre-governance plans formally closed in registry (already partially handled at huddle close-out)
- [ ] Bug fixes:
  - Issue #1 (recurring expense edit `is_recurring=true` broken) — S1
  - Issues #4 + #7 (heatmap intensity + calendar daily-active populate) — investigate jointly per shared root suspicion

Sub-plan: `plans/cursor/s1b/drift-cleanup/`.

#### W2 — Research Workstream (Group C, sequential)

P0 / S1.B exit gate. Sequential per huddle Q9.2.

- [ ] **Entity formation research.** US LLC vs OPC. Gates everything financial. Sub-plan: `plans/cursor/s1b/entity-formation-research/`.
- [ ] **Payment provider research.** Stripe vs PayMongo vs Xendit vs hybrid. GCash/Maya legality for US-incorporated business. Mobile-wallet primary path. Sub-plan: `plans/cursor/s1b/payment-provider-research/`.
- [ ] **AI Economics Deep-Dive.** 16 questions per `00_strategic_context.md` §3.11 + this Phase doc Appendix A. Sub-plan: `plans/cursor/s1b/ai-economics-deep-dive/`.
- [ ] **Distribution channel research.** PH-local channels (Facebook anchor, AI video framing, family/friend WOM seed). Sub-plan: `plans/cursor/s1b/distribution-channel-research/`.
- [ ] **Wedge consistency audit.** Slip-in (~1 hour). Static product surfaces, public docs, social/content surfaces. Sub-plan: `plans/cursor/s1b/wedge-consistency-audit/`.

#### W3 — "Worth Paying For" Feature Work (Group D)

Sequential after W2. HitM has feature backlog; not research-driven. Each feature follows the Per-Feature Color-Cycle Workflow (`_governance/branching_guidelines.md`).

- [ ] Landing polish + wedge integration into hero.
- [ ] Issue #2 — `+Bill` rework as **"quick pay bill that seeds a transaction with relevant data from the bill being paid"** (design resolved 2026-04-30; specialized form to be drafted).
- [ ] Issue #3 — quick-add fullness for tx/income/transfer (full features minus tx-type).
- [ ] Issue #6 — mobile dashboard quick buttons top-of-page (PH wedge requires this).
- [ ] Premium feature additions to make Pro tier obviously worth ₱200/mo (HitM's existing feature backlog).

#### W4 — Infrastructure & Tooling (Group E, parallel)

- [ ] Local Cursor "time clock" agent setup (10hr/day + 55hr/week tracking; pings + enforces).
- [ ] Huddle facilitation agent skill creation (encode huddle conversational pattern).
- [ ] Hotfix-with-followup-tracking workflow (per Lesson 6.4).

#### W5 — S1.C Entry Preparation (Group F)

After W2 + W3.

- [ ] Founding member program backend (seat cap server-enforced; lifetime SKU; badge system).
- [ ] Pricing page + chosen payment processor live (PHP-anchored).
- [ ] ToS + Privacy + Refund policies drafted, reviewed, live.

#### W6 — Android Pull-Forward (per `00_strategic_context.md` §3.3)

Concurrent with other workstreams. Targets `android:Scaffold → android:Alpha` during S1.B; `android:Tight Beta` during S1.C.

- [ ] Sync architecture document drafted (per `design_docs/40_System_Design/08_Android_Offline_First_Sync_Architecture.md`).
- [ ] Kotlin + Compose project scaffold built and verified buildable via AI orchestration.
- [ ] First minimum-viable feature on Android: safe-to-spend dashboard reading from local SQLite, syncing to API.
- [ ] Sub-plan: `plans/cursor/s1b/android-pullforward/` (when scoped; may slip to S1.C if S1.B capacity is constrained).

---

## Stage S1.C — Founding Beta

**Status:** pending; estimated August 2026 entry.

**Entry criteria (all required):**
- S1.B exit met.
- Pricing live with PHP-anchored Pro tier and Founding Lifetime SKU.
- Mobile wallet payment (GCash/Maya) functional as primary payment method.
- AI tier (Pro+ AI) launches — final commitment per AI Economics Deep-Dive outcome.
- Product is demonstrably worth ₱200/mo per HitM spot-check vs notebook substitute.

**Exit criteria (all required):**
- ≥30 paying users total (Founding + Pro PH).
- Founding seat cap reached OR 6-month founding window elapsed.
- Retention day-60 ≥25% on Founding cohort.

### S1.C Workstreams

- [ ] **Founding outreach to interest seed:** 3 PH family members (per huddle Topic 6 Q6.3) + grandfathered US Honorary Founders.
- [ ] **First PH-local community post:** anchored on wedge sentence in landing hero. Specific channel(s) per W2 distribution research.
- [ ] **Founder content cadence active:** monthly AI video story + weekly educational post + ad-hoc personal narrative (default cadence; revise per outcome).
- [ ] **Retention instrumentation:** sign-up, first-transaction-entered, first-safe-to-spend-viewed, day-7-return, day-30-return, day-60-return events.
- [ ] **Per-cohort tracking:** Founding members vs free signups vs paid converters; PH vs grandfathered US.
- [ ] **AI tier monitoring:** per-user cost cap enforcement; system-level monthly cap tracking; throttle behavior validated.

---

## Stage S1.D — Soft Public Open (PH-only)

**Status:** pending; estimated November 2026 entry.

**Entry criteria (all required):**
- S1.C exit met.
- Public landing page polish complete with wedge as hero.
- Bug count from Founding Beta cohort resolved or triaged.

**Exit criteria (any one of):**
- ≥10 paying PH users active in the prior 30 days (Pro tier, post-Founding).
- ≥50 active free PH users with retention day-30 ≥30%.

### S1.D Workstreams

- [ ] **Public PH landing live** with founder count + acknowledgment.
- [ ] **Founding tier closes** (cap reached or 6mo window).
- [ ] **Pro tier PH** opens for non-founder signups.
- [ ] **PH-local distribution effort sustained** ≥1 touchpoint per week.
- [ ] **Day-30 retention ≥30%** validated on cohort.

---

## Constraints

- **No paid ads.** Period.
- **PH-first only.** US users grandfathered as Honorary Founders; no US-targeted acquisition.
- **Mobile wallet as primary payment.** Forcing PH users to use credit cards is a non-starter.
- **Pre-baby vs post-baby velocity:** front-load deep-focus W2 research into May–early June pre-baby window. W3 features and W6 Android more interruption-tolerant.
- **One feature at a time on inactive color** per `_governance/branching_guidelines.md` §1.
- **Velocity ceiling:** 10hr/day, 55hr/week (Sprint); 6hr/day, 30hr/week (decompression).

## Risks and Mitigations

| Risk | Mitigation |
|---|---|
| S1.B research takes longer than 3 months (entity / payment / AI economics) | Acceptable; S1.C entry is gated on outcomes, not calendar. Sprint duration minimums prevent compression. |
| Email uniqueness S0 not fixed before new invitee | Hard rule: no additional invitees until fixed. |
| Founding Beta seat take-up below expectation | Reposition cycle per `kill_commit_gates.md` §2 (extend or reposition). |
| AI Economics Deep-Dive resolves "Pro+ AI not viable in S1.C" | Slip AI tier to S2 per Q4 Option (a) fallback. |
| Cursor cap hit mid-month | No overage purchases. Stop work; resume on cycle reset. |
| Family/health gate fires | Reduced-scope mode triggers automatically; S1.B can pause and resume. |
| PH-local distribution doesn't generate signal | Family/friend WOM seed (3 PH testers) buys time; reposition wedge or channel if no organic growth by S1.D mid-point. |

## References

- Strategic context: `00_strategic_context.md` (especially §3 locked decisions, §6 lessons learned, §7 personal constraints)
- Unit economics: `01_unit_economics_and_costs.md` (especially §2 pricing, §3 AI cost cap)
- Validation gates: `validation_gates.md` Phase S1
- Kill/commit gates: `kill_commit_gates.md` §2, §3, §6
- Parking lot: `PARKING_LOT.md` (P-1 through P-7)
- Branching workflow: `_governance/branching_guidelines.md`
- Deployment workflow: `_governance/deployment_protocol.md`
- Stage-level dashboard: `plans/cursor/s1b/README.md`

---

## Appendix A — AI Economics Deep-Dive (16 Questions)

Required S1.B sub-Sprint per `00_strategic_context.md` §3.5 and §3.11. S1.B cannot close until resolved.

**Cost questions:**

1. LLM provider + model selection per tier (Haiku/Sonnet/Opus class or equivalent OpenAI/local-Llama path).
2. Per-prompt cost estimates per tier's typical workload (categorization, predictions, planning sessions).
3. Caching effectiveness ceiling — what % of prompts can be served from cache (merchant→category, recurring predictions, batch digest)?

**Pricing questions:**

4. Pro+ AI monthly price (₱349 from current model — holds or revise?).
5. Founder credit-pack discount structure (flat 50%? Tiered? Fixed allocation per month free + discount above?).
6. Free tier prompt limit (10/month — holds or revisable?).
7. Hard cap before throttle for non-founders.

**Profitability bounds:**

8. Minimum margin per Pro+ AI sub (revenue − LLM cost − infra overhead).
9. Free tier subsidy ceiling validation (≤30% of paid MRR per `01_unit_economics_and_costs.md` §3.2).
10. Founder cumulative inference cost commitment math (e.g. 100 founders × ~$2/mo × 24mo ≈ $4,800 from one-time founding sales of ~$2,800).

**UX questions:**

11. Cap-hit behavior (throttle / blocked / upsell prompt).
12. Credits-remaining visibility in UI.
13. Reset cadence (calendar month / rolling 30-day / anniversary).

**Founder-specific:**

14. "Lifetime access to all future features" precise definition (alternatives in `00_strategic_context.md` §3.11 pushback).
15. Founder credit-pack gating (manual purchase or auto-allocation).
16. Founder monthly allocation exhaustion behavior (same throttle/upsell as Pro+ AI users, or special handling).

Outcome of this deep-dive may revise Q4 Option (b) tentative AI-at-S1.C commitment.
