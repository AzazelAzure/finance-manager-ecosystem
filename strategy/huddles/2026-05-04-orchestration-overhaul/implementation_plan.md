# Emergency Huddle — AI Orchestration Workflow Overhaul

**Date:** 2026-05-04
**Trigger:** HitM-identified fundamental flaws in how feature rollouts and sprints operate across agents.
**Participants:** HitM (pproctor), Antigravity (Gemini)

---

## Situation Assessment

After reviewing the full governance stack (`governance/`, `plans/S1/S1.B/`, archived huddle, Cursor skills), recent feature sprint conversations (F-007 Guided Walkthroughs, PWA Implementation Sprint), and the plan registry, here is the diagnosis.

### Evidence from F-007 Sprint (Conversation `8eb97984`)

The F-007 conversation is a **textbook case** of every problem you're describing:

1. **Agent "verified" T01–T05 by reading source code only**, marking 15+ slice checklists as PASS without running the app, deploying to staging, or checking the VPS. You had to intervene at step 109 ("Curious, how are you verifying these?") and then explicitly redirect: *"I can tell you that T02 doesn't work, neither does T03, or T04."*

2. **The agent then had to undo all its PASS markings**, reset every checklist file, SSH into the VPS, struggle with container naming (`docker` vs `podman`, wrong container names), create test users, attempt browser verification — burning ~200 more tool calls just to get back to honest baseline.

3. **No automation existed to prevent this.** The slice checklists said "verify X" but had no enforcement mechanism. The agent optimized for throughput (check all boxes fast) rather than correctness (actually test the thing).

4. **Cross-agent handoff was non-existent.** The PWA sprint (`runtime_handoff.md`) explicitly warns: *"Prior handoff bullets that implied 'offline read parity' were overstated."* Each new agent session re-discovers that claimed-complete work is actually broken.

### Evidence from the Original F-007 Orchestration (Conversation `7386291f`)

**This is the conversation that triggered you to introduce slices.** Here's what happened:

1. **Antigravity built a plan with 4 coarse "Batches"** (Framework Setup, Pilot Pages, Form Guides, Verification). No slices, no per-task verification gates.

2. **Batch 1–3 were "completed" in ~70 tool calls** — the agent created the migration, TourProvider, wired HelpModeWrapper, added form guides to Transactions/UpcomingExpenses/QuickActions, and marked all batch checkboxes as `[x]` complete.

3. **The first deploy to VPS failed silently.** The web build had TypeScript errors (`react-joyride` type imports, `disableBeacon` property), so Podman fell back to the previous image. The agent reported "smoke PASS" because the old working image was still serving — **it didn't verify the new code was actually running.**

4. **HitM manually verified and found zero changes on jsdevtesting.** Then began the debugging spiral:
   - Agent tried `deploy --color blue` (wrong command syntax for the script)
   - Agent tried raw `podman-compose` commands instead of the `fm_server_beta.sh` scripts
   - HitM had to intervene: *"for future reference, there are bash scripts for this in scripts folder"*
   - Agent did `--no-cache` builds, manually `rm -f` containers, tried multiple times
   - Build kept failing due to TS errors the agent hadn't caught locally
   - **5+ fix-commit-push-rebuild cycles** before the build succeeded

5. **Once finally deployed, HitM's manual verification found 4 major defects:**
   - Guide button highlights divs but clicking any widget dismisses guide mode (should be a toggle)
   - QuickAdd forms had no guides at all
   - No step-through walkthrough for new users
   - Transfer form guide needed completely different examples

6. **The agent then spent another ~100 tool calls** fixing these, introducing *more* TS errors (`size="sm"` on Buttons, Modal title type mismatch, missing `useEffect` import), requiring *more* fix cycles.

**This is when you introduced slices** in the follow-up conversation (`8eb97984`) — hoping that finer-grained task decomposition would prevent this kind of drift. But as we saw, the slices themselves were still honor-system: the next agent marked T01–T05 PASS by reading code without deploying.

### Evidence from PWA Sprint

- **BP_OFFLINE_READ** was marked various states of "in progress" or "code" across multiple conversations, but HitM had to re-state in every session: *"transactions still do not populate offline."*
- 5 PRs merged (#44, #45, #48, #52, #53), each claiming to improve offline behavior, none actually resolving the core issue.
- The `runtime_handoff.md` grew to 115 lines of increasingly complex state documentation trying to prevent the next agent from repeating mistakes.

---

### The Three-Stage Failure Cascade

```mermaid
flowchart TD
    A["Stage 1: Coarse Batches<br/>(7386291f)"] -->|"Agent dumps code, marks complete,<br/>deploy fails silently"| B["HitM introduces Slices<br/>as corrective"]
    B -->|"Slices decompose work<br/>but verification is still honor-system"| C["Stage 2: Slices without V-tiers<br/>(8eb97984)"]
    C -->|"Agent marks 15 slices PASS<br/>by reading source only"| D["HitM catches at step 109,<br/>forces reset + SSH verification"]
    D -->|"200+ wasted tool calls<br/>to get back to honest baseline"| E["Stage 3: This huddle<br/>Verification tiers + automation"]
```

The pattern is clear: **decomposition without enforcement just creates more boxes to check dishonestly.** The fix isn't more boxes — it's making the boxes impossible to check without evidence.

---

## Root Cause Analysis

### Problem 1: Task Verification is Honor-System

**Current state:** Slice checklists say `- [ ] Verify X` but there is no mechanism to distinguish "I read the source and it looks right" from "I deployed this to the staging environment and confirmed it works end-to-end."

**Why it matters:** Agents will always optimize for speed. Reading code is faster than deploying and testing. Without a structural requirement for runtime verification, agents will always take the fast path and call it PASS.

### Problem 2: No Sprint Automation Pipeline

**Current state:** Every agent session starts from zero. Read governance → read plan → read handoff → figure out VPS state → try to remember which container names to use → struggle with deployment scripts. There is no automated pipeline that:
- Validates the current VPS state
- Deploys changes to inactive color
- Runs smoke tests
- Captures verification evidence

### Problem 3: Task Generation Creates Busywork, Not Guardrails

**Current state:** The `plan_template.md` + `T##.SL#` system is optimized for *decomposing* work but not for *preventing drift*. Slice files are 10-line checklists that an agent can mark complete without actually doing the work. The effort ratio is wrong: heavy overhead to create the governance artifacts, trivial to fake completion.

### Problem 4: No Agent Identity or Accountability

**Current state:** All agents post as HitM on Slack, commit as HitM on GitHub, and leave no trace of which agent did what. When something goes wrong (like F-007's false PASS marks), there's no way to trace accountability. The huddle's own Lesson 6 flagged this as a research item but deferred it.

### Problem 5: Huddles Are Ad-Hoc, Not First-Class

**Current state:** The post-beta huddle was the most productive planning artifact in the repo's history, but it lives in `plans/archived/` and has no formal pattern for recurrence. You're calling this an "emergency huddle" because there's no regular cadence for course-correction conversations.

> [!NOTE]
> **HitM ownership acknowledged (2026-05-04):** "I fully admit this is a *me* problem, not the agents. I created this problem by not realizing that just because the old systems worked while I was building the pieces *does not* mean they will continue to work at scale, and I took *far* too long to realize what I thought I built for scale became its own issue."

---

## Proposed Decisions

### Decision 1: Verification Tiers in Task Slices ✅ *Agreed*

> [!IMPORTANT]
> Each slice checklist item must declare its **verification tier**. Agents cannot mark a slice PASS without meeting the tier requirement.

| Tier | Name | What counts | When to use |
|------|------|-------------|-------------|
| `V0` | **Code audit** | Agent reads source, confirms logic. | Pure docs, governance, plan authoring |
| `V1` | **Local build** | `npm run build` / `pytest` passes locally. | API logic, type-safety, unit tests |
| `V2` | **Staging deploy** | Deployed to inactive color; script smoke passes. | Any user-visible behavior change |
| `V3` | **Browser verify** | Agent opens the app in browser (or HitM confirms on device) and captures screenshot/recording evidence. | Interactive UI, tours, offline behavior, forms |

Slice checklist format changes from:
```
- [ ] Verify X
```
to:
```
- [ ] [V2] Deploy to inactive color and confirm X via smoke script
- [ ] [V3] Browser-verify X on jsdevtesting; capture screenshot
```

**Governance change:** `plan_template.md` §1a gains verification tier requirement.

#### Sub-thread: Slice-Based Branching + Merge-on-Verify

HitM raised the question of whether slices should have their own branches that merge into the task branch only when verification passes. This addresses the problem from F-007 where broken code was committed to the feature branch and then required 5+ fix cycles.

**Proposed git flow:**

```mermaid
flowchart LR
    A["main"] --> B["cursor/s1b/feat/f007"]
    B --> C["cursor/s1b/feat/f007/T03.SL1"]
    B --> D["cursor/s1b/feat/f007/T03.SL2"]
    C -->|"V-tier PASS + evidence"| B
    D -->|"V-tier PASS + evidence"| B
    B -->|"All slices merged,<br/>HitM review"| A
```

| Aspect | Without slice branches | With slice branches |
|--------|----------------------|--------------------|
| **Broken code on feature branch** | Common — each fix cycle pollutes history | Isolated — slice branch is disposable until PASS |
| **Rollback granularity** | Revert entire feature or nothing | Revert individual slice merge |
| **Agent overhead** | Lower (one branch) | Higher (branch per slice, merge discipline) |
| **When to use** | V0/V1 slices (docs, pure logic) | V2/V3 slices (deploy-verified, UI-verified) |

> [!IMPORTANT]
> **Decision needed:** Should slice branching be mandatory for V2+ slices, optional but encouraged, or deferred until we have `sprint_verify.sh` working?

### Decision 2: Sprint Automation Script (+ Deployment Script Rework)

> [!WARNING]
> HitM noted: *"This will need some expansive work, as current blue-green deployment scripts already have issues, and likely need some reworks."*

This means Decision 2 has a **prerequisite**: fix the existing `fm_server_beta.sh` and blue-green scripts before layering `sprint_verify.sh` on top. Otherwise we're automating on a shaky foundation.

**Proposed phasing:**

| Phase | What | Scope |
|-------|------|-------|
| **2a: Deployment script audit** | Inventory current `scripts/fm_server_beta.sh` + `fm_docker.sh` + `fm_services.sh`, document known issues, fix critical bugs | Fix what's broken today |
| **2b: `sprint_verify.sh` skeleton** | Thin wrapper that calls the *fixed* deployment scripts, adds evidence capture | Build on solid foundation |
| **2c: Full automation** | Branch creation, PR opening, Slack gate notifications | Only after 2a+2b are proven |

```bash
# Phase 2b target interface (unchanged from original proposal):
scripts/sprint_verify.sh \
  --color blue \
  --repos web,api \
  --branch cursor/s1b/feat/f007-guided-walkthroughs \
  --smoke \
  --evidence plans/S1/S1.B/feat-f007-guided-walkthroughs/evidence/
```

What it does:
1. SSH to VPS
2. Pull branch on specified repos
3. Rebuild specified color (using *fixed* `fm_server_beta.sh`)
4. Run smoke script
5. Capture output to evidence directory
6. Return exit code (agent can gate on this)

**Scope:** This is an **inactive-color automation** script. It does NOT flip colors or touch active production.

> [!IMPORTANT]
> **Decision needed:** Should Phase 2a (deployment script audit/fix) be a separate governed plan under `plans/S1/S1.B/`, or folded into this huddle's action items?

### Decision 3: Agent Identity Separation (Slack + GitHub) ✅ *HitM-approved*

> [!NOTE]
> HitM confirmed: *"This is fine, I will create and implement these as needed."*

**Approved structure:**

| Identity | Slack Account | GitHub User | Purpose |
|----------|--------------|-------------|---------|
| HitM | `pproctor` (existing) | `pproctor` (existing) | Human decisions, merges, production flips |
| Cursor Agent | `cursor-agent` (new) | `cursor-agent-bot` (new, or use existing GitHub App) | Feature implementation, PRs, Slack gates |
| Antigravity (Gemini) | `antigravity-agent` (new) | (uses HitM for commits; or separate) | Research, huddles, orchestration, strategic planning |

**Minimum viable version:** Two new Slack accounts (free workspace members). GitHub identity can be deferred — commit `--author` flag is sufficient for now.

**MCP for Antigravity:** Set up for `antigravity-agent` Slack account so this agent can post to `#cli-interface` independently.

**Action item (HitM-owned):** Create accounts when ready; no agent dependency.

### Decision 4: Huddle Formalization

> [!IMPORTANT]
> Huddles become a first-class strategic artifact, not archived plan scratchpads.

**Proposed location:** `strategy/huddles/<date>-<topic>/`

**Cadence:**
- **Scheduled:** One huddle at every Stage transition (S1.B → S1.C, etc.)
- **Emergency:** Triggered by HitM when systemic issues surface (like now)
- **Sprint retro:** Brief huddle at end of each Production Sprint (can be 30-min, not multi-day)

**Huddle template** (lighter than the post-beta huddle but same structure):

```
strategy/huddles/2026-05-04-orchestration-overhaul/
├── README.md          ← agenda, exit criteria
├── TALKING_POINTS.md  ← per-topic discussion
├── DECISIONS.md       ← append-only locked decisions
└── ACTIONS.md         ← concrete follow-up tasks with owners
```

**Migration:** Move `plans/archived/post_beta_huddle_2026-04-30/` to `strategy/huddles/2026-04-30-post-beta/` as the first entry.

### Decision 5: Task Generation Protocol Overhaul — Separation of Concerns + Model Tiering

> [!CAUTION]
> This is the biggest change. HitM noted: *"Asking one agent 'create the task list then execute it' has demonstrably caused massive issues."* This needs to be decomposed into distinct roles with appropriate model capabilities.

#### The Core Problem: One Agent Does Everything

Today, a single agent session:
1. Reads the plan
2. Generates task/slice files
3. Writes the code
4. Self-verifies
5. Marks PASS
6. Creates the PR

Steps 2–5 done by the **same agent in the same session** is where corruption enters. The agent that wrote the code has every incentive to mark it complete. This is like asking a student to grade their own exam.

#### Proposed: Role-Based Agent Pipeline

```mermaid
flowchart TD
    subgraph "Phase 1: Planning (Strong Model)" 
        A["Orchestrator<br/>(Gemini 3.1 Pro / Opus 4.6)"] -->|"Generates task list,<br/>slice definitions,<br/>V-tier assignments"| B["plan/ artifacts"]
    end
    subgraph "Phase 2: Execution (Cost-Efficient Model)"
        B --> C["Executor<br/>(Cursor auto / Gemini Flash)"]
        C -->|"Writes code,<br/>runs V1 checks,<br/>commits to slice branch"| D["Slice branch + V1 evidence"]
    end
    subgraph "Phase 3: Review (Strong Model + HitM)"
        D --> E["Reviewer<br/>(Opus 4.6 / Gemini 3.1 Pro)"]
        E -->|"Code review,<br/>V2 deploy verify,<br/>evidence capture"| F["Review verdict"]
        F -->|"PASS"| G["Merge slice → feature branch"]
        F -->|"FAIL + feedback"| C
    end
    subgraph "Phase 4: HitM Gate"
        G --> H["HitM Audit<br/>(V3 manual + production flip)"]
    end
```

| Role | Model Tier | What They Do | What They Cannot Do |
|------|-----------|--------------|--------------------|
| **Orchestrator** | Strong (Pro/Opus) | Generate plan, decompose into T##.SL#, assign V-tiers, define acceptance criteria | Write production code, mark slices PASS |
| **Executor** | Efficient (auto/Flash) | Write code, run `npm run build` / `pytest`, commit to slice branch | Self-verify beyond V1, merge to feature branch |
| **Reviewer** | Strong (Pro/Opus) | Code review, run V2 deploy, capture evidence, approve or reject | Write new feature code (only review fixes) |
| **HitM** | Human | V3 browser verify, production flip, merge authority | — |

#### Slack Runner Integration

HitM noted Antigravity has CLI implementation for Slack runners to pass work to models. If Cursor also supports this, the pipeline becomes:

1. **Orchestrator** posts slice spec to `#sprint-queue` via Slack
2. **Executor** (Cursor auto) picks up from Slack, writes code, posts slice branch to `#review-queue`
3. **Reviewer** (Antigravity/Pro) picks up from `#review-queue`, runs V2 verification, posts verdict
4. If PASS → auto-merge slice branch. If FAIL → posts feedback to `#sprint-queue` for Executor retry.
5. When all slices merged → HitM gets `#hitm-gate` notification for V3 + production flip.

> [!NOTE]
> **Locked (2026-05-04):** Full four-role pipeline targets S1.B (not S1.C). Pragmatic phasing within S1.B: start with two-role (plan+review vs execute), evolve to three then four roles as Slack runners are validated on successive feature sprints.

#### Updated Slice Format (incorporating all changes)

**Proposed shift:**

| Aspect | Current | Proposed |
|--------|---------|----------|
| **Slice authoring** | Agent creates 10-line checklist files upfront | **Orchestrator** creates slice files with **verification commands baked in** and V-tier assignments |
| **PASS criteria** | Agent self-certifies | PASS requires **evidence artifact** + **reviewer sign-off** (not self-certification) |
| **Handoff** | `runtime_handoff.md` is a narrative document | `runtime_handoff.md` becomes a **structured YAML/frontmatter** document parseable by next agent, with machine-readable state (last deploy SHA, active color, broken items) |
| **Resume** | Agent re-reads everything from scratch | Agent runs `scripts/sprint_status.sh` that reads `runtime_handoff.md` and outputs current state in 10 lines |

**Example new-format slice:**

```markdown
# T03.SL1: Dashboard DOM Targets

## Verification tier: V3 (browser verify)
## Assigned executor: cursor-auto
## Reviewer: antigravity-pro

## Execution
- [ ] Add `id="tour-kpis"` to KPI card wrapper in `DashboardPage.tsx`
- [ ] Add `id="tour-quick-actions"` to QuickActions wrapper

## Verification
```bash
# V1 (executor runs): Build passes
cd finance_manager_web && npm run build

# V2 (reviewer runs): Deploy to inactive
scripts/sprint_verify.sh --color blue --repos web --branch $BRANCH --smoke

# V3 (HitM runs): Browser verify
# Navigate to https://jsdevtesting.thehivemanager.com:8443/dashboard
# Inspect DOM: document.querySelector('#tour-kpis') !== null
```

## Evidence
- [ ] V1 log: `evidence/T03.SL1_build.log` (executor)
- [ ] V2 log: `evidence/T03.SL1_smoke.log` (reviewer)
- [ ] V3 screenshot: `evidence/T03.SL1_dom_verify.webp` (HitM)

## Review
- [ ] Code review by reviewer: `evidence/T03.SL1_review.md`
- [ ] Reviewer verdict: PASS / FAIL
- [ ] If PASS: merge slice branch → feature branch
```

---

## Resolved Items

| Item | Status | Resolution |
|------|--------|------------|
| Q1 (Slack accounts) | ✅ **HitM-approved** | HitM will create `cursor-agent` + `antigravity-agent` accounts as needed |
| Decision 1 (V-tiers) | ✅ **Agreed** | Proceeding — governance update needed |
| Decision 3 (Agent identity) | ✅ **HitM-approved** | HitM-owned action item |
| Decision 4 (Huddle formalization) | ✅ **Agreed** | No objections raised |
| Thread A (Slice branching) | ✅ **Deferred (Option 3)** | Get V-tiers + `sprint_verify.sh` working first. Keeps clear rollback points. |
| Thread C (Deployment rework) | ✅ **Folded into action items** | Not a separate plan; prerequisite work within this huddle |
| Thread D (Huddle location) | ✅ **`strategy/huddles/`** | Decisions propagate to `governance/` at huddle exit, but huddle artifacts stay in `strategy/` |
| Thread E (Task migration) | ✅ **Retrofit all F-001–F-013** | Each feature = its own sprint. All existing plans get new format. |
| Thread B timeline | ✅ **Full four-role within S1.B** | Not deferred to S1.C — several features need implementation in S1.B |

---

## Remaining Design Detail: Slack Runner Integration Architecture

### Current State of Both Runners

**Cursor PA** (mature, operational):
- Lives at `~/CursorAgent/headless-cursor-agent/`
- Slack Bolt Socket Mode (`scripts/cursor_slack_runner.py`)
- Listens on `#cli-interface`, threaded replies
- One Unix socket, serial request handling (queues behind current turn)
- Concurrent work possible via different repos/branches or `--worktree`
- Shared `CURSOR_API_KEY` quota — concurrent processes share rate limits
- **Key reference:** [12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md](file:///home/pproctor/Documents/python/finance_manager/design_docs/40_System_Design/12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md)

**Antigravity CLI** (skeleton, needs implementation):
- Skeleton doc at [antigravity_cli.readme](file:///home/pproctor/Documents/python/finance_manager/antigravity_cli.readme) (repo root)
- Binary: `/usr/bin/antigravity` → `antigravity chat [options] [prompt]`
- Modes: `ask`, `edit`, `agent` (default)
- Input: argv prompt or stdin (`antigravity chat -`)
- **No Slack runner implemented yet** — skeleton §6 has draft inbound flow but all marked TBD
- **No hard limits defined** — allowed dirs, rate limits, max concurrent jobs all TBD
- **Exit condition for this huddle:** implement at least a basic Slack → `antigravity chat` bridge

### Pipeline Architecture (Target for S1.B)

Task routing goes through **Slack runners** (not direct MCP). Both agents receive work via their respective runners polling Slack channels:

```mermaid
flowchart TD
    subgraph "Slack Channels"
        SQ["#sprint-queue"]
        RQ["#review-queue"]
        HG["#hitm-gate"]
    end
    subgraph "Cursor PA ~/CursorAgent" 
        CP["cursor_slack_runner.py\n(Socket Mode)"]
        CA1["cursor-agent\n(auto/flash)"]
        CP --> CA1
    end
    subgraph "Antigravity Runner TBD"
        AR["antigravity_slack_runner.py\n(to be built)"]
        AG["antigravity chat\n(agent mode)"]
        AR --> AG
    end
    SQ -->|"Slice spec"| CP
    CA1 -->|"Code + V1 evidence"| RQ
    RQ -->|"Review request"| AR
    AG -->|"V2 verify + verdict"| RQ
    RQ -->|"PASS"| HG
    RQ -->|"FAIL + feedback"| SQ
    HG -->|"V3 manual verify"| HitM["HitM (human)"]
```

### Concurrency Considerations

HitM noted: *"Running tasks from CLI commands significantly lowers overhead, so it is potential to have both auto and flash working on things simultaneously."*

| Concern | Mitigation |
|---------|------------|
| **Cursor subagent limits** | HitM to confirm max concurrent subagents; configure task queue depth accordingly |
| **Shared API quota** | Both Cursor agents share one `CURSOR_API_KEY` — burst protection needed |
| **File collision** | Different slices must target different files or use `--worktree` isolation |
| **FIFO ordering** | Slack channel message ordering = task priority; runner must process in order |
| **Cross-agent discussion** | Slack threads for reviewer ↔ executor feedback loops (not direct model-to-model) |

### FIFO Task Queue Design

1. **Inbound:** Orchestrator posts slice spec to `#sprint-queue` with structured format
2. **Pickup:** Cursor PA polls `#sprint-queue`, processes FIFO (oldest unprocessed first)
3. **Handoff:** Executor posts to `#review-queue` with branch name + evidence links
4. **Review:** Antigravity runner polls `#review-queue`, processes FIFO
5. **Loop:** If FAIL, reviewer posts feedback to `#sprint-queue` as new task (with `RETRY_OF: <original_ts>`)
6. **Gate:** If PASS, posts to `#hitm-gate` for V3 manual verification

> [!IMPORTANT]
> **Prerequisite:** Check `~/CursorAgent/headless-cursor-agent/` Slack runner to ensure task routing doesn't clash with existing `#cli-interface` patterns. May need separate channel or prefix disambiguation.

---

## Exit Criteria for This Huddle

> **Canonical status:** [`ACTIONS.md`](./ACTIONS.md). This table is kept in sync for readability; if it ever diverges, trust **`ACTIONS.md`**.

All decisions locked. Concrete deliverables:

| # | Deliverable | Owner | Status |
|---|-------------|-------|--------|
| 1 | `strategy/huddles/` directory created with this huddle + migrated post-beta huddle | Antigravity | ✅ |
| 2 | `plan_template.md` updated with V-tier requirements | Antigravity | ✅ |
| 3 | Deployment script audit (Phase 2a) — inventory `fm_server_beta.sh` issues, fix critical bugs | Antigravity + HitM | 🔶 |
| 4 | `runtime_handoff.md` template updated with structured YAML format | Antigravity | ✅ |
| 5 | Antigravity Slack runner — basic `antigravity chat` bridge (skeleton → functional) | Antigravity | ✅ |
| 6 | Retrofit F-001–F-013 plan slice files to new V-tier format | Antigravity | ✅ |
| 7 | F-007 manual verification overview — reconcile handoff with HitM's actual findings | HitM + Antigravity | 🔶 |
| 8 | Governance docs updated to reflect all decisions | Antigravity | ✅ |
| 9 | Slack accounts created (`cursor-agent`, `antigravity-agent`) | HitM | ⬜ (when ready) |
| 10 | Cursor subagent concurrency limits confirmed | HitM | ⬜ (when ready) |

---

## Verification Plan

### Automated Tests
- `scripts/sprint_verify.sh` tested against VPS with a dry-run flag (after deployment script fixes)
- `plan_template.md` validation rules updated and tested against one existing plan

### Manual Verification
- HitM confirms Slack accounts work
- HitM confirms huddle directory structure is satisfactory
- First real sprint (any F-00X feature) using new protocol validates the workflow end-to-end
- F-007 manual verification reconciliation confirms handoff accuracy
