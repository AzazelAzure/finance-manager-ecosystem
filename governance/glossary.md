# Glossary — Canonical Vocabulary

**Locked:** 2026-04-30 in post-beta huddle (originally drafted in `plans/archived/post_beta_huddle_2026-04-30/GLOSSARY.md`, migrated here as persistent governance artifact).

This file is the **single source of truth** for vocabulary across all plans, design docs, and agent operations. Conflicts in other files get resolved against this glossary.

---

## 1) Phase / Stage / Sprint hierarchy

Strict three-level addressing. Every piece of work has a clear address.

| Level | Canonical term | Scope | Notation | Example |
|---|---|---|---|---|
| 1 | **Phase** | Multi-quarter strategic horizon. Has entry/exit triggers. | `S<n>` | `S1` |
| 2 | **Stage** | Sub-phase milestone within a Phase. | `S<n>.<letter>` | `S1.A` |
| 3 | **Sprint** | Time-bounded execution cycle within a Stage. | `S<n>.<letter> Sprint <m>` | `S1.B Sprint 2` |

### Retired vocabulary (do not use going forward)

| Retired | Replacement | Notes |
|---|---|---|
| `Phase 1`, `Phase 2` | `S1`, `S2` | Original Roadmap_Overview phase numbers refer to historical alpha-stabilization / beta-prep work; archived. |
| `Cycle` | `Sprint` | Beta Execution Board "Cycle 1, Cycle 2…" → renamed `Sprint 1, Sprint 2…`. |
| `Track` | `Workstream within Phase` | Original Tracks A–E become workstreams inside the relevant Phase. |

---

## 2) Launch-state vocabulary (per product stream)

### Generalized launch-state progression

Every product stream (web, API, CLI, Android, iOS, Rust middleware, future Sari-Sari, etc.) progresses through this state machine independently:

```
Concept → Scaffold → Alpha → Tight Beta → Founding Beta → Soft Public Open → Public Launch → Full Public → [Sunset → Archived]
```

| State | Definition |
|---|---|
| **Concept** | Designed (or roadmapped) but no implementation. |
| **Scaffold** | Basic project structure exists (repo init, README, build config). No functional product. |
| **Alpha** | Internal-use only. Owner-tested. May be unstable. No external users. |
| **Tight Beta** | Owner-curated invitation list. No public signup. Direct outreach only. |
| **Founding Beta** | Founding-member program open. Limited paid seats (e.g. 50–100). Not promoted publicly. |
| **Soft Public Open** | Anyone can sign up. Pricing visible. Low-key promotion only. |
| **Public Launch** | Active distribution effort. Content cadence, community presence, possibly press/podcast outreach. |
| **Full Public** | Steady-state production with paid acquisition optionality. |
| **Sunset** | Winding down. No new users. Existing users notified. Migration path provided. |
| **Archived** | Discontinued. Repo retained as historical artifact only. (Example: `finance_manager_reflex` as of 2026-04-30.) |

### Notation

Use `<product>:<state>` to address a specific product stream's state.

Examples:

```
web:Tight Beta
api:Tight Beta
cli:Alpha
android:Scaffold
middleware:Scaffold
desktop:Concept
reflex:Archived
```

### Flagship product convention

The HitM designates a **flagship product** for any given strategic Phase. The flagship's launch-state determines Phase progression. Other products track independently.

Current flagship: **`web`** (S1).

### Phase ↔ flagship state alignment (informational)

| Phase | Typical flagship state |
|---|---|
| S1 | flagship: Tight Beta → Founding Beta → Soft Public Open |
| S2 | flagship: Soft Public Open → Public Launch → Full Public |
| S3 | flagship: Full Public; non-flagship Android: Scaffold → Alpha → Tight Beta |
| S4 | flagship: Full Public; reputation/dev-channel work; ZK middleware: Concept → Scaffold |
| S5 | flagship: Full Public; ZK middleware: Alpha → Tight Beta → Public Launch |
| S6 | flagship: Full Public; Sari-Sari: Concept → Scaffold → Tight Beta |

### Retired vocabulary

| Retired | Replacement |
|---|---|
| `Public Beta` (as a phase name) | Use the explicit launch-state instead (e.g. `Founding Beta`, `Soft Public Open`). |
| Bare `Beta` | Always qualify: `Tight Beta`, `Founding Beta`. |
| `Test` / `Staging` as launch-state synonyms | These are *environment names only* (e.g. `jsdevtesting` hostname); not launch states. |

---

## 3) Plan vocabulary

Five plan-type categories, each with distinct scope and lifecycle:

| Type | Scope | Lifecycle | Location |
|---|---|---|---|
| **Strategic Plan** | Multi-year. Phases S1–S6, locked decisions, success criteria, kill gates. ONE per project. | Permanent; updated at Phase transitions. | `strategy/strategic-roadmap-reframe-53be/` |
| **Execution Plan** | One Sprint or one cohesive batch of work. Has YAML metadata, tasks, validation gates. | Lives `draft → ready → in_progress → completed → archived`. | `plans/<Phase>/<Stage>/<sub-plan>/` (hierarchical, per Topic 11 lock + 2026-05-04 path lift from `plans/agy/s1b/`), optional transient `plans/agy/<branch>/` (legacy standalone only — **not** the Strategic Plan), or closed trees under `plans/archived/` (including `archived/cursor-layout-era/`, `archived/feat/`, `archived/fix/`, `archived/volatile*`) |
| **Feature Roadmap** | Per-surface backlog (e.g. "Dashboard feature roadmap"). Lists features, priorities, target Phase. NOT execution-ready. | Permanent; updated as features ship or get queued. | `design_docs/<surface>_docs/feature_roadmap.md` |
| **Implementation Guide** | Agent-facing how-to for repeatable work patterns. | Permanent; revised when patterns change. | `design_docs/40_System_Design/implementation_guides/` |
| **Branching Guideline** | Specific to deploy/branch strategy. Extends `deployment_protocol.md`. | Permanent; revised when deploy strategy changes. | `branching_guidelines.md` |

### Task and slice IDs (execution plans)

| Term | Meaning |
| --- | --- |
| **Task `T##`** | Numbered work unit in an execution plan; often one `tasks/T##_<slug>.md` and one **task branch** `…/t##-<slug>` when shipping code. |
| **Slice `T##.SL#`** | Sub-step inside a task: the **default unit for agent delegation**. **`SL`** = slice (not bare `S##`, which is reserved for **Phase/Stage** like `S1`, `S1.B`). Typical slice = one web route/page or one API model/viewset seam. Full rules: `plan_template.md` §1a. |

### Retired vocabulary

| Retired | Replacement |
|---|---|
| Bare `Plan` | Always qualify: "Strategic Plan," "Execution Plan." |
| Bare `Roadmap` | Strategic Plan is the only multi-year roadmap. Per-surface backlogs are "Feature Roadmaps." |
| `Plan packet` | "Execution Plan." |

---

## 4) Severity vs Priority

Two distinct scales that look identical. Always include the prefix letter.

| Scale | Range | Domain | Source |
|---|---|---|---|
| **Severity** | `S0` / `S1` / `S2` / `S3` | How bad an issue is | `design_docs/40_System_Design/15_Beta_Week_Incident_Triage_and_Human_Gated_Autofix_Contract.md` |
| **Priority** | `P0` / `P1` / `P2` | How urgent a piece of work is | `plan_template.md` |

A bug can be `S0` (data integrity broken) **and** `P0` (must be fixed first). They aren't the same: severity describes the issue, priority describes our scheduling decision.

### Convention

Always write `S0`, `S1`, `P0`, etc. — never bare `0`, `1`, `2`. The prefix letter is mandatory.

---

## 5) User vocabulary

| Term | Refers to |
|---|---|
| **HitM** | Human in the Middle. The owner-operator. Currently `pproctor`. Singular. |
| **End user** | A person using the PFM product. Has a `User` record in the DB. |
| **Tester** | An end user who is part of the current Tight Beta. |
| **Invitee** | A person HitM has invited but who hasn't necessarily signed up yet. |
| **Founding member** | An end user who has paid for a Founding Beta lifetime seat. |
| **Honorary Founder** | An end user grandfathered with founder benefits without payment (e.g. US testers from pre-PH-pivot era). |
| **Active user** | An end user who has logged in within the last 30 days. |
| **Paying user** | An end user with an active paid subscription. |
| **Persona** | An archetypal target user for product decisions. NOT a specific person. Current canonical: "thin-margin PH household." |

### Qualified vocabulary

| Term | Rule |
|---|---|
| `User` | Acceptable in code/API contexts (DB model). Always qualify in prose conversation. |
| `Owner` | Always qualify: "product owner," "plan owner," "runtime owner." |

---

## 6) Sprint vocabulary

| Term | Definition |
|---|---|
| **Sprint** | A time-bounded execution cycle within a Stage. Has start, end, deliverables. Minimum durations per `branching_guidelines.md`. |
| **Production Sprint** | A Sprint that ships code to production VPS. Goes through CPPR+D. Min 1 week calendar slot. |
| **Maintenance Sprint** | A Sprint focused on bug-fix-only or doc-only work, no new features. Min 3 days. |
| **Research Sprint** | A Sprint with no code changes — research, decision documents, design exploration. Min 1 week. |
| **Decompression** | An explicit rest period between Sprints. No active sprint open. Maintenance work allowed; no new feature work. Min 3–5 days after each Production Sprint. |
| **Sprint Brief** | Pre-Sprint document defining Sprint scope, exit criteria, and the Execution Plans it contains. |

---

## 7) Cycle / process vocabulary

| Term | Definition |
|---|---|
| **CPPR** | Commit, Push, Pull-Request. Local→remote→PR cycle. No deployment. |
| **CPPR+D** | CPPR plus Deploy. Adds blue-green deploy step after PR merge. See `deployment_protocol.md`. |
| **CPPRD** | Commit, Push, Pull-Request, Document. Adds documentation update step. See `AGENTS.md`. |

These three are not synonyms. CPPR is the minimum cycle; CPPR+D is for code that ships to VPS; CPPRD is for code that ships and where docs need to be updated.

---

## 8) Current state snapshot (2026-04-30)

| Stream | Launch state | Notes |
|---|---|---|
| `web` (flagship) | `Tight Beta` | Live on VPS as of 2026-04-29 |
| `api` | `Tight Beta` | Tracks flagship |
| `cli` | `Alpha` | Operational, internal use |
| `android` | `Scaffold` | Repo initialized; pull-forward begins S1.B |
| `middleware` (Rust) | `Scaffold` | Repo stub only; full work S5 |
| `desktop` | `Concept` | Future stream; no scheduled work |
| `reflex` | `Archived` | Decommissioned 2026-04-30 |

Strategic Phase: `S1`, Stage `S1.A → S1.B` transition (post-huddle).

Active markets:

- **PH** (primary, locked): all marketing, distribution, content, product decisions optimize PH first.
- **US** (passive): existing testers grandfathered as Honorary Founders. New US acquisition deferred behind P-6 trigger condition.

---

## 9) Verification tiers (V-tier)

*Added 2026-05-04 — Emergency Orchestration Huddle (D1).*

Every task slice checklist item declares a verification tier. Agents cannot mark PASS without meeting the tier.

| Tier | Name | What counts as PASS | Typical use |
|------|------|---------------------|-------------|
| `V0` | **Code audit** | Agent reads source, confirms logic. | Docs, governance, plan authoring |
| `V1` | **Local build** | Build/test passes locally; evidence: log. | API logic, type-safety, unit tests |
| `V2` | **Staging deploy** | Deployed to inactive color; smoke passes; evidence: smoke log. | User-visible behavior changes |
| `V3` | **Browser verify** | Browser verification with screenshot/recording evidence. | Interactive UI, tours, offline, forms |

See `plan_template.md` §1a "Verification tiers" for full enforcement rules.

---

## 10) Agent roles (pipeline)

*Added 2026-05-04 — Emergency Orchestration Huddle (D5).*

| Role | Definition | Model tier |
|------|-----------|-----------|
| **Orchestrator** | Plans work, decomposes tasks/slices, assigns V-tiers. Does not write production code. | Strong (Gemini Pro / Opus) |
| **Executor** | Writes code, runs V0/V1 checks, commits to slice/feature branch. Cannot self-certify V2+. | Efficient (Antigravity Grunt / Flash) |
| **Reviewer** | Reviews code, runs V2 deploy verification, approves or rejects slices. Does not write new feature code. | Strong (Gemini Pro / Opus) |
| **HitM Gate** | Human. V3 browser verify, production flip authority, merge authority. | Human |

---

## 11) Huddles

*Added 2026-05-04 — Emergency Orchestration Huddle (D4).*

| Term | Definition |
|------|-----------|
| **Huddle** | A first-class strategic discussion artifact for course correction. Lives in `strategy/huddles/<date>-<topic>/`. |
| **Scheduled huddle** | Triggered at every Stage transition. |
| **Emergency huddle** | Triggered by HitM when systemic issues surface. |
| **Sprint retro** | Brief huddle at end of each Production Sprint. |

Huddle template: `README.md`, `TALKING_POINTS.md`, `DECISIONS.md`, `ACTIONS.md`.

---

## 12) Definition of done (feature rollout bar)

Normative checklist for **when a governed feature plan may claim complete** relative to PWA, i18n, SEO, and beta surfaces. Full text and links: **[`definition_of_done.md`](./definition_of_done.md)**.

| Pillar | One-line bar |
|--------|----------------|
| **PWA** | Advanced PWA sprint is **not** “complete” while known PWA bugs / QoL gaps remain open per PWA plan + registry; feature work must not regress install/offline contracts. |
| **Localization** | User-visible strings **must** pass localization (i18n) tests before rollout close; documented **shelved** exceptions require HitM signoff + follow-up plan row. |
| **PWA scope class** | Each feature declares **A** (PWA-safe + shipped compatibly) or **B** (PWA-safe, **online-only** — documented in plan scope + user-facing copy). |
| **SEO** | Rollout close includes SEO gate per **[`plans/S1/S1.B/distribution-channel-research/SEO_PRIORITY_MATRIX.md`](../plans/S1/S1.B/distribution-channel-research/SEO_PRIORITY_MATRIX.md)**; new public surfaces should include **P0** matrix items **during** the sprint when they touch those files. |
| **Beta comms (F-011)** | Wedge / pipeline transparency for testers rolls up under **F-011** (landing + subpages). |

Sprint **ordering** across F-* plans is set by HitM-led huddle output: **[`strategy/huddles/2026-05-22-feature-rollout-sprint-order/README.md`](../strategy/huddles/2026-05-22-feature-rollout-sprint-order/README.md)**.

---

## 13) Update protocol

This glossary is locked at the level of the categories above. Adding or modifying terms requires:

1. Discussion in a huddle session (or focused decision conversation).
2. HitM signoff captured in a `DECISIONS.md` (huddle) or appended to relevant strategic file.
3. Update of this glossary file.
4. Cascading update of any other docs that reference the changed term.

Retired terms stay retired. Re-introducing a retired term requires the same protocol as introducing a new one.
