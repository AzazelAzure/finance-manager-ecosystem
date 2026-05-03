# Talking Points — Post-Beta Huddle

Per-topic record. Each topic moves through: `pending` → `discussing` → `decided` (or `deferred`).

Update freely as discussion progresses. Decisions migrate to `DECISIONS.md` when locked.

---

## Topic 1: Known issues sweep

**Status:** `decided` (2026-04-30)
**Owner:** HitM (supplied list); agent (triaged)

### Background going in

- HitM mentioned a critical issue that blocks "any sort of useful distribution concerns."
- HitM also has additional non-critical issues from personal beta use.
- `+Bill` quick-add disable is one known item but explicitly NOT the critical one.
- New design doc `40_System_Design/15_Beta_Week_Incident_Triage_and_Human_Gated_Autofix_Contract.md` defines the S0–S3 severity rubric — use that for triage.

### Open questions

- ~~What is the critical distribution-blocker?~~ → **Issue 5: Email uniqueness not enforced in DB (S0)**
- ~~What other issues are on the list?~~ → 7 items; full triage in `KNOWN_ISSUES.md`
- ~~Are any of them already on someone's radar (existing branch, draft PR)?~~ → None of the seven, per HitM

### Discussion notes

- 2026-04-30: HitM clarified the bugs/issues distinction — they label all "user-facing issues" because that's how they present to a user. Agent split them into 3 work-shapes: bugs (#1, #4, #5, #7), design decisions (#2), feature gaps (#3, #6). HitM acknowledged the distinction.
- 2026-04-30: HitM confirmed Issue 5 (email uniqueness) is the S0 distribution-blocker. DB enforces username uniqueness only; email column has no unique constraint.
- 2026-04-30: Issue 6 re-rated S3 → S2 due to mobile-first PH wedge persona.
- 2026-04-30: Safe-to-spend confirmed as working correctly and prominently displayed in dashboard KPI (top-level visual on dashboard load). Calculation in API → snapshot payload → JS display. Hero-page placement is the only open wedge question (Topic 7).
- 2026-04-30: HitM confirmed QoL items deliberately left off this list, none are distribution-blocking, will be addressed in feature-roadmap conversation post-Topic 4.

### Decision

Triage locked. See `KNOWN_ISSUES.md` for full record. Summary:

- **P0 (distribution-blockers):** #5 email uniqueness (S0), #1 recurring expense edit (S1)
- **P1 (pre-scaling beta):** #7 calendar populate (S1/S2), #4 heatmap intensity (S2; likely shared root with #7), #6 mobile quick buttons (S2; wedge-relevant)
- **P2 (design/feature work):** #2 +Bill rework (S2; design decision pending), #3 quick-add fullness (S2; feature gap with workaround)

**Operational consequences locked:**

1. **No additional invitees until Issue 5 (S0) is fixed.** Tight beta stays at current invitee set.
2. **Audit existing `auth_user` table for duplicate emails before next user joins.** Even if no new invitees, current testers may have collisions.
3. **Investigate Issues 4 and 7 jointly** — likely shared root cause; avoid double-fixing.
4. **Issue 2 design decision is required input** before any agent attempts to "fix" the +Bill flow.

---

## Topic 2: Reflex archival scope

**Status:** `decided` (2026-04-30, full per-file scope locked)
**Owner:** agent (drafts scope); HitM (approves)

### Background going in

- HitM 2026-04-30: Reflex is a **complete archive**. Repo retained as historical evidence; removed from all architecture going forward.
- Currently in flight on Reflex: `fix/reflex-dashboard-ui-regression` branch with uncommitted changes — zombie work, needs decision.
- Reflex containers already stopped per BP7 snapshot; not in live request path.

### Open questions

- What specifically gets removed and from where:
  - `docker-compose.yml` (root) — Reflex service block
  - `docker-compose.bluegreen.yml` — `reflex-blue` / `reflex-green` services
  - `proxy/nginx.bluegreen.conf` — Reflex hostname routing
  - `.secrets/server.env.example` — Reflex env vars
  - `scripts/fm_*.sh` — Reflex commands
  - `design_docs/reflex_docs/` — keep or move to historical?
  - `design_docs/20_Roadmap/Reflex_Feature_Roadmap.md` — keep, archive, or delete?
  - References across Phase 1/2 docs and strategic roadmap
- The uncommitted Reflex branch (`fix/reflex-dashboard-ui-regression`) — abandon, archive, or merge for completeness?
- Submodule pointer in parent repo: leave at last commit, or freeze with an `ARCHIVED` marker?
- Strategic context (`00_strategic_context.md` §3.1): change "Reflex→JS pivot deferred to S2" to "JS pivot complete, Reflex archived 2026-04-30."

### Discussion notes

- 2026-04-30: HitM confirmed full archival; repo retained for history only.

### Decision (high-level, awaiting scope detail)

- Reflex repo: retained as read-only historical artifact.
- Reflex from production architecture: removed.
- Specific scope per-file/per-doc: TBD when this topic is opened.

---

## Topic 3: JS pivot retro-formalization

**Status:** `decided` (2026-04-30)
**Owner:** agent

### Background going in

- HitM 2026-04-30: still in S1 (this is a tight invitation-only beta, not a public launch).
- JS pivot was previously documented as S2 work in `00_strategic_context.md` §3.1.
- Reality: pivot completed during S1 launch sprint. `finance_manager_web` is the production frontend.
- Strategic roadmap S2 had three pillars: GCash/Maya, AI tier, JS pivot. Two of those still apply; one is done.

### Open questions

- Is "S1" now the right label, or do we need a sub-phase (S1-Beta vs S1-Launch)?
- How do we want to formalize that the JS pivot landed early without re-scoping S2?
- Should the strategic roadmap's S2 entry triggers be relaxed (since the pivot prerequisite is met)?
- Does the web app's BP7 polish constitute "feature parity demo" milestone for S2 exit, or is that still ahead?

### Discussion notes

- 2026-04-30: HitM framing suggests this is still S1 because it's an invite-only beta, not a public launch. That implies S1 has internal phases we haven't named.

### Decision

*(none yet — depends on Topic 4 outcome)*

---

## Topic 4: Phase definition overhaul

**Status:** `decided` (2026-04-30)
**Owner:** agent (drafts reconciled phases); HitM (approves)

### Background going in

- Three phase models currently coexist:
  1. `design_docs/20_Roadmap/Roadmap_Overview.md` — original `Phase 1` (Alpha Stabilization), `Phase 2` (Beta Preparation), Post-Beta Tracks A–E.
  2. `design_docs/20_Roadmap/Phase_1_Alpha_Stabilization.md` and `Phase_2_Beta_Preparation.md` — original detail.
  3. `plans/cursor/strategic-roadmap-reframe-53be/` — S1–S6 strategic Phases.
- These three do not agree on what beta means, what comes after beta, or how Track A–E features map to Phase numbers.
- HitM explicitly named this as a required exit deliverable.
- 2026-04-30: Vocabulary grounding completed; canonical terms locked in `GLOSSARY.md`. Old `Phase 1`/`Phase 2`/`Cycle`/`Track` retired; per-product launch-state model adopted.

### Open questions (in canonical vocabulary)

- **Q1 — Canonical model lock:** Strategic Plan (`plans/cursor/strategic-roadmap-reframe-53be/`) is canonical; old `Phase 1` / `Phase 2` docs become historical reference only — confirmed?
- **Q2 — S1 Stage split:** `S1.A` Tight Invite Beta → `S1.B` Distribution Readiness → `S1.C` Founding Beta → `S1.D` Soft Public Open — right shape?
- **Q3 — Desktop product stream:** Original Track E was Desktop standalone (single-binary, local SQLite). Keep as a product stream (give it its own launch-state progression), defer (note but unscheduled), or drop?
- **Q4 — AI tier timing:** Pro+ AI tier (per `01_unit_economics_and_costs.md` §2) — stays in S2, pulls forward to S1.C/S1.D, or slips later?
- **Q5 — Public Launch placement:** At Stage `S1.D`, mid-S2 (after AI tier), or `S2` exit?
- **Q6 — Calendar comfort:** S1 (S1.A current, S1.B–D May–Dec 2026), S2 (Q1–Q3 2027), S3 (Q3 2027–Q2 2028 overlapping S2), etc. Right ranges, or different framing?

### Discussion notes

- 2026-04-30: Glossary established as prerequisite. Phase / Stage / Sprint hierarchy locked; per-product launch-state model locked. ADHD context noted; tangents may be parked here between sessions.

### Decision

*(none yet — Q1–Q6 pending)*

---

## Topic 5: Public launch milestone definition

**Status:** `decided` (2026-04-30) — merged into Topic 4 Q5 + Q6 outcomes.

### Resolution summary

Topic 5's questions were directly answered by Topic 4 Q5 (multi-event PH-first launch sequence) and Q6 (calendar). No separate Topic 5 work required.

- **Public launch placement:** Multi-event PH-first — Founding Beta (S1.C) → PH Soft Public Open (S1.D) → PH Public Launch (S2 mid) → PH Full Public (S2 exit). US re-engagement is a separate later event (P-6 deferred).
- **Calendar:** S1.A complete → S1.B May–Jul 2026 → S1.C Aug–Oct 2026 → S1.D Nov 2026–Feb 2027 → S2 Mar–Sep 2027.
- **Stage gates:** Each Stage has entry/exit triggers per `validation_gates.md` revision (queued for Topic 11).

See `TOPIC_4_QUESTIONS.md` Q5 + Q6 and `DECISIONS.md` for full locks.

---

## Topic 6: Distribution readiness gap

**Status:** `decided` (2026-04-30)
**Owner:** HitM (lists gaps); agent (sequences)

### Background going in

- HitM 2026-04-30: "exceptionally far from distribution readiness."
- Of testers HitM directly invited, only one has responded about signing up.
- Critical distribution-blocker is on the known-issues list (Topic 1).
- Nothing in `01_unit_economics_and_costs.md` §2 is built yet (no Stripe/Xendit/PayMongo, no founding-member program, no PHP-anchored pricing UI).
- No PH-local distribution touchpoint started.

### Open questions

- What is the gap between current state and "I can hand someone a link and they can become a paying user"?
- Which gaps are infra (billing, ToS, refund policy) vs channel (PH communities, content) vs product (the critical issue)?
- What's the right sequence — fix critical product issue first, then infra, then channels?
- Founding-member lifetime program: still on the table, or defer until tight beta closes?
- What's the smallest viable distribution test (e.g. one community post + one signup form) to validate the wedge before scaling?

### Discussion notes

*(append as we go — depends on Topic 1 critical issue and Topic 5 launch definition)*

### Decision

*(none yet)*

---

## Topic 7: Wedge audit + landing polish queue

**Status:** `decided` (2026-04-30)
**Owner:** HitM (confirms current state); agent (queues changes)

### Background going in

- HitM 2026-04-30: "[wedge] exists in product preview, but not [hero]. Splash page is eye catching, but will need future polish and refinement."
- Per `00_strategic_context.md` §1, the wedge sentence belongs on landing hero, dashboard primary KPI, and every social post screenshot.
- Web app shipped with "marketing-style hero, value props, feature showcase, roadmap, CTA" per CHANGELOG P2.

### Open questions

- Is the current splash polish-blocked or copy-blocked? (Different fix.)
- Does the dashboard primary KPI surface "safe-to-spend" prominently, per `00_strategic_context.md` §1 requirement?
- Is wedge work part of distribution-readiness (Topic 6) or separate polish queue?
- Quick win: one-line copy edit to hero + one screenshot for social → ready in <1 hour.
- Larger polish: visual redesign of splash → multi-day work, queue for later.

### Discussion notes

*(append as we go)*

### Decision

*(none yet)*

---

## Topic 8: Velocity + Cursor cost management

**Status:** `decided` (2026-04-30)
**Owner:** HitM (sets pace); agent (operationalizes)

### Background going in

- HitM 2026-04-30: decompressing after sprint; some momentum remaining; planning to slow production for a few weeks to align with Cursor usage cycle and avoid overage.
- HitM also wants minimum bug-fix capacity available during slow window.
- `01_unit_economics_and_costs.md` §3 has an AI cost cap model but it's never been measured in production.

### Open questions

- What's the actual Cursor monthly limit, and where are we against it for this billing cycle?
- What's the "minimum viable maintenance" definition during decompression weeks? (Examples: critical bug fixes only, no new features, drift cleanup OK?)
- What's the trigger to resume next sprint? (Calendar date, billing cycle reset, infra gap closed, energy returned?)
- Set up monthly LLM cost audit per `01_unit_economics_and_costs.md` §6 — first run when?
- Should the strategic roadmap acknowledge a "decompression / maintenance" mode as a first-class phase variant?

### Discussion notes

*(append as we go)*

### Decision

*(none yet)*

---

## Topic 9: Drift cleanup queue

**Status:** `decided` (2026-04-30)
**Owner:** agent (drafts ordered list); HitM (approves)

### Background going in

Items flagged in the previous huddle message that need cleanup:


| Item                                                                   | Severity | Effort                                             |
| ---------------------------------------------------------------------- | -------- | -------------------------------------------------- |
| `+Bill disable` hotfix not in git                                      | S1       | Small (commit + deploy cycle)                      |
| Strategic doc drift (registry, validation_gates, gate-outcomes log)    | S1       | Small (one doc-sync session)                       |
| Pre-governance plans still listed `in_progress` despite some at `PASS` | S2       | Medium (close-out each per `plan_lifecycle.md` §E) |
| Reflex archival actions (post Topic 2 decision)                        | S2       | Medium                                             |
| AI cost discipline never measured                                      | S2       | Small (set up audit; first run)                    |


### Open questions

- Order: which of these gets done first during decompression weeks?
- Which can be batched into a single PR vs. need separate PRs for traceability?
- Does any of this require runtime ownership coordination (i.e. blocked by another agent)?
- What's the cap on "drift cleanup work" during decompression — hours per week?

### Discussion notes

*(append as we go)*

### Decision

*(none yet)*

---

## Topic 10: Family / personal cadence

**Status:** `decided` (2026-04-30)
**Owner:** HitM

### Background going in

- Baby is ~5 weeks old (math from prior conversation).
- HitM 2026-04-30: "current feeling is decompression after a heavy design and work sprint."
- `kill_commit_gates.md` §6 requires quarterly self-review with three written questions; first execution due ~end of Q2 2026 (June).
- Velocity assumption baked into roadmap was "30–50% loss from 2026-06 through 2026-12." Need to validate.

### Open questions

- How is actual velocity comparing to baseline? Better/worse/same as the 30–50% assumption?
- Calendar reminder for first quarterly self-review: when?
- Boundaries during decompression: what's the maximum work-hours-per-week ceiling?
- Anything about partner/family that needs codifying as a constraint on the roadmap?

### Discussion notes

*(append as we go)*

- Local tool creations - Patrick

### Decision

*(none yet)*

---

## Topic 11: Lock, consolidate, and seed next sprint

**Status:** `executing` (2026-04-30) — close-out in progress
**Owner:** agent (drafts); HitM (approves)

### Background going in

- This is the closing topic — converts huddle output into governance + strategic + plan artifacts.
- All prior topics must be `decided` or `deferred` before this opens.
- HitM 2026-04-30 expanded the scope: the post-huddle deliverables now include feature roadmaps, implementation guides, and blue-green branching guidelines on top of the original cleanup work.

### Open questions

**Original scope:**

- Update strategic roadmap files: which entries change?
- Create a single follow-up plan packet under `plans/cursor/<branch>/` for the drift cleanup queue.
- Update `governance/plan_registry.md` with all status transitions.
- Append first entry to `kill_commit_gates.md` outcomes log: implicit S1 boundary shift, JS pivot completion, Reflex archival, S0 issue declaration.
- Trigger `design-docs-sync` for affected design docs.
- Define resume trigger condition explicitly in `01_unit_economics_and_costs.md` or a new file.
- Archive this huddle directory to `plans/archived/`.

**Expanded scope (HitM 2026-04-30 — "after we get phases figured out"):**

- **Feature roadmaps** — per-phase feature lists with implementation order. Likely one per major surface (dashboard, transactions, calendar, upcoming bills, data hub, settings, onboarding).
- **Implementation guides** — agent-facing how-tos for repeatable feature work (e.g. "how to add a new dashboard widget end-to-end," "how to add a new API contract with CLI smoke + JS consumer," etc.).
- **Blue-green branching guidelines** — codify the actual VPS workflow that has emerged: per-phase branch strategy, web-blue/web-green build cadence, when to fold into shared infra. Extends `governance/deployment_protocol.md`.
- **Plan/branch templates for next beta sprint** — concrete pre-flight artifacts so the next sprint starts with all governance scaffolding ready.

### Discussion notes

- 2026-04-30: HitM expanded scope; Topic 11 now produces governance + strategic + feature-roadmap + implementation-guide + branching-guideline artifacts as a coherent set. This is the foundation for the next beta sprint.
- We need to consolidate and remedy current orchestration flows - Patrick

### Decision

*(none yet)*