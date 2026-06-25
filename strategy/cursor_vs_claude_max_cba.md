# Cursor Pro vs Claude Max — Honest CBA

> **Superseded 2026-06-26.** Tooling decision made: Claude Code + Cursor Pro+ + Antigravity Pro. See `AGENTS.md` §0 and §16 of [`current_status.md`](./current_status.md).

**Generated:** 2026-06-19  
**Context:** Post-baby velocity reduction in effect. S1.B exit estimated late 2026–mid 2027. All 13 feature plans in `draft`. PWA sprint paused. Entity/payment/AI-economics research incomplete. Sprint order not locked.

---

## 0. The Uncomfortable Truth Up Front

Before comparing tools: **the primary S1.B bottleneck is not coding velocity.** It's:

1. **Human decisions that haven't been made** — entity formation, sprint order, PWA offline bug fix direction
2. **Governance/process overhead** — 5–12 hrs/day babysitting AI operations (per TP16/C-D11), not fixed by swapping models
3. **Operator capacity at 30–50% post-baby** — better tools help proportionally less when hours are halved
4. **Non-code gate work** — counsel engagement, spouse commitment, ToS drafting, distribution research

A $200/mo tool does not write ToS, register a PH entity, or debug why your specific offline transaction population is broken while you're holding a newborn. The honest question is whether the coding hours you *do* have are better served by one tool or the other.

---

## 1. Current Tooling Baseline

### What you're actually paying/using (2026-06-19)

| Tool | Monthly | Role | Status |
|---|---|---|---|
| **Cursor Pro+ (current plan)** | **~$60** | Primary IDE agent; coding + some review | Listed in §1 overhead as **non-negotiable in S1–S2** |
| **Antigravity (Gemini)** | **$0** (absorbed by HitM) | Planning, strategy, synthesis, research | TP17 decision: stays for planning; **deprecated for code execution** |
| **Total current tooling** | **~$60/mo** | | |

### What the huddle decided (Session 5, 2026-05-06)

- **T-D05:** "Likely will move to $200/mo eventually" — but deferred to next billing cycle, and then again.
- **T-D06:** "Reviewer agent should use a higher model (Claude or similar) for code review quality."
- **T-D13:** Cursor upgrade timing deferred. "No funds available now."
- **TP17:** Antigravity stays for planning/strategy. Deprecated for code execution.

That was 6 weeks ago. The question is whether to pull the trigger now, and on what.

---

## 2. The Options

### Option A: Return to Cursor Pro ($20/mo)

| Aspect | Detail |
|---|---|
| **Cost** | $20/mo ($40/mo savings vs current Pro+) |
| **Credits** | $20 in usage credits; limited frontier model access |
| **Reality** | At huddle (May 6), you were at **18% remaining** with 22 days left on the *$20* plan. High model access was **exhausted**. |
| **Risk** | You ran out mid-month on this plan before. Babysitting-driven re-prompting burns credits 2–3× faster than clean execution. |

### Option B: Stay at Cursor Pro+ ($60/mo)

| Aspect | Detail |
|---|---|
| **Cost** | $60/mo (current) |
| **Credits** | 3× Pro credits; more frontier model access |
| **Reality** | Your `01_unit_economics_and_costs.md` §1 lists this as non-negotiable for S1–S2 velocity. |
| **Risk** | Still not enough for the reviewer-model-tier goal (T-D06). |

### Option C: Cursor Ultra ($200/mo)

| Aspect | Detail |
|---|---|
| **Cost** | $200/mo ($140/mo increase over current) |
| **Credits** | 20× Pro credits; full frontier model access |
| **What it enables** | Higher-model Cursor agent for code review (T-D06 near-term path). Less mid-month exhaustion. |
| **Risk** | Same IDE, same agent architecture, same context-loss problems. Just more runway before credits expire. |

### Option D: Cursor Pro ($20/mo) + Claude Max 20x ($200/mo)

| Aspect | Detail |
|---|---|
| **Cost** | $220/mo ($160/mo increase over current) |
| **What it enables** | Claude Code as primary development tool (terminal-based, long-running agents, extended thinking). Cursor as light IDE fallback. Claude for review + planning + code execution. |
| **Risk** | Two separate tools, two workflows. Claude Code is terminal-first — less IDE integration than Cursor agent mode. Learning curve during velocity-constrained period. |

### Option E: Claude Max 20x ($200/mo) only, drop Cursor

| Aspect | Detail |
|---|---|
| **Cost** | $200/mo ($140/mo increase over current; but saves the $60 Cursor) |
| **What it enables** | Claude Code for development. Claude chat for planning/review/synthesis (replaces Antigravity's role). Single model family for everything. Extended thinking for complex architectural decisions. |
| **Risk** | Losing Cursor's IDE integration, multi-file editing UX, tab completions. Claude Code is powerful but terminal-oriented. **You** are currently running this conversation in Antigravity (Gemini), which is free — Claude Max replaces that too. |

---

## 3. What Actually Eats Your Time (From Session 5 Audit)

| Time sink | Est. hrs/day | Root cause | Does better tooling fix it? |
|---|---|---|---|
| **Re-prompting after context loss** | 2–4 | Agent doesn't read handoff; session context evaporates | **Partially.** Larger context windows help. Claude's 200K context + extended thinking helps more than Cursor credits. But P1 fixes (mandatory handoff read, condensed format) help more than either. |
| **Iterating on broken output** | 1–3 | Agent produces code that doesn't match spec | **Partially.** Higher model quality → fewer iterations. Opus/Sonnet review → catches issues earlier. But structured task specs (P2) help more. |
| **Manually setting up agent sessions** | 1–2 | No reliable task→agent pipeline | **No.** This is an orchestrator gap (P3), not a model quality gap. |
| **Debugging infra failures** | 0.5–1 | PA crashes, Slack routing failures | **No.** Infrastructure problem, not model problem. |
| **Performing steps agents should do** | 0.5–2 | Deploy, test, commit, push — agent can't or isn't trusted | **Partially.** Claude Code's agentic capabilities (terminal access, long-running tasks) are stronger than Cursor's agent mode for autonomous multi-step execution. |

**Bottom line:** Of ~5–12 hrs/day wasted, better tooling addresses **maybe 3–5 hours** at best. The other 3–7 hours are process/infrastructure problems that P1–P3 fixes address.

**But you're at 30–50% velocity now.** If you're working 6 hrs/day (decompression ceiling), saving even 1–2 hours of babysitting = **25–33% effective velocity gain**. That's not nothing.

---

## 4. Breakeven Impact Analysis

### Current overhead baseline (from `01_unit_economics_and_costs.md` §1)

| Item | Current | With Cursor Ultra | With Claude Max only | With both ($20 Cursor + $200 Claude) |
|---|---|---|---|---|
| Cursor | $60 | $200 | $0 | $20 |
| Claude Max | $0 | $0 | $200 | $200 |
| VPS | $40 | $40 | $40 | $40 |
| Domain + TLS | $2 | $2 | $2 | $2 |
| **Total overhead** | **~$102/mo** | **~$242/mo** | **~$242/mo** | **~$262/mo** |
| **Buffered planning** | **~$115–130** | **~$255–275** | **~$255–275** | **~$275–295** |

### Break-even subscriber count at Pro ₱249/mo (locked)

Using the §4.1 formula: net ~₱212/mo per sub (×0.85), ~$3.78/sub at ₱56:$1.

| Overhead level | Current ($102) | +$140 Cursor Ultra ($242) | +$140 Claude Max ($242) | +$160 Both ($262) |
|---|---|---|---|---|
| **Pro subs to break even** | **~27** | **~64** | **~64** | **~70** |
| **Delta from current** | — | +37 subs | +37 subs | +43 subs |

### What that means in plain English

- You currently need **~27 paying Pro subscribers** to cover overhead.
- Adding $140/mo of tooling means you need **~64 subscribers** — **2.4× more** — before you break even.
- **You are at zero paying subscribers today.** S1.C (founding beta) is ~6+ months away. First real revenue is estimated at Q1 2027 (per TP18 session outcome).
- Every dollar of tooling spend between now and first revenue is **pure consumption of personal savings**, justified only by the velocity it buys toward revenue.

### The velocity-to-revenue question

The S1.B feature completion projection says:

| Scenario | Timeline | Calendar |
|---|---|---|
| Aggressive | 24–28 weeks | Late 2026 |
| **Likely (adopted baseline)** | **30–40 weeks** | **Late 2026 – early 2027** |
| Conservative | 40–52 weeks | Mid 2027 |

**Question:** Does $140/mo compress the Likely scenario enough to reach revenue materially sooner?

**Honest answer:** Maybe 2–4 weeks over 30–40 weeks. Here's why:

- At 30–50% velocity, you're doing ~15–25 productive hours/week.
- Of those, maybe 30–40% is actual coding (rest is governance, research, decisions, baby).
- Better tooling helps the **coding** fraction. That's ~5–10 hrs/week.
- If a better model saves 20–30% of coding time via fewer iterations, that's ~1.5–3 hrs/week saved.
- Over 35 weeks (midpoint of Likely), that's ~50–100 hours saved.
- 50–100 hours ≈ **1.5–3 additional weeks of coding output**.
- Total cost: 8 months × $140 = **$1,120** for ~2–3 weeks of calendar compression.

**Is $1,120 worth reaching revenue 2–3 weeks sooner?** Only if first-revenue payout exceeds that within the compression window. With founding seats at ₱999–₱1,499, you'd need 40–60 founding sales to recoup. That's plausible... in a scenario where everything else also goes right.

---

## 5. Pro/Con Matrix

### Option B: Stay at Cursor Pro+ ($60/mo) — Status Quo

| Pros | Cons |
|---|---|
| Known cost, already in overhead baseline | Credits still run out mid-month under heavy use |
| IDE integration you're familiar with | Not enough model quality for reviewer tier (T-D06) |
| No workflow disruption during baby period | Babysitting hours stay at current level |
| Preserves budget for other needs | Antigravity (free) carries planning/strategy load but can't code |

### Option C: Cursor Ultra ($200/mo)

| Pros | Cons |
|---|---|
| 20× Pro credits — unlikely to exhaust mid-month | $140/mo increase with zero revenue |
| Frontier model access for review quality (T-D06) | Same IDE, same agent architecture, same context-loss patterns |
| Single tool, single workflow | Doesn't fix the orchestrator gap (P3) |
| No learning curve | 2.4× higher break-even subscriber count |

### Option E: Claude Max 20x ($200/mo), drop Cursor

| Pros | Cons |
|---|---|
| **Claude Code** — terminal-based agentic dev with extended thinking | Terminal-first; lose Cursor IDE UX (multi-file editing, tab completions) |
| **Opus-class** models for both coding AND review in one tool | Learning curve during velocity-constrained period |
| Replaces Antigravity for planning/strategy/synthesis too — **one tool for everything** | Unfamiliar workflow; friction during the exact period you can least afford it |
| 200K context window → less context loss → directly addresses the #1 time sink | You're already in Antigravity right now; switching has real cost |
| Extended thinking for complex architectural decisions (PWA offline debug, API design) | Claude Code's multi-repo orchestration is less mature than Cursor's IDE |
| **Same $200/mo as Cursor Ultra** — more capable model, same price | Risk of discovering Claude Code doesn't match your workflow |
| Agent SDK usage still draws from subscription (not separate billing, as of June 2026) | |

---

## 6. My Honest Recommendation

### What the numbers say

The breakeven math doesn't favor *either* upgrade right now. You're burning personal savings with zero revenue on the horizon until Q1 2027 at earliest. Every dollar of tooling is a bet on future velocity.

### What the bottleneck analysis says

Your #1 time sink is **context loss + re-prompting** (2–4 hrs/day). This is where Claude has a genuine structural advantage:

- **200K context window** vs Cursor's model-dependent window
- **Extended thinking** — the model reasons longer before producing output, which means fewer broken iterations
- **Memory across conversations** — decisions don't evaporate between sessions
- **Claude Code** — autonomous multi-step terminal execution (the kind of thing you need for the orchestrator pipeline itself)

But the P1–P3 fixes (context delivery, task specification, orchestrator script) would help *more* than any model upgrade, and they're **free** to implement. They just haven't been built because you've been at reduced capacity.

### What I'd actually do (if this were my money)

> [!IMPORTANT]
> **Don't spend $200/mo right now. But don't go back to $20/mo either.**

1. **Stay at Cursor Pro+ ($60/mo) for the next 30 days.** It's already in the overhead baseline. You know the tool.

2. **Spend 2–3 focused hours implementing P1 + P2** (context delivery + task specification). These are documented, low-effort, high-impact fixes from Session 5. They were marked "DELIVERED 2026-05-21" (T-D04) as governance artifacts, but the *enforcement* in actual agent sessions is the gap.

3. **Measure your babysitting hours for one month** with P1+P2 enforced. If they drop from 5–12 hrs/day to 2–4 hrs/day, the process fixes are working and tooling is secondary.

4. **If babysitting hours stay at 4+ hrs/day after P1+P2** — then upgrade. At that point, the evidence says model quality is the binding constraint, not process. Go to **Claude Max 20x ($200/mo)** and drop Cursor:
   - You get a better model (Opus/Sonnet) for both coding AND review
   - You get Claude Code for the orchestrator pipeline itself
   - You consolidate Antigravity's planning role into the same tool
   - Net cost increase is $140/mo ($200 Claude – $60 Cursor saved)
   - You avoid paying $260/mo for two tools with overlapping roles

5. **Hard stop:** If by September 2026, the tooling spend has increased but S1.B progress is still on the Conservative trajectory (40+ weeks), that's evidence the bottleneck is structural (not tooling) and the money is being wasted. Kill the upgrade, return to Pro+, and redirect budget to the first quarterly self-review's conclusions.

### The deeper question

You asked for an honest look. Here it is:

**The project's critical path runs through decisions and infrastructure, not through coding velocity.** The entity formation decision. The PWA offline bug. The sprint order lock. The quarterly self-review in 11 days. These are all things a human has to do, with a baby, in 6 hrs/day, and no amount of model quality changes that.

Better tooling helps at the margins — and those margins matter more when your hours are scarce. But $140/mo buys ~2–3 weeks of calendar compression over an 8-month horizon, which is a real but modest return.

The highest-ROI move right now is free: enforce P1+P2, fix the PWA offline bug (which requires debugging, not model upgrades), and make the entity decision. Those three things unblock more S1.B exit criteria than any tooling change.

---

## 7. Summary Decision Table

| Option | Monthly | Overhead delta | Break-even subs | Calendar compression (est.) | Recommendation |
|---|---|---|---|---|---|
| **A — Cursor Pro ($20)** | $20 | –$40 | ~21 | –1 week (more babysitting) | ❌ You already exhausted this plan before |
| **B — Cursor Pro+ ($60)** | $60 | $0 | ~27 | Baseline | ✅ **Stay here for now** |
| **C — Cursor Ultra ($200)** | $200 | +$140 | ~64 | +2–3 weeks | ⚠️ Overpaying for same architecture |
| **D — Cursor $20 + Claude Max ($200)** | $220 | +$160 | ~70 | +3–4 weeks | ❌ Two tools, two workflows, max cost |
| **E — Claude Max ($200), drop Cursor** | $200 | +$140 | ~64 | +2–4 weeks | ✅ **Upgrade to this if P1+P2 don't close the gap** |

---

*Cross-references:*
- Unit economics: [`strategy/strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md`](./strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md)
- Session 5 decisions: [`strategy/huddles/admin-meeting-huddle-prep-2026-05-06/sessions/session-05-tooling-agents/SESSION_NOTES.md`](./huddles/admin-meeting-huddle-prep-2026-05-06/sessions/session-05-tooling-agents/SESSION_NOTES.md)
- Feature completion projection: [`strategy/huddles/admin-meeting-huddle-prep-2026-05-06/S1B_FEATURE_COMPLETION_PROJECTION.md`](./huddles/admin-meeting-huddle-prep-2026-05-06/S1B_FEATURE_COMPLETION_PROJECTION.md)
- Validation gates: [`strategy/strategic-roadmap-reframe-53be/validation_gates.md`](./strategic-roadmap-reframe-53be/validation_gates.md)
- Current status: [`strategy/current_status.md`](./current_status.md)
