# TP16 + Cluster C: Human Relief & Product Velocity

**Huddle session:** TP16 + Cluster C combined  
**Status:** `discussing`  
**Topics covered:** TP16 (Human Relief), TP3 (Feature Scheduling), TP9 (Efficiency), TP20 (Success Avenues), TP21 (Beta Expansion)

---

## TP16: Human Relief Points

### The core problem

HitM is the **sole human operator** across all domains:

| Domain | Current HitM role | Hours/week estimate | Automatable? |
|--------|-------------------|--------------------|----|
| **Engineering** (code, debug, deploy) | Hands-on coder + reviewer | 20–30 | **Partially** — agents code; HitM reviews |
| **Operations** (VPS, Docker, monitoring) | Sole operator | 5–10 | **Mostly** — with proper alerting + runbooks |
| **Governance** (plans, registry, docs) | Author + maintainer | 5–10 | **Partially** — agents can maintain; HitM decides |
| **Strategy** (roadmap, pricing, entity) | Decision-maker | 3–5 | **No** — HitM-only |
| **Marketing/Content** | Not started | 0 (future: 3–5) | **Partially** — AI content + SMM hire |
| **Admin** (scheduling, coordination) | Manual | 2–5 | **Mostly** — with workflow automation |
| **User support** | DMs only | <1 | **Partially** — F-012 intake queue |
| **Legal/Tax** | Research + counsel coordination | 1–3 (bursts) | **No** — HitM + counsel |
| **Total current** | | **~35–60 hrs/week** | |

**Ceiling:** 55 hrs/week sprint, 30 hrs/week decompression. **Post-baby:** 30–50% reduction → effective ceiling drops to **~17–28 hrs/week**.

### The baby math

```
Pre-baby (now through ~Jun 15):     55 hrs/week available → ~35–60 used
Post-baby (Jun 15 – ???):           17–28 hrs/week available → what gets cut?
```

At post-baby capacity, HitM **cannot** maintain current scope across all domains. Something has to give. The question is: **what gives, and what fills the gap?**

### Relief hierarchy (what can absorb HitM's time)

Ordered from highest impact to lowest:

#### Tier 1 — Automation pipelines (THE critical stressor, → TP5/TP14)

> [!CAUTION]
> **This is the emergency.** HitM is currently spending **5–12 hours per day babysitting AI operations** — prompting, reviewing, iterating, fixing broken outputs, restarting failed sessions, and managing context loss between agent turns. This single stressor eats away admin time, caused the emergency pre-huddle, and is the primary reason this huddle is happening. Everything else is manageable; **this is not.**

**What exists (partially built, not working as intended):**

The automation infrastructure is **designed** but the execution is failing in practice:

| Component | Status | Location |
|----------|--------|----------|
| **4-entity pipeline** (HitM → executor → reviewer → HitM gate) | Designed, Phase 1 (manual) | [`design_docs/40_System_Design/14_Inter_Agent_Message_Relay_and_Ownership_Contract.md`](../../../../design_docs/40_System_Design/14_Inter_Agent_Message_Relay_and_Ownership_Contract.md) |
| **Slack channel architecture** (sprint-queue → review-queue → hitm-gate) | Channels created, pipeline not flowing reliably | [`governance/sprint_queue_message_spec_v1.md`](../../../../governance/sprint_queue_message_spec_v1.md) |
| **Cursor PA** (headless Cursor runner) | Has had stability issues; `agent-prompt` failures | `~/CursorAgent/headless-cursor-agent/` |
| **Sprint pipeline bridge** | Script exists; polling + JSONL inbox/outbox | [`scripts/sprint_slack_pipeline_bridge.py`](../../../../scripts/sprint_slack_pipeline_bridge.py) |
| **Workspace isolation** | 4 separate clones defined | [`governance/agent_workspace_isolation.md`](../../../../governance/agent_workspace_isolation.md) |
| **Handoff templates** | Defined (in_plan, cross_plan, failure) | [`governance/execution_protocols.md`](../../../../governance/execution_protocols.md) |
| **Runtime handoff notes** | Template exists for feature sprints | [`governance/runtime_handoff_template.md`](../../../../governance/runtime_handoff_template.md) |
| **Smoke tests** | **Automated** — currently running | VPS deployment scripts |

**What's broken (the 5–12 hr/day gap):**

| Problem | Impact | Root cause |
|---------|--------|-----------|
| Context loss between agent sessions | Agent re-derives decisions, makes contradictory changes | Handoff notes exist but agents don't reliably read them; context windows too short |
| Agent output quality requires heavy iteration | HitM prompts → reviews → corrects → re-prompts, often multiple rounds | Insufficient task specificity in prompts; no automated acceptance criteria checks |
| Pipeline not flowing end-to-end | Manual intervention at every stage instead of notification-only | Phase 1 (manual) is the current state; Phase 2+ runners not stable |
| Cursor PA runner instability | `agent-prompt` failures require manual restart and re-prompting | Script/extension issues in headless environment |
| Slack bridge not reliably routing | Messages get lost or not picked up | Runner configuration + channel allowlist issues |

**Target state:** HitM posts a task → agent picks it up → agent implements → smoke tests run → HitM gets a notification with results → HitM does visual verification (is this what I asked for?) → approves or sends feedback. **HitM's role is review + feedback, not prompting + iterating + babysitting.**

**This is the critical path item for Session 5 (TP5, TP14).** Everything else in this huddle is manageable; if this doesn't get fixed, the post-baby plan falls apart.

**Key clarifications from HitM (2026-05-06):**

- **Manual verification** = post-smoke-test visual check. Smoke tests are automated. HitM visually confirms implementation matches specs, then provides feedback. This part is still early dev — the feedback loop automation isn't working as desired.
- **One-feature-at-a-time** is about **feature clarity and context**, not a hard structural limit. Multiple workspaces exist now. Concurrent features are possible IF automation governance + handoffs are solidified. This is a Session 5 prerequisite.
- **CPPRD tiering** — CPPRD is already AI-automated for historical changelogs. Whether to tier it (full CPPRD for significant changes, CPPR for small ones) depends on context window and drift potential. Needs Session 5 analysis.
- **Plan registry batching** — proposed simplification (weekly batch updates vs per-change) needs discussion in Session 5 as it interacts with automation reporting.
- **Existing automation infra is designed to mitigate session-based context loss** via Slack handoffs and inbox/outbox JSONL systems. This needs deeper audit in Session 5 to understand what's working vs what's just documented.


#### Tier 2 — SMM family hire (first human relief, → TP2/TP24)

Already decided (S1-D06): family member, part-time, ~₱10k/mo, post-baby.

| Offloaded from HitM | Retained by HitM |
|---------------------|-----------------|
| Content posting cadence | Content strategy and approval |
| Basic community engagement | Brand voice decisions |
| Simple analytics reporting | Campaign direction |
| Comment/reply moderation | Escalation handling |

**Impact:** Removes 3–5 hrs/week of marketing execution; frees HitM for strategy/product.

**SMM onboarding requirements (DECIDED 2026-05-06):**

Before the SMM family hire can be effective, she needs:

| Requirement | What it means | Who delivers |
|------------|--------------|-------------|
| **Beta access** | Must be an active user of the app; understand what she's promoting from personal use | HitM sets up account |
| **App understanding** | Sit-down session to walk through features, value prop, user demographics | HitM (in person) |
| **Org structure briefing** | How the project is organized, what tools are used, how she can interact with systems | HitM (in person) |
| **Dedicated AI automation** | Set up AI-assisted workflows specifically for her SMM tasks (some already planned but poorly organized in current infra) | HitM + agent setup |
| **Content guidelines** | Brand voice, what's acceptable to post, approval flow for content | HitM drafts (agent can help) |

This onboarding is **not possible during the baby adjustment period** — it requires HitM's focused attention. Realistic timing: when baby is ~2–3 months old (Aug–Sep 2026).

#### Tier 3 — Process simplification (→ TP9)

Governance and process overhead that can be streamlined:

| Current friction | Possible simplification |
|-----------------|------------------------|
| One-feature-at-a-time on inactive color | Classify some features as **parallel-safe** (UI-only changes, docs, etc.) |
| Manual verification at every deploy | Standardized smoke bundles that agents can run |
| Plan registry updates on every status change | Batch updates weekly instead of per-change |
| Full CPPRD for every code change | Tiered: CPPR for small changes, full CPPRD for significant ones |
| Session-based agent context loss | Persistent handoff notes + skill files |

#### Tier 4 — Deferred work (things that just wait)

Acceptable to pause during baby period:

| Workstream | Can pause? | Resume trigger |
|-----------|-----------|---------------|
| Entity formation | ✅ Already deferred | Post-baby financial stabilization |
| AI economics deep-dive | ✅ Already shelved | Entity + PSP decisions |
| Distribution channel research | ✅ Low urgency pre-revenue | When SMM hire starts |
| Android pull-forward | ⚠️ Can pause but delays S1.B exit | Post-PWA completion |
| New feature development | ⚠️ Slows S1.B but doesn't break anything | When capacity allows |
| PWA implementation (already paused) | ❌ **MUST-SHIP** — needs technical unblock | After huddle completes (see TP3) |

> **Note (2026-05-06):** All devops and development is **stopped** during these huddle sessions. This is intentional — the stress relief of resolving "where to go from here" is worth the week of downtime. Development resumes after sessions are complete with clear direction.

### Decision framework: What does HitM do post-baby?

Given ~17–28 hrs/week, propose this allocation:

| Activity | Hours/week | Priority |
|----------|-----------|----------|
| **Review agent work** (PRs, deploys, smoke results) | 5–8 | P0 — this is the admin/planner model |
| **Strategy decisions** (roadmap, pricing, entity when ready) | 2–3 | P0 — cannot be delegated |
| **Feature prioritization + task queue management** | 2–3 | P0 — feeds agent work |
| **User support + community** (minimal until SMM hire) | 1–2 | P1 |
| **Governance maintenance** (simplified per Tier 3) | 1–2 | P1 |
| **Hands-on coding** (only when agents are stuck) | 2–5 | P2 — exception, not default |
| **Marketing/content** (deferred to SMM hire) | 0–1 | P3 |
| **Total** | **13–24** | Fits post-baby ceiling |

**Discussion prompt:** Does this allocation feel right? What's missing or over-weighted?

---

## TP3: Feature Rollout Scheduling

### Planning baseline (DECIDED)

> **Conservative estimate adopted as planning baseline (2026-05-06).** HitM acknowledges that time to adjust to baby + legal delays from entity creation push the realistic timeline to the conservative band. This is acceptable — costs and time can be absorbed.

From [S1B_FEATURE_COMPLETION_PROJECTION.md](../../S1B_FEATURE_COMPLETION_PROJECTION.md):

| Scenario | Timeline from now | Finish date | Status |
|----------|------------------|------------|--------|
| Aggressive | 24–28 weeks | Late 2026 | Not realistic |
| Likely | 30–40 weeks | Late 2026 – Early 2027 | Possible if automation works well |
| **Conservative** | **40–52 weeks** | **Mid 2027** | **Planning baseline** |

With entity formation targeting ~Q1 2027 (TP18) and baby-adjusted velocity, the conservative timeline is the honest one. **Mid 2027 S1.B exit** is the working assumption.

### Devops pause (DECIDED)

> **All development and devops stopped during huddle sessions (2026-05-06).** This is intentional — resolving strategic direction is worth the week of downtime. Development resumes after sessions conclude with clear direction and priority.

### New: Definition of Done Doctrine (DECIDED)

> **A feature is not "done" until it includes all of the following.** This doctrine applies to all features developed after this huddle.

| DoD Component | What it means | Applies when |
|--------------|--------------|-------------|
| **Core functionality** | Feature works as specified, tested, deployed | Always |
| **SEO optimizations** | Meta tags, semantic HTML, sitemap updates for any new routes | Any user-facing route |
| **Localization (i18n)** | Filipino + English strings at minimum | Any user-facing text |
| **PWA integration** | Feature classified as offline-capable or online-only; offline-capable features work without network | Any feature touching data or display |
| **Guided walkthrough** | Help tour step(s) for the feature (once F-007 guide system is complete) | Any new user-facing feature post-F-007 |
| **Changelog entry** | `[Unreleased]` entry in subrepo CHANGELOG | Always |

**PWA offline classification (initial hypothesis — needs deeper design):**

| Offline-capable (current core functions) | Online-only (new/advanced tools) |
|----------------------------------------|----------------------------------|
| Transaction viewing + creation | AI predictions (F-002/F-003) |
| Calendar / upcoming expenses viewing | Smart tag estimation |
| Source balance display (cached) | Family ledger sync (F-008) |
| Quick Add | Export generation (F-010) |
| Guided walkthroughs (F-007) | Bug/feature submission (F-012) |
| | Balance history chart (API-heavy?) |

> [!IMPORTANT]
> The offline/online feature split needs dedicated design work before implementation. The hypothesis above is a starting point. The principle is: **current core functions stay offline-capable; added tools are online-only by default unless there's a clear user value for offline.**

### Feature backlog (S1.B scope — revised priority)

| F-ID | Feature | Role | Complexity | Parallel-safe? |
|------|---------|------|-----------|---------------|
| F-001 | Balance history + charts | ✅ Strong Pro differentiator | Medium | ✅ Yes |
| F-002 | Smart tag estimation | ✅ AI feature → Pro+ | High (rust_tools) | ⚠️ API changes |
| F-003 | Predictive budgeting | ✅ AI feature → Pro+ | High (rust_tools) | ⚠️ API changes |
| F-004 | STS pay cycles / bill realism | ✅ **Core wedge feature** | High | ❌ Touches money math |
| F-005 | Savings goals | ✅ Pro differentiator | Medium | ✅ Yes |
| F-006 | Dashboard widgets (custom) | Nice-to-have | Medium | ✅ Yes (UI only) |
| F-007 | Guided walkthroughs | 🔴 **MUST-SHIP — usability for first-time PFM users** | Low–Medium | ✅ Yes (UI only) |
| F-008 | Family ledger | ✅ Pro family-share feature | High | ⚠️ New model |
| F-009 | Recurring auto-deduct | ✅ Core quality-of-life | Medium | ⚠️ Touches source balances |
| F-010 | Export / sharing | Moderate — trust builder | Medium | ✅ Yes |
| F-011 | Wedge landing hero + public surface | 🔴 **MUST-SHIP — ToS, Privacy, changelog, feature roadmap visibility** | Low–Medium | ✅ Yes |
| F-012 | Bug/feature intake | Infra — enables scale | Medium | ✅ Yes |
| F-013 | User activity logs (ops) | Infra — ops visibility | Medium | ✅ Yes |

### Revised prioritization (DECIDED 2026-05-06)

#### Tier 0 — Usability & platform foundations (MUST-SHIP, non-negotiable)

1. **PWA fix** — Fix network error + offline shell. Offline mode is **real value** for the demographic (spotty internet). Cannot lose testers to broken offline.
2. **F-007** — Guided walkthroughs. **Most users will be using a PFM for the first time.** HitM cannot reasonably answer "how tos" for every user, and cannot risk losing testers who don't understand the system. Either finish current WIP polish or leave in current state → pivot → come back post-F-011.

#### Tier 1 — Public surface & trust infrastructure

3. **F-011 (expanded scope)** — Not just "landing hero" but the full public-facing surface:
   - ToS, Privacy Policy (agent-draftable → counsel review later)
   - Versioning / changelog page (so testers and potential founders see development progress)
   - Planned features page (user-facing roadmap — shows what's coming)
   - Founding member program information
   - This enables beta testers to see momentum and understand what they're testing toward

#### Tier 2 — Core wedge features ("worth paying for")

4. **F-004** — STS pay cycles / bill realism (the thing that makes this app different from a notebook)
5. **F-001** — Balance history + charts (visual proof of value)
6. **F-009** — Recurring auto-deduct (quality-of-life)
7. **F-005** — Savings goals (concrete "paying for itself" feature)

#### Tier 3 — S1.B completeness (should-ship)

8. **F-012** — Support intake (needed before beta expansion)
9. **F-013** — User activity logs (ops hygiene)
10. **F-010** — Export / sharing (trust builder)

#### Deferred to S1.C

11. **F-002/F-003** — Smart tags + predictive budgeting (AI tier; Pro+ AI is S1.C)
12. **F-006** — Dashboard widgets (nice-to-have)
13. **F-008** — Family ledger (complex; Pro family-share later)

### Proposed sequencing (post-huddle)

```
Huddle week (NOW — devops paused):
  └── Strategy/planning decisions only. No code.

Post-huddle → Baby (~3-4 weeks remaining):
  ├── PWA unblock (fix network error + offline shell) — TOP PRIORITY
  ├── F-007 decision: finish polish or freeze WIP and pivot
  └── F-011 start (ToS draft, changelog page, feature roadmap page)

Post-baby (~Aug+, reduced velocity, conservative timeline):
  ├── F-011 complete (public surface)
  ├── F-007 return (finish guides if WIP was frozen earlier)
  ├── F-004 (STS / bill realism — core wedge)
  ├── F-001 (balance history)
  ├── F-009 (recurring auto-deduct)
  ├── F-005 (savings goals)
  ├── F-012 (support intake)
  └── F-013 + F-010 (infra + export)

Pre-S1.B exit (~mid 2027, conservative):
  ├── All DoD requirements met per feature (SEO, i18n, PWA, guides)
  ├── Wedge consistency audit complete
  ├── ToS / Privacy / Refund live (counsel-reviewed version)
  ├── PWA install-as-app production bar met
  └── Entity registered + PSP live (from TP18 timeline)
```

### F-007 pivot decision (immediate)

Two options on the table:

| Option | What happens | Pros | Cons |
|--------|-------------|------|------|
| **A — Finish polish now** | Complete current WIP in pre-baby window | Guides exist for current features; clean starting point | Competes with PWA fix for pre-baby capacity |
| **B — Freeze WIP, pivot, return post-F-011** | Leave guides in current state; move to F-011 | Gets public surface live faster; guides come back with more features to cover | Users in the gap period have partial guides |

**HitM leaning:** Option B (pivot, return post-F-011). **HitM decision slot:** `[ ]` A  `[x]` B (tentative)

### Visual overhaul consideration (flagged, not decided)

HitM is weighing "good" vs "professional" design quality. Current design is functional but the question is whether it communicates enough quality to convince a first-time PFM user to trust their finances to it.

| Factor | "Good enough" (current) | "Professional" overhaul |
|--------|------------------------|------------------------|
| First impression | Acceptable | Premium — builds instant trust |
| Development cost | Zero (already built) | 2–4 weeks of focused UI work |
| When to do it | N/A | Before founding member launch? |
| Risk | Users tolerate it but don't feel "wow" | Scope creep; delays features |

> [!NOTE]
> **Not deciding now.** Flagged for revisit when F-011 (public surface) is being built — that's when visual quality matters most because it's the first thing potential founders see. Consider whether the overhaul is a standalone pass or integrated into F-011 scope.

---

## TP9: Efficiency Improvement Avenues

The biggest efficiency gains map to the relief hierarchy above:

| Avenue | Impact | Effort | When |
|--------|--------|--------|------|
| **Automation pipeline** (task queue → agent → test → notify) | 🔴 Critical | High initial, low ongoing | Pre-baby if possible (→ TP5, TP14) |
| **Parallel-safe feature lanes** | 🟡 High | Low (classification exercise) | Now — just decide which features |
| **Standardized smoke bundles** | 🟡 High | Medium | Pre-baby |
| **Simplified governance** (weekly batch updates) | 🟢 Medium | Low | Now |
| **Agent skill files** (reduce context loss) | 🟢 Medium | Medium | Ongoing |
| **PR template enforcement** (auto-doc updates) | 🟢 Medium | Low | Pre-baby |

**The one big bet:** If the automation pipeline works (agent picks up tasks, implements, tests, notifies HitM), it changes everything. HitM's role shifts from 60% coding / 40% admin to 10% coding / 90% admin-and-strategy. This is the relief model that makes the whole post-baby timeline work.

→ This is the critical path item for Session 5 (Tooling & Agents: TP5, TP14).

---

## TP20: Avenues for Increasing Success Chances

Given all constraints discussed, the highest-impact avenues:

| Avenue | Why | Dependency |
|--------|-----|-----------|
| **Nail the wedge features** (F-004, F-001, F-009) | Nothing else matters if the product isn't worth paying for | Feature execution |
| **Automation reliability** | Multiplies HitM's reduced capacity | TP5, TP14 |
| **Family SMM hire** | First human capacity outside HitM | Post-baby + budget |
| **Facebook as primary channel** | PH market is Facebook-first; cheapest distribution | SMM hire + content strategy |
| **Founding member program** | Cash + real users + testimonials in one shot | Entity + PSP + ToS (Q1 2027) |
| **Don't over-scope** | Biggest risk is trying to do everything | Discipline |

**What NOT to chase right now:**
- ❌ Multiple marketing channels (just Facebook first)
- ❌ US market (deferred behind P-6)
- ❌ Android native app (PWA first; Android pull-forward can wait)
- ❌ AI tier features (S1.C; Pro+ AI is after basic Pro is worth paying for)
- ❌ Internal business management software (TP28 — scope creep risk)

---

## TP21: Beta Expansion Protocols

### Current state

- Invite-only beta with ~3 PH family + US grandfathered testers
- No formal feedback channel (DMs to HitM only)
- No mechanism for controlled beta signups

### When expansion makes sense

Beta expansion = S1.B → S1.C transition. There is no intermediate step (confirmed in TP11 Gate 5). Expansion requires:

1. Product worth paying for ✅ (features built)
2. Entity registered + PSP live ✅ (payment possible)
3. Feedback channel exists ✅ (F-012 support intake)
4. ToS / Privacy live ✅ (legal protection)
5. Founding member program ready ✅ (seat cap + lifetime SKU)

### Pre-expansion actions (can start now)

Even without expanding, these improve the current beta:

| Action | Effort | Impact |
|--------|--------|--------|
| **Set up formal feedback form** (even a Google Form) | Very low | Gets structured feedback from existing testers |
| **Monthly check-in with existing testers** | Low | Validates wedge; catches issues before expansion |
| **Document what testers actually use** | Low (if activity logs exist) | Informs feature priority |
| **Draft founding member landing page copy** | Medium (agent-draftable) | Ready when entity + PSP are live |

### Expansion protocol (for when S1.C gates clear)

```
1. Founding member launch (≤100 seats, ₱999–₱1,499 lifetime)
   └── Target: 3 PH family members + personal network first
   └── Then: Facebook page + organic reach

2. Controlled public beta (Pro tier, ₱249/mo)
   └── Gated by: founding seats filling or 6-month window elapsed
   └── Channel: Facebook primarily (→ distribution-channel-research)

3. Success metrics to watch:
   └── Day-30 retention ≥30%
   └── Founding seat take-up within 3 months
   └── Paying user count toward ≥30 for S1.C exit
```

---

## Summary: The Throughline

All five topics converge on one narrative:

> **HitM's capacity is the bottleneck. The strategy is: (1) automate engineering execution so HitM becomes admin/planner, (2) defer everything that isn't core product or automation, (3) add SMM hire as first human relief post-baby, (4) build the "worth paying for" features at sustainable velocity, (5) don't expand until the product and business infrastructure are genuinely ready (~Q1 2027).**

This is a **slow, disciplined path** — and that's fine. The extended timeline from TP11/TP18 removes false urgency. The baby period is a natural decompression that aligns with deferred legal/entity work. Feature development can proceed at whatever pace the automation pipeline + HitM review capacity allows.

The critical fork is **TP5/TP14** (Session 5) — if automation pipelines work, the plan holds. If they don't, the engineering hire deferral needs revisiting.
