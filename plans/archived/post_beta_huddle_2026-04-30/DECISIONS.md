# Decisions — Post-Beta Huddle

Append-only log of locked decisions. Format:

```
## YYYY-MM-DD — Topic <N>: <short title>
**Decision:** <one or two sentences>
**Rationale:** <why this, not alternatives>
**Affects:** <files / docs / plans that need updating>
**Migration:** <what must change as a consequence>
**HitM signoff:** <yes | yes-with-modifications | deferred>
```

Once a decision is logged here, it is locked. Re-opening requires a kill/commit gate review per `_governance/plan_lifecycle.md`.

---

## 2026-04-30 — Topic 2 (high-level): Reflex archival

**Decision:** Reflex frontend is fully archived. Repo retained as historical evidence; removed from all production architecture going forward.
**Rationale:** JS pivot completed during S1 launch sprint; Reflex no longer carries the polish bar; maintaining two frontends doubles ongoing cost without revenue offset.
**Affects:** `finance_manager_reflex/` (whole repo), root `docker-compose*.yml`, `proxy/nginx.bluegreen.conf`, `plans/cursor/strategic-roadmap-reframe-53be/00_strategic_context.md` §3.1, scattered references in `design_docs/`.
**Migration:** Specific scope-per-file is TBD when Topic 2 is opened in detail. The high-level archival is locked; the per-file actions are pending.
**HitM signoff:** yes (high-level confirmed 2026-04-30)

---

## 2026-04-30 — Topic 1: Known issues triage

**Decision:** Seven user-facing issues triaged. Issue 5 (email uniqueness not enforced in DB) is **S0** and the critical distribution-blocker. Full triage in `KNOWN_ISSUES.md`.
**Rationale:** Email uniqueness gap creates auth-collision and password-reset hijack risk; no second user can be safely invited until fixed. Other issues are S1/S2 with clear fix shapes.
**Affects:** `KNOWN_ISSUES.md`, `TALKING_POINTS.md` Topic 1, future drift-cleanup plan packet (Topic 9), eventual sprint board (Topic 11).
**Operational consequences:**

1. No additional invitees until Issue 5 fixed.
2. Audit existing `auth_user` table for duplicate emails before any new user joins.
3. Investigate Issues 4 and 7 jointly (likely shared root).
4. Issue 2 (`+Bill`) blocked on product-design decision before any code fix attempt.

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Topic 11 scope expansion

**Decision:** Post-huddle deliverables expand beyond drift cleanup to include feature roadmaps, implementation guides, and blue-green branching guidelines as a coherent foundation for the next beta sprint.
**Rationale:** HitM intent is to lay full groundwork for the next sprint with all governance, strategic, and execution scaffolding in place; this avoids re-deriving structure mid-sprint.
**Affects:** `TALKING_POINTS.md` Topic 11 expanded, eventual plan packet under `plans/cursor/<branch>/` will be a multi-artifact deliverable, not a single drift-cleanup plan.
**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Topic 4 prerequisite: Vocabulary glossary locked

**Decision:** Canonical vocabulary established across six categories: Phase/Stage/Sprint hierarchy, per-product launch-state model, Plan-type taxonomy, Severity vs Priority, User vocabulary, Sprint vocabulary. Captured in `GLOSSARY.md`.
**Rationale:** Three competing phase models and ambiguous "beta" / "plan" / "roadmap" usage were preventing precise discussion of Topic 4. Glossary lock is a prerequisite for the phase definition overhaul.
**Key terminology lock-ins:**

- Phase / Stage / Sprint hierarchy (3 levels, strict).
- `Phase 1`, `Phase 2`, `Cycle`, `Track` retired.
- Per-product launch-state machine: Concept → Scaffold → Alpha → Tight Beta → Founding Beta → Soft Public Open → Public Launch → Full Public → Sunset → Archived.
- Each product stream (web, api, cli, android, middleware, reflex, future Sari-Sari) has independent launch-state notation: `<product>:<state>`.
- HitM designates a flagship product per Phase; flagship's launch-state determines Phase progression.
- Plan-type taxonomy: Strategic Plan, Execution Plan, Feature Roadmap, Implementation Guide, Branching Guideline.
- Severity (S0–S3) and Priority (P0–P2) are distinct scales; prefix letter mandatory.
- HitM = sole human; agents are workforce.

**Affects:** `GLOSSARY.md` (created), `TALKING_POINTS.md` Topic 4 (re-poses Q1–Q6 in new vocabulary), all future huddle output, eventual migration to `_governance/glossary.md`.
**Migration path:** Glossary moves to `_governance/glossary.md` at Topic 11 close-out as persistent governance artifact.
**HitM signoff:** yes (2026-04-30; with Q-G3 extension for per-product launch states accepted as part of lock)

---

## 2026-04-30 — Topic 4 Q2: S1 Stage split locked

**Decision:** Phase S1 splits into four Stages: `S1.A` Tight Invite Beta, `S1.B` Distribution Readiness, `S1.C` Founding Beta, `S1.D` Soft Public Open. Current operational state: end of `S1.A` transitioning to `S1.B`.

**Locked sub-decisions:**

- **S1.B is research-heavy by design.** Internal sub-Sprints required for entity structure (US LLC vs OPC), payment provider selection, GCash/Maya integration legality for US-incorporated business. The research IS the work.
- **Mobile wallet payment support is a hard constraint.** GCash/Maya must be primary payment method, not a fallback. "Forcing PH users to have a credit card is a financial death sentence."
- **Ads rejected as revenue vector** (see `PARKING_LOT.md` P-3).
- **ZK model preserved** as primary user-data posture; user-data monetization rejected. S5 (ZK middleware) elevated from "magnum opus / clout play" to "structural revenue defense" — without it, the only revenue paths are subscription + B2B (S6) + curated partners (P-4).
- **Android product stream pulls forward:** `android:Scaffold → android:Alpha` during S1.B; `android:Tight Beta` during S1.C. S3 re-scoped to "Android scaling and feature parity" instead of "Android initial build." Affects Q6 calendar.

**Rationale:** Reflects actual operational reality (current Tight Beta state) and HitM's substantive constraints (no investor capital, mobile-wallet-first PH market, ZK-not-data-monetization brand position). Pull-forward of Android matches PH-mobile-first wedge.

**Affects:**

- `00_strategic_context.md` (will gain new locked decisions: mobile-wallet primacy, ads rejection, ZK as revenue defense, Android pull-forward)
- `validation_gates.md` S1 (will gain Stage-level entry/exit triggers)
- `01_unit_economics_and_costs.md` (pricing tier infrastructure must support GCash/Maya as primary)
- `phases/S1_public_beta_position.md` (re-scoped to be Stage-aware; S1.A is current, S1.B is next)
- `phases/S3_mobile_offline_first.md` (re-scoped from "Android initial" to "Android scaling")
- `PARKING_LOT.md` (newly authored; captures P-1 through P-5)

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Topic 4 Q3: Desktop product stream locked

**Decision:** `desktop:Concept`. Tracked as a future product stream with no scheduled work and no Phase commitment. Roadmap mentions exist for awareness only.

**Rationale:** HitM characterized as "concept, not entirely an executable item for now, but a strong consideration for later." Self-hosted single-binary form factor remains a defensible niche but doesn't compete for attention with web/Android primacy in current Phases.

**Affects:**

- Per-product launch-state map in `GLOSSARY.md` §8 (will add `desktop:Concept` row).
- `00_strategic_context.md` §4 (rejected/deferred options note: original "Track E Desktop standalone" reframed as `desktop:Concept` future stream).

**Trigger to revisit:** Specific user demand emerges, OR S5+ when ZK middleware brand asset can support a "self-hostable" sales pitch.

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Parking Lot established

**Decision:** Five deferred-decision items captured in `PARKING_LOT.md`: P-1 (GCash/Maya partnership), P-2 (US + PH dual-entity split), P-3 (ads rejected — locked), P-4 (curated affiliate revenue), P-5 (sponsored partnership at scale).

**Rationale:** These items are substantial enough to need formal future consideration but inappropriate to decide now. Parking lot prevents loss of strategic context while keeping active plans uncluttered.

**Affects:** `PARKING_LOT.md` newly authored; will be reviewed at every Phase transition; items get promoted/lifted/discarded as triggers fire.

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Topic 4 Q4: AI tier timing locked (tentative)

**Decision:** **Option (b) — tentative.** Pro+ AI tier ships at `S1.C` (Founding Beta entry). Final commitment pending the AI Economics Deep-Dive resolution within S1.B.

**HitM Founding Beta framing:** "Lifetime access to all future features" with AI features specifically gated, potentially with tiered upgrades and credit-pack discounts for founders.

**Required S1.B workstream:** AI Economics Deep-Dive. 16 interlocking decisions (see `TOPIC_4_QUESTIONS.md` Q4) covering LLM provider/model selection, pricing structure, profitability bounds, UX behavior at caps, and founder-specific gating. S1.B cannot close (and S1.C cannot open) without this resolved.

**Pushback flagged for HitM consideration:**

- "Lifetime access to all future features" is more generous than industry-standard lifetime deals.
- Specific risks: future product streams (Android Pro, Desktop Pro), future pricing tier reshuffles, unbounded AI inference cost growth.
- Industry comparables: Sublime Text (current major version only), AppSumo (feature-set-at-purchase), Bear/Things (sister apps separate).
- Alternative framing offered: "lifetime Pro tier + lifetime access to Pro+ AI features with PAYG consumption at 50% discount; new product streams negotiated at launch." HitM to consider before locking final founder marketing copy.

**Rationale:** AI tier as the largest *recurring* revenue lever (given ads + user-data sales rejected) makes it strategically important to validate at Founding Beta. Pull-forward to S1.C gives Founding members a meaningful product, not a stripped-down version. But the unit economics are non-trivial at 100+ founder lifetime commitments.

**Affects:**

- `01_unit_economics_and_costs.md` (will be revised after AI Economics Deep-Dive)
- `phases/S1_public_beta_position.md` (S1.B gains AI Economics Deep-Dive workstream; S1.C entry trigger gains "AI tier infra + AI economics decision live")
- `00_strategic_context.md` §3.5 (AI Credits Model - timing updated from S2 to S1.C tentative)

**HitM signoff:** tentative yes (2026-04-30); final lock after deep-dive completion in S1.B.

---

## 2026-04-30 — Topic 4 Q5: Public Launch placement + PH-first market pivot

**Decision:** **Option (f) — locked.** PH-first multi-event launch sequence with US re-engagement deferred behind a trigger condition.

**Strategic pivot — PH-only market focus (locked):**

Going forward, all marketing, distribution, content, and product decisions optimize for PH first. US presence continues passively — webapp accessible globally, existing testers grandfathered as Honorary Founders — but no US-targeted acquisition until specific trigger conditions are met.

This is not a strategy change so much as a clarification of the wedge that already pointed PH-first. The original strategic context already named "thin-margin PH households" as the primary persona; this lock removes the pretense of dual-market focus.

**Multi-event PH launch sequence (locked):**

- **Founding Beta launch (S1.C):** PH primary. PH Paying Founders (paying lifetime seats) + US Honorary Founders (grandfathered free). Founder badges differentiated; both publicly acknowledged.
- **PH Soft Public Open (S1.D):** Anyone can sign up; pricing visible; low-key promotion only.
- **PH Public Launch (S2 mid):** Active PH distribution (PH-local creators, FB groups, OFW communities, content cadence).
- **PH Full Public (S2 exit):** Steady-state production in PH.

**US re-engagement (deferred decision):**

- *Concept locked:* US re-engagement happens when ZK middleware (S5) or its dev-channel reputation work (S4) is shippable. The technical and marketing prerequisites for US re-entry naturally align with S5 timing.
- *Exact Phase label deferred:* Could be `S5.A` (sub-stage of S5), a separate Phase (e.g. SU), or a workstream that runs alongside S5 main work. Decision deferred to S1.B → S1.C transition decision point.
- *Trigger condition deferred:* Specific quantitative trigger (e.g. PH MRR ≥ ₱200k/mo for 6 months, or ZK middleware audit-complete, or specific inbound demand) deferred to S1.B → S1.C transition decision point.
- *Reasoning for deferral:* Concept makes sense; specifics depend on PH market reception and S2/S3/S4 execution evidence not yet available.

**Asymmetric pricing for US users (locked):**

- **US Honorary Founders:** continued free Pro tier access; grandfathered. Distinct from PH Paying Founders.
- **AI tier in S1.C:** PH-only initially; not available to US users until PH AI economics validated.
- **AI for US (post-PH-validation, post-trigger):** USD-equivalent pricing (e.g. $7.99/mo Pro+ AI), inference paid in USD at PH margin economics. Currency conversion fees passed through.

**Pushback acknowledged + accepted:**

- Deferral-becomes-permanent risk → addressed via trigger condition requirement (deferred but mandatory).
- US testers as consolation prize risk → addressed via Honorary Founder badge + asymmetric pricing model.
- Personal income vs business income conflation → acknowledged; HitM will treat as separate streams.

**Affects:**

- `00_strategic_context.md` — major revision: priority regions reframed; US/EU posture changed.
- `01_unit_economics_and_costs.md` §2 — US pricing tier becomes deferred / passive; PH pricing becomes primary.
- `phases/S2_*.md` and beyond — PH-only market focus during S2 onward; US re-engagement is a separate workstream.
- `PARKING_LOT.md` — new entry P-6 (US Re-engagement Trigger Definition) deferred to S1.B → S1.C transition.

**Pending decisions seated for S1.B → S1.C transition:**

1. US re-engagement Phase placement (S5.A vs separate Phase vs workstream).
2. US re-engagement trigger condition (specific quantitative gate).
3. AI tier final commitment (current Q4 Option (b) tentative).

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Topic 4 Q6: Calendar comfort + overwork-pattern structural input

**Decision:** **Calendar accepted as proposed** (S1.A complete; S1.B May–Jul 2026; S1.C Aug–Oct 2026; S1.D Nov 2026–Feb 2027; S2 Mar–Sep 2027; S3+ overlaps subsequently).

**Structural input flagged for Topic 8 — HitM overwork pattern:**

HitM identified a real personal risk: tendency to hyper-fixate and overwork (ADHD-driven dopamine pattern). Causes home friction; expected to be partially mitigated by baby's schedule but needs structural support. Cannot be left to willpower.

**Topic 8 must operationalize:**

1. **Cursor usage cap as forcing function.** When monthly Cursor cap hits, work stops. No overages purchased. Reframes cost-discipline as health-discipline.
2. **Sprint duration minimums.** Even when work could be done in 2 days, schedule Sprint as 1 week to prevent cascade.
3. **Hard off-time defaults.** Specific evening/weekend boundaries to be set.
4. `**kill_commit_gates.md` §6 quarterly review** becomes operational with calendar reminders.

**Rationale for capturing here:** Topic 4 calendar realism depends on Topic 8 enforcing sustainable cadence. If the velocity ceiling isn't enforced, the calendar compresses (HitM works through decompression), then breaks (burnout / family friction). Calendar acceptance is conditional on Topic 8 producing real operational mechanisms.

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Topic 4 Q1: Canonical model lock (wrap-up)

**Decision:** **Option (a) — locked.** Strategic Plan structure (S1–S6 in `plans/cursor/strategic-roadmap-reframe-53be/`) is canonical going forward. Old `Phase 1` / `Phase 2` docs in `design_docs/20_Roadmap/` become historical reference only.

**Substantial content revision queued for Topic 11 close-out:**

The S1–S6 *structure* survives this huddle, but the *content* of nearly every Phase changes per Q2–Q6 outcomes. See `TOPIC_4_QUESTIONS.md` Q1 for the per-Phase revision matrix.

**Topic 4 status:** **closed.** All six questions answered and locked (with Q4 tentative pending S1.B AI Economics Deep-Dive). Topic 5 (Public Launch milestone) effectively merged into Topic 4 Q5 — no separate Topic 5 work needed.

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Topic 3: JS pivot retro-formalization closed

**Decision:** Topic 3 closed. JS pivot completion formally recognized; `web` confirmed as flagship product. Lessons learned captured for migration to `00_strategic_context.md` §6 at Topic 11 close-out.

**Lessons learned (to be written to strategic context):**

1. **AI-orchestrated frontend development is feasible at velocity.** Tech timelines weight toward "fast" defaults; distribution timelines weight toward "slow." Bottleneck is humans, not agents.
2. **API-first discipline paid off.** Frontend framework swap clean because API contract was the firewall. Maintain strict API-first discipline as structural protection.
3. **Multi-agent parallel coordination worked at execution level, but handoff mechanics need work.** In practice, sprint became "build everything at once and rebuild," not disciplined per-plan handoffs. Topic 11 must realign orchestration layer around new S1.B goals.
4. **Conscious owner-approved deviations need automatic follow-up tracking.** The `+Bill` hotfix wasn't an AI failure — it was a deliberate owner tradeoff during launch. Drift risk came from forgetting to schedule the cleanup. Topic 9 should formalize "approved deviation → immediate follow-up task" workflow.
5. **Sprint compression risk identified.** 3-day pivot velocity is exactly the work-pattern Topic 8 needs to constrain. One-time success doesn't make it a habit.
6. **Agent identity separation (GitHub/Slack) — research item.** Operational benefit small for solo HitM; defer to Topic 11 research. Revisit when adding second human collaborator OR considering automated PR auto-merge.
7. **Automation is not always desirable.** Manual merge-after-confirmation is a verification gate, not bureaucracy. For solo HitM with multiple agents, manual merge is one of the few places "is this actually working?" gets externally validated. Default: agents prepare automation-ready outputs; humans commit irreversible actions.

**Topic 11 follow-ups carried forward:**

1. Orchestration layer realignment around S1.B goals (per Lesson 3).
2. Hotfix-with-followup-tracking workflow (per Lesson 4).
3. Agent identity research as deferred decision (per Lesson 6).
4. Lessons section migration: write Lessons 1–7 to `00_strategic_context.md` §6 (or `LESSONS_LEARNED.md` if HitM prefers).

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Topic 2: Reflex archival per-file scope locked

**Decision:** Full per-file scope locked. Reflex archival is folded into Topic 9 drift cleanup as a sub-Sprint within S1.B. S1.B exit cannot occur until Reflex archival is complete (S1.B must be "fully clean").

**Removal targets (production-path code, ~2-3 PRs total):**

- `docker-compose.yml`: remove Reflex service block.
- `docker-compose.bluegreen.yml` + `docker-compose.bluegreen.parallel.yml`: remove `reflex-blue` and `reflex-green` services.
- `proxy/nginx.bluegreen.conf` + `proxy/nginx.conf`: remove Reflex hostname routing.
- `scripts/server/create_runtime_bundle.sh`: remove `finance_manager_reflex/` from bundle includes.
- `scripts/fm_services.sh`: remove Reflex local-services commands if present.
- `finance_manager_api/finance_api/settings.py`: remove `reflex-api.thehivemanager.com` from CORS / CSRF defaults.
- `deploy/server.env.example`: remove Reflex env vars.

**Documentation targets (handled at Topic 11 close-out via design-docs-sync):**

- Reflex references in `design_docs/20_Roadmap/`, `design_docs/40_System_Design/`, `design_docs/10_Current_State/`, `AGENTS.md`, `.cursor/rules/*.mdc`.

**Retention (preserve):**

- `finance_manager_reflex/` repo: kept as historical artifact; add `ARCHIVED.md` at root with date + reason + pointer to `00_strategic_context.md` archival decision. Submodule pointer in parent repo stays frozen at last commit.
- All historical CHANGELOG entries.
- `finance_manager_web/src/lib/breakpoints.ts` Reflex-style breakpoint patterns (code is fine; remove "current"-implying comments).
- All historical execution plans referencing Reflex (`plans/feat/web-reflex-parity-sweep-1/`, etc.).

**Branch handling:**

- `fix/reflex-dashboard-ui-regression` (uncommitted CHANGELOG + CSS changes): **abandon**. No commit, no merge. No regression to Reflex.
- Any other open Reflex branches: same.

**External handling:**

- Cloudflare tunnel for `reflex-api.thehivemanager.com`: torn down by HitM 2026-04-30.

**Execution order (sub-Sprint within Topic 9 drift cleanup):**

1. Add `ARCHIVED.md` to `finance_manager_reflex/` repo root (pointer-only content).
2. Abandon uncommitted Reflex branches.
3. Remove Reflex from compose files.
4. Remove Reflex routing from proxy.
5. Remove Reflex from runtime bundle script + env files + API settings defaults.
6. Topic 11 design-docs-sync handles documentation cleanup.

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Topic 6: Distribution readiness gap closed

**Decision:** Distribution readiness scope locked. Most infra side already captured by S1.B research workstream (entity, payments, billing, founding member program). Channel side defined at framework level; specific research deferred to S1.B marketing workstream.

**Locked elements:**

- **Q6.1 — Channel research deferred to S1.B.** AI's PH market knowledge has Western bias and is unreliable for channel selection. Anchored on: Facebook business page (primary PH vector), AI video stories using HitM's personal Gemini Pro asset (separate from project overhead) leveraging PH cultural preference for AI-drama formats, family/friend word-of-mouth seed.
- **Q6.2 — Cadence framework defined.** Cadence = how often + what shape + where + who. Default starting cadence (subject to S1.B marketing research): monthly AI video story (high-effort) + weekly educational post (mid-effort) + ad-hoc personal narrative posts (low-effort). All anchored on Facebook initially.
- **Q6.3 — Pre-S1.C founding interest seed locked.** 3 PH family members already interested without seeing the full app, including 1 Sari-Sari owner (provides S6 future-validation viewport). To be engaged formally at S1.C founding beta launch with founder badge.
- **Q6.4 — "Worth paying for" requirement locked as S1.C entry trigger.** "P200/mo is a significant decision" in PH context; product must be demonstrably worth more than a notebook before founding beta opens.
  **NEW S1.C entry trigger (additive, locked):** "Product is demonstrably worth ₱200/mo paid tier vs free tier vs notebook substitute." This is on top of the original S1.C entry triggers (S1.B exit met, AI economics deep-dive complete, billing infra live).
  **Implication for S1.B scope:** S1.B is not just research — it includes feature work that makes paid tier obviously valuable. Candidate features (final list is Topic 11): AI safe-to-spend forecasting, automatic GCash/Maya parsing, family ledger, bill payment reminders, recurring expense automation, historical pattern analysis, export/sharing, OFW-tax-relevant categorization.
- **Q6.5 — Wedge polish in S1.B.** Confirmed.

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Topic 7: Wedge audit + landing polish queue closed

**Decision:** Wedge audit and landing polish queued as part of S1.B "worth paying for" workstream. Specific implementation:

- **Q7.1 — Hero copy edit:** **Option (b) — bundle with larger landing redesign.** Single-line wedge sentence not added now; will be integrated as part of substantive landing polish.
- **Q7.2 — Larger splash polish:** **Option (a) — S1.B as part of "worth paying for" metrics.** Strategic note from HitM: "PH-based things are ad heavy and unreactive, and have very obviously lag. Bringing US quality and polish to the PH community will be welcome." This makes landing polish a *differentiation move*, not just brand consistency.
- **Q7.3 — Wedge consistency audit:** Confirmed; folded into Topic 11 consolidation work (alignment of future agents and design implementations).
- **Q7.4 — AI video stories alignment:** **Deferred to S1.B marketing research.** HitM skeptical about loosely-coupled AI-video-to-product attribution. Three framings noted for evaluation: (1) story directly integrates product use, (2) AI video used for founder/trust content not conversion, (3) skip AI video entirely. To be revisited during S1.B marketing research.

**Implication for S1.B:** "Worth paying for" workstream now explicitly includes landing polish + wedge integration into hero. This is on top of feature work (Topic 6 Q6.4) and research workstreams (entity, payments, AI economics).

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Topic 8: Velocity + Cursor cost management closed

**Decision:** Six mechanisms locked to operationalize sustainable cadence.

**Q8.1 — Cursor cap as forcing function:**

- No overage purchases, period.
- Current cycle: 57% used as of 2026-04-30; refresh 2026-05-28.
- Plan: use remaining credits on huddle + research before opening next major Sprint.
- **Calendar implication:** next Production Sprint opens ~2026-05-28 onward.

**Q8.2 — Sprint duration minimums (locked):**

- Production Sprint (ships code to VPS): 1 week minimum
- Maintenance Sprint (bugfix-only): 3 days minimum
- Research Sprint (no code): 1 week minimum
- Calendar slot, not work hours; some hours within slot allowed
- Re-evaluate at next huddle if friction surfaces.

**Q8.3 — Hard off-time defaults (locked):**

- **Daily ceiling: 10 hours/day max** PFM work
- **Weekly ceiling: 55 hours/week max** PFM work
- Forces at least one slow/off day per week (since 7 × 10 = 70 > 55).
- Specific off-day not enforced; HitM aims for Sundays but real-life commitments may shift it.
- Local Cursor "time clock" agent tracks both; pings warning at 9hr daily / 50hr weekly; enforces stop at 10/55.

**Q8.4 — Decompression cadence (locked):**

- Variable duration; minimum 3–5 days off after each Production Sprint.
- During decompression: bug fixes only, no new feature scoping, no new agent work.
- Decompression sessions include huddles (planning continues; only execution pauses).

**Q8.5 — Monthly LLM cost audit (locked):**

- First execution: 2026-05-01 (tomorrow).
- Cadence: 1st of every month, ~30 minutes.
- Includes: Cursor usage % vs cap, LLM API costs (when AI tier ships), VPS infra costs, all subscription overhead.
- Per `01_unit_economics_and_costs.md` §6.

**Q8.6 — Cursor cap data:** Already captured in Q8.1.

**New deliverables surfaced for Topic 11:**

1. Local Cursor "time clock" agent — daily + weekly hour tracking, threshold pings, enforcement on cap breach.
2. Huddle facilitation agent skill — encode the conversational pattern, structured topic-list approach, lock-and-decision tracking, parking-lot mechanism, glossary-first grounding into a reusable skill.

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Topic 9: Drift cleanup queue closed

**Decision:** Six work groups (A–F) ordered for execution during S1.B → S1.C transition.

**Group A (immediate, ~3 days):**

1. Topic 11 close-out (this huddle's deliverables)
2. Monthly LLM cost audit (first run 2026-05-01)

**Group B (S1.B early, order (c) locked — small/urgent first):**

3. `+Bill` hotfix → git (5-minute commit)
4. Email uniqueness S0 fix (highest severity; before any new user contact)
5. Reflex archival (per Topic 2 detailed scope)
6. Pre-governance plans close-out
7. Issues #1, #4, #7 (recurring expense edit, calendar populate, heatmap intensity; #4+#7 investigated jointly)

**Group C (S1.B research-heavy, sequential):**

8. Entity formation research (US LLC vs OPC)
9. Payment provider research (Stripe vs PayMongo vs Xendit; GCash/Maya legal)
10. AI Economics Deep-Dive (16 questions per Q4)
11. Distribution channel research (PH-local; AI video framing)
12. Wedge consistency audit (slip-in; ~1 hour)

**Group D (S1.B feature work, sequential after C):**

13. Landing polish + wedge integration into hero
14. Issue #2 — +Bill rework (**design resolved 2026-04-30:** "quick pay bill that seeds a transaction with relevant data from the bill being paid"; specialized form to be drafted)
15. Issue #3 (quick-add fullness)
16. Issue #6 (mobile dashboard quick buttons)
17. "Worth paying for" feature additions (HitM has existing feature backlog)

**Group E (infrastructure/tooling, parallel low-priority):**

18. Local Cursor time-clock agent setup
19. Huddle facilitation agent skill creation
20. Hotfix-with-followup-tracking workflow (per Lesson 4)

**Group F (S1.C entry prep, after Groups C+D):**

21. Founding member program backend (seat cap, lifetime SKU, badge)
22. Pricing page + chosen payment processor live (PHP-anchored)
23. ToS + privacy policy + refund policy

**Bonus — Issue #2 +Bill design resolved:** "Quick pay bill" seeds a transaction pre-populated with bill data + structure. Will need specialized form. Moves from design-decision-pending to feature-implementation-queued.

**Wedge consistency audit scope (proposed):**

- Static product surfaces (landing, dashboard KPI labels, onboarding, settings)
- Public docs (README, ToS, privacy)
- Social/content surfaces (FB business page, future app store description, content cadence posts)
- Consistency = wedge sentence OR explicit thematic alignment
- Weekly automated scan via local agent + quarterly deep HitM review

**Q9.4 — orchestration realignment:** Deferred to Topic 11 close-out as part of governance/strategic update package.

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Topic 10: Family / personal cadence closed

**Decision:** Four mechanisms locked. Personal constraints captured as strategic context inputs (not separate decisions; folded into `00_strategic_context.md` §7).

**Q10.1 — Velocity assumption corrected:**

- Baby due 2026-06-15. HitM is currently at full pre-baby velocity through ~mid-June.
- Original "30–50% velocity loss from 2026-06 through 2026-12" still holds, but starting point is mid-June, not now.
- **Strategic implication:** front-load deep-focus research workstreams (entity, payments, AI economics) into May–early June pre-baby window. Implementation and feature work are more interruption-tolerant and can land post-baby.

**Q10.2 — First quarterly self-review locked:**

- Date: **2026-06-30** (calendar quarter end + ~2 weeks post-baby)
- Format: written answers to three questions per `kill_commit_gates.md` §6
- Cadence going forward: every calendar quarter end (2026-09-30, 2026-12-31, etc.)
- Calendar reminder to be set as part of Topic 11 deliverables.

**Q10.3 — Decompression ceiling locked:**

- During Decompression: **6 hours/day max, 30 hours/week max** (vs 10/55 during Sprints).
- Tentative reversion to (c) "discretion" possible later; revisit after next Sprint completes (post-S1.B).
- Rationale: decompression must actually decompress; 10hr/day on bug fixes during decompression is just a smaller Sprint.

**Q10.4 — Personal constraints (captured as strategic context inputs):**

- **Visa trip:** one day; date TBD; calendar block when scheduled.
- **Wedding day:** legal marriage in process; calendar block when scheduled.
- **₱100/mo runtime cost cap:** hard ceiling; new infrastructure proposals must fit or are blocked.
- **Monthly savings target cycle (current: April):** may affect month-by-month budget priority; current cycle releases 2026-05-01.
- **Exercise routine / gym:** cost-blocked currently; not infrastructure-blocking; future concern.

**Migration target:** `00_strategic_context.md` §7 "Personal Operating Constraints" (new section). Future agents inherit these; saves explanation cycles when proposals would conflict.

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Topic 11: Branching workflow + plan hierarchy locked

**Decision Q11.2 — Feature-branching workflow locked (per-feature color cycle):**

```
new-feature-branch (cursor/s<phase><stage>/feat/<name>) on inactive color
  ↓
  current-task-branch (cursor/s<phase><stage>/feat/<name>/t<NN>-<slug>)
    → PR, validate, merge into new-feature-branch
  current-task-branch (next task)
    → PR, validate, merge into new-feature-branch
  ...
  ↓
new-feature-branch complete
  → PR to main + color flip (deploy)
```

**Q11.2.a — Concurrency:** **One feature at a time on inactive color.** Cleaner mental model for solo HitM operator.
**Q11.2.b — Bug fix handling (severity-dependent):**
- Minor / non-UX-destroying bugs: bundle into next color flip with the active feature batch.
- P0 / S0 bugs: hotfix branch from main → fix → color flip → resume feature on (now-inactive) color, re-rolling fix into next batch.
**Q11.2.c — Color flip cadence:** **Each fully-implemented feature triggers a flip.** Rollback safety prioritized over throughput.
**Q11.2.d — Cutover protocol:** Existing `pre_deploy` + `pre_cutover` Slack gates apply per feature flip.

**Decision Q11.3 — Hierarchical plan structure locked:**

```
plans/cursor/<phase><stage>/                    e.g. plans/cursor/s1b/
  ├── README.md                                  Stage summary + sub-plan index
  ├── <sub-plan-name>/                           e.g. drift-cleanup/
  │   ├── README.md                              Plan metadata + body
  │   ├── tasks/
  │   ├── validation_gates.md
  │   └── ...
  └── <sub-plan-name>/                           e.g. entity-formation-research/
```

- Stage-level README at `plans/cursor/<phase><stage>/README.md` is the dashboard.
- Sub-plans inherit Stage context; declare `parent_plan: plans/cursor/<phase><stage>/` in metadata.
- Branch names follow hierarchy: `cursor/s1b/<plan-name>` or `cursor/s1b/feat/<feature-name>` per Q11.2.
- Strategic Plan stays at top level (`plans/cursor/strategic-roadmap-reframe-53be/`); not Stage-scoped.
- **Pre-existing plans NOT retroactively moved.** They stay at current paths; new plans use hierarchical pattern.
- Pattern hard-coded for agents in governance sweep (deliverable in this Topic 11 close-out).

**Decision Q11.4 — Execute close-out NOW.** Full sweep. Larger Cursor budget allocation than typical to ensure next Sprint starts clean and credit-efficient.

**Plan template metadata addition:** new optional field `parent_plan: <path>` for hierarchical plans (informational; directory hierarchy is canonical).

**HitM signoff:** yes (2026-04-30)

---

## 2026-04-30 — Personal constraint correction

**Correction:** "Heavy savings target this month" was misleading phrasing. HitM's pay schedule lands end-of-month; the savings target applies to **May**, not April. April 30 is the end of the funded period; May is the constrained spending month.

**Captured in:** `00_strategic_context.md` §7 (Personal Operating Constraints) when written.

---

*(append below as decisions are reached)*