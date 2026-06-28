# Session 5: Automation & Tooling — Comprehensive Deep-Dive

**Huddle session:** 5 (Tooling & Agents)  
**Status:** `discussing`  
**Topics covered:** TP5 (Automation Hardening), TP14 (Claude Inclusion), TP17 (Antigravity Integration), TP7 (Workspace Commands), TP19 (Skills/Rules Split), TP22 (Governance Export)  
**Priority:** 🔴 **CRITICAL** — this session's outcome determines whether the post-baby operating model is viable.

---

## The Problem Statement

**Current state:** HitM spends 5–12 hrs/day on AI babysitting:

- Prompting agents with task context
- Reviewing output, finding errors
- Re-prompting with corrections
- Managing context loss when sessions end/restart
- Debugging agent infrastructure (PA crashes, Slack routing failures)
- Manually performing steps agents should handle autonomously

**Target state:** HitM spends <1 hr/day reviewing completed work:

- Agent picks up task from queue (automatic)
- Agent implements, runs tests (automatic)
- Smoke tests pass (automatic)
- HitM gets notification with results (automatic)
- HitM does visual check: "does this match my spec?" (manual, ~15 min)
- HitM approves or sends structured feedback (manual, ~5 min)

**Gap analysis:** The infrastructure is substantially **designed** but fails in **execution**. Below is the audit.

---

## TP5: Automation Hardening — Infrastructure Audit

### What exists today


| Layer                        | Component                                                                              | Location                                                                                                                                                                                 | Status                                 |
| ---------------------------- | -------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| **Pipeline design**          | 4-entity relay contract (HitM → executor → reviewer → HitM gate)                       | `[design_docs/40_System_Design/14_Inter_Agent_Message_Relay_and_Ownership_Contract.md](../../../../design_docs/40_System_Design/14_Inter_Agent_Message_Relay_and_Ownership_Contract.md)` | ✅ Designed, Phase 1 (manual)           |
| **Slack channels**           | `#sprint-queue` / `#review-queue` / `#hitm-gate` pipeline; `#cli-interface` for ad-hoc | Slack workspace                                                                                                                                                                          | ✅ Created                              |
| **Message format**           | `sprint-queue-v1` spec with SLICE/PLAN/REPO/BRANCH/SCOPE/ACCEPTANCE fields             | `[governance/sprint_queue_message_spec_v1.md](../../../../governance/sprint_queue_message_spec_v1.md)`                                                                                   | ✅ Specified                            |
| **Cursor PA runner**         | Socket Mode Slack runner for headless Cursor                                           | `~/CursorAgent/headless-cursor-agent/scripts/cursor_slack_runner.py`                                                                                                                     | ⚠️ Unstable — `agent-prompt` failures  |
| **Sprint pipeline bridge**   | Polls Slack + optional local JSONL inbox; routes READY→review→hitm-gate                | `[scripts/sprint_slack_pipeline_bridge.py](../../../../scripts/sprint_slack_pipeline_bridge.py)` (32KB)                                                                                  | ⚠️ Built but not reliably flowing      |
| **Ready emitter**            | Posts READY_FOR_REVIEW from completed slices                                           | `[scripts/sprint_pipeline_emit_ready.py](../../../../scripts/sprint_pipeline_emit_ready.py)`                                                                                             | ✅ Built                                |
| **Workspace isolation**      | 4 clones with separate git identities, isolation rules                                 | `[governance/agent_workspace_isolation.md](../../../../governance/agent_workspace_isolation.md)`                                                                                         | ✅ Set up                               |
| **Handoff templates**        | in_plan, cross_plan, failure formats                                                   | `[governance/execution_protocols.md](../../../../governance/execution_protocols.md)`                                                                                                     | ✅ Defined                              |
| **Runtime handoff notes**    | YAML frontmatter template for feature sprint state                                     | `[governance/runtime_handoff_template.md](../../../../governance/runtime_handoff_template.md)`                                                                                           | ✅ Template exists                      |
| **Sprint verify**            | Smoke test script                                                                      | `[scripts/sprint_verify.sh](../../../../scripts/sprint_verify.sh)`                                                                                                                       | ✅ Functional                           |
| **Skills/rules**             | `.cursor/skills/`, `.cursor/rules/` with delegation map                                | `.cursor/` directory                                                                                                                                                                     | ✅ Exist                                |
| **Governance skill mirrors** | `skill_roadmap_rollout_planning.md`, `skill_orchestration_manager.md`                  | `governance/`                                                                                                                                                                            | ✅ Exist                                |
| **Antigravity runner**       | Gemini-based Slack runner                                                              | `[scripts/antigravity_slack_runner.py](../../../../scripts/antigravity_slack_runner.py)`                                                                                                 | ❌ **Deprecated** for new orchestration |
| **Cursor headless agent**    | Web API poller (alternative to PA Socket Mode)                                         | `[scripts/cursor_headless_slack_agent.py](../../../../scripts/cursor_headless_slack_agent.py)` (28KB)                                                                                    | ⚠️ Alternative path; not primary       |


### What's failing (the 5–12 hr/day breakdown)

Mapping the daily time sink to root causes:


| Time sink                              | Est. hrs/day | Root cause                                                                               | Fix category           |
| -------------------------------------- | ------------ | ---------------------------------------------------------------------------------------- | ---------------------- |
| **Re-prompting after context loss**    | 2–4          | Agent doesn't read runtime_handoff or prior decisions; session context evaporates        | **Context delivery**   |
| **Iterating on broken output**         | 1–3          | Agent produces code that doesn't match spec; acceptance criteria unclear or not enforced | **Task specification** |
| **Manually setting up agent sessions** | 1–2          | No reliable "post task → agent picks it up" pipeline working end-to-end                  | **Pipeline execution** |
| **Debugging infra failures**           | 0.5–1        | PA crashes, Slack routing doesn't fire, bridge polling gaps                              | **Runner stability**   |
| **Performing steps agents should do**  | 0.5–2        | Deploy, test, commit, push — agent either can't or isn't trusted to                      | **Agent autonomy**     |


### Fix priorities (ordered by impact on HitM time)

#### Priority 1: Context Delivery (saves 2–4 hrs/day)

**Problem:** Agents start fresh every session. They re-derive decisions, miss prior work, contradict locked choices.

**Root cause chain:**

1. Runtime handoff notes exist but agents don't reliably read them
2. Context windows are too small to ingest everything
3. No mechanism forces the agent to read handoff before starting work

**Proposed fixes:**


| Fix                                                                                                                                                    | Effort     | Impact                                  |
| ------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------- | --------------------------------------- |
| **Mandatory handoff read** — task spec includes `READ FIRST: <path>` and acceptance criteria requires "demonstrate awareness of prior decisions"       | Low        | High — every task starts with context   |
| **Condensed handoff format** — runtime_handoff.md should be <200 lines, YAML-heavy, machine-readable state; narrative in separate file                 | Medium     | High — fits in context window           |
| **Decision log as append-only YAML** — every session appends locked decisions to a structured log that agents can parse without reading full narrative | Low–Medium | High — decisions don't get re-derived   |
| **Skill file enforcement** — `.cursor/skills/` include a "session start" skill that reads handoff before any code work                                 | Low        | Medium — depends on Cursor following it |


**Discussion prompt:** Which of these are implementable this week before the baby?

---

#### Priority 2: Task Specification (saves 1–3 hrs/day)

**Problem:** Agent output doesn't match spec because the spec was ambiguous or acceptance criteria weren't machine-checkable.

**Proposed fixes:**


| Fix                                                                                                                                                        | Effort                           | Impact                          |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- | ------------------------------- |
| **Structured task format** — every task includes: (1) Exact files to touch, (2) Exact behavior expected, (3) How to verify locally, (4) What NOT to change | Low                              | High — reduces ambiguity        |
| **Acceptance criteria as runnable checks** — "npm run build exits 0", "no TypeScript errors", "page renders at /route" — not prose                         | Low                              | Medium — automated V1           |
| **Scope locks** — explicitly list files/components agent must NOT touch                                                                                    | Low                              | High — prevents "helpful" drift |
| **Template for task posts** — standardized `#sprint-queue` post that forces all fields                                                                     | Already exists (sprint-queue-v1) | Medium — needs enforcement      |


**The sprint-queue-v1 format already covers this.** The issue is: tasks aren't being posted in this format consistently. When HitM reverts to free-form prompting, spec quality drops.

#### Priority 3: Pipeline Architecture Fix (saves 1–2 hrs/day)

> [!CAUTION]
> **The relay contract has the architecture backwards.** The current design routes tasks *through* Slack channels (`#sprint-queue` → `#review-queue` → `#hitm-gate`). This is **wrong**. Slack is for **monitoring and task initiation only**. Internal handoffs between executor and reviewer must happen **locally**, not through Slack.

**HitM's actual intent (DECIDED 2026-05-06):**

```
┌─────────────────────────────────────────────────────────────────┐
│  SLACK (monitoring + initiation only)                           │
│                                                                 │
│  HitM drops message                                             │
│  pinging @CursorPA ──────► Runner picks up ──► Inbox            │
│                                                                 │
│  During execution:          Status updates flow TO Slack        │
│  "Task received"            (outbox → runner → channel)         │
│  "Task finished"            These are INFORMATIONAL ONLY        │
│  "Review received"                                              │
│  "Review finished"                                              │
│  "Ready for manual verification"                                │
└─────────────────────────────────────────────────────────────────┘
          │ (initiation)                    ▲ (status pings)
          ▼                                 │
┌─────────────────────────────────────────────────────────────────┐
│  LOCAL PIPELINE (internal, not through Slack)                    │
│                                                                 │
│  ┌──────────┐    internal     ┌──────────┐    internal          │
│  │  CODER   │───handoff────►  │ REVIEWER │───handoff────►       │
│  │  (agent) │                 │  (agent) │                      │
│  │          │◄───feedback─── │          │    ┌──────────────┐  │
│  │          │   (if FAIL)     │          │───►│ Next slice   │  │
│  └──────────┘                 └──────────┘    │ task created │  │
│       │                            │          │ (back to     │  │
│       │ status ping                │ status   │  coder)      │  │
│       ▼                            │ ping     └──────────────┘  │
│  → Slack outbox                    ▼                            │
│    "Task finished"            → Slack outbox                    │
│                                "Review finished"                │
│                                                                 │
│  Loop until all slices done → "Ready for manual verification"   │
└─────────────────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────────┐
│  HITM MANUAL VERIFICATION                                       │
│  Visual check: does this match my spec?                         │
│  Approve or send feedback                                       │
└─────────────────────────────────────────────────────────────────┘
```

**What the relay contract got wrong:**

- Treated Slack as the routing bus between executor and reviewer
- `#review-queue` was designed as a "post work here for reviewer to pick up" — this adds latency, fragility, and complexity for no benefit
- `#hitm-gate` as a separate channel for reviewer → HitM routing — unnecessary when Slack is just for monitoring

**What needs to change in the scripts:**


| Component                         | Current role                                   | Corrected role                                                                       |
| --------------------------------- | ---------------------------------------------- | ------------------------------------------------------------------------------------ |
| `sprint_slack_pipeline_bridge.py` | Routes tasks between Slack channels            | **Deprecated for routing.** May retain as status aggregator if useful.               |
| `sprint_pipeline_emit_ready.py`   | Posts READY to Slack for bridge to pick up     | **Simplified:** Just posts a status ping to Slack outbox. Not a routing step.        |
| `cursor_slack_runner.py`          | Picks up Slack messages → inbox → agent-prompt | **Keep but simplify:** Picks up HitM task initiation only. Posts status from outbox. |
| Internal handoff mechanism        | **Doesn't exist** — this is the gap            | **Must be built:** Local file/queue for coder → reviewer → coder handoffs            |
| `#sprint-queue`                   | Task routing intake                            | **Rename role:** Task initiation from HitM only                                      |
| `#review-queue`                   | Executor → reviewer routing                    | **Repurpose:** Status monitoring channel (or remove from pipeline)                   |
| `#hitm-gate`                      | Reviewer → HitM routing                        | **Repurpose:** "Ready for manual verification" monitoring channel                    |


**The internal handoff mechanism is the key missing piece.** Options:


| Approach                    | How it works                                                                                                                 | Pros                                     | Cons                        |
| --------------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- | --------------------------- |
| **A — File-based queue**    | Coder writes to `handoff_to_reviewer.json`; reviewer polls/reads; reviewer writes to `next_slice.json`                       | Simple, debuggable, no new dependencies  | Requires polling or watcher |
| **B — Script chain**        | `agent-prompt` for coder → on exit 0, script calls `agent-prompt` for reviewer → on exit 0, script creates next slice → loop | Linear, predictable                      | Fragile if any step fails   |
| **C — Orchestrator script** | A single orchestrator script manages the coder→reviewer→coder loop, calling each agent in sequence                           | Centralized control; easy to add logging | Single point of failure     |


**HitM's description matches Option C most closely** — the PA runner picks up the task, calls the orchestrator, which manages the internal loop and drops status pings to the Slack outbox throughout.

**Discussion prompt:** Is Option C the right model? Should the orchestrator be a new script or a modification of existing `cursor_slack_runner.py`?

---

#### Priority 4: Runner Stability (saves 0.5–1 hr/day)

**CursorPA status (clarified 2026-05-06):**


| Aspect         | Status                                                                   |
| -------------- | ------------------------------------------------------------------------ |
| PA itself      | **Functional** — picks up messages, drops to inbox, calls agent-prompt   |
| The problem    | Backend automation scripts don't handle coder↔reviewer handoffs properly |
| MCP ping issue | CursorPA needs to be @pinged; MCP cannot ping properly "for some reason" |
| `agent-prompt` | Works but needs the scripts behind it fixed                              |


**PA is not the problem.** The scripts that PA calls are the problem — they don't manage the internal coder→reviewer loop. PA is the entry point; the gap is what happens after PA hands off.

---

## TP14: Claude Inclusion — Cost/Budget Reality

### Cursor budget reality (2026-05-06)


| Metric                         | Value                          |
| ------------------------------ | ------------------------------ |
| Current plan                   | Cursor Pro ($20/mo)            |
| Auto/Composer2 usage remaining | **~18%** until reset on May 28 |
| High model access              | **None** — exhausted           |
| Likely trajectory              | **Move to $200/mo** eventually |


**This is a forcing function.** At 18% remaining with 22 days left in the billing cycle, HitM is already capacity-constrained. The automation babysitting **accelerates** credit burn — prompting, re-prompting, and iterating eats credits faster than clean single-pass execution would.

### Cost model (revised)


| Option                                   | Monthly cost     | What it enables                                                          |
| ---------------------------------------- | ---------------- | ------------------------------------------------------------------------ |
| **A — Current ($20/mo Cursor)**          | $20              | Status quo; credits run out mid-month; HitM compensates with manual work |
| **B — Cursor $200/mo**                   | $200             | More credits; same model access; still single executor                   |
| **C — Cursor $200/mo + Claude reviewer** | $200 + API usage | Higher model for review tier; reduces iteration cycles                   |


**HitM's stated direction:** Likely $200/mo for Cursor eventually. Reviewer agent should use a higher model (Claude or similar) for code review quality.

### Reviewer integration path


| Phase         | What                                                                                      | When               |
| ------------- | ----------------------------------------------------------------------------------------- | ------------------ |
| **Now**       | Cursor handles both coding and review (same model, lower quality review)                  | Current            |
| **Near-term** | Cursor codes; a **higher-model Cursor agent** reviews (using $200/mo plan's model access) | Post-$200 upgrade  |
| **Future**    | Cursor codes; **Claude API** reviews (dedicated review model, separate cost)              | When budget allows |


### MCP tools for browser DOM (clarified)

CLI agents don't have inherent browser/DOM access. For visual verification:

- **Need:** MCP tools that give CLI agents browser DOM inspection capability
- **Purpose:** Automated visual spec compliance checking
- **Status:** "Fine for now" — not blocking, but needed for the V2 review tier to include visual checks
- **Implementation:** Browser MCP server that CLI agents can call to capture/inspect DOM state

---

## Updated Summary: The Automation Fix Plan

### The corrected architecture

**Slack = monitoring + initiation. Internal = routing.**

```
HitM                          Local Machine                    Slack
  │                               │                              │
  │── @CursorPA task ──────────►  │                              │
  │                               │── Runner picks up ───►  inbox│
  │                               │                              │
  │                               │── Orchestrator script runs:  │
  │                               │   ├── Coder agent executes   │
  │                               │   │   └── status ──────────► "Task received"
  │                               │   │   └── status ──────────► "Task finished"  
  │                               │   ├── Internal handoff       │
  │                               │   ├── Reviewer agent checks  │
  │                               │   │   └── status ──────────► "Review received"
  │                               │   │   └── status ──────────► "Review pass/fail"
  │                               │   ├── If FAIL: back to coder │
  │                               │   ├── If PASS: next slice    │
  │                               │   └── Loop until done        │
  │                               │   └── status ──────────────► "Ready for verification"
  │                               │                              │
  │◄── Notification ──────────────│                              │
  │                               │                              │
  │── Visual check ──────────────►│                              │
  │── Approve/feedback ──────────►│                              │
```

### Priority ordering (revised with HitM input)

#### P1 — Context delivery (this week, LOW effort)

- Mandatory `READ FIRST:` in every task spec
- Condensed handoff format (<200 lines, YAML-heavy)
- Append-only decision log
- Session-start skill enforcement

#### P2 — Task specification (this week, LOW effort)

- Enforce sprint-queue-v1 format
- Runnable acceptance criteria
- Explicit scope locks

#### P3 — Internal handoff mechanism (post-huddle, MEDIUM effort)

- Build orchestrator script for coder→reviewer→coder loop
- Status pings to Slack outbox at each stage
- Remove Slack-as-routing from pipeline scripts
- PA remains the entry point; orchestrator handles the internal loop

#### P4 — Model tier upgrade (when budget allows)

- Move to Cursor $200/mo for higher model access
- Reviewer agent uses higher model for quality review
- Future: Claude API as dedicated reviewer if Cursor models aren't sufficient
- MCP browser tools for visual verification (future)

### Implementation sequence (revised)

```
This week (huddle week):
  └── P1 + P2 (low effort, high impact)
      ├── Write condensed handoff template
      ├── Create append-only decision log format
      ├── Write sample sprint-queue-v1 tasks with acceptance criteria
      └── Session-start skill enforcement

Post-huddle → Baby (~3-4 weeks):
  ├── P3: Design and build orchestrator script
  ├── P3: Wire PA runner → orchestrator → coder → reviewer loop
  ├── P3: Status outbox integration at each pipeline stage
  └── Test pipeline end-to-end with a real feature task

Post-baby (Aug+):
  ├── P4: Evaluate $200/mo Cursor upgrade
  ├── P4: Test higher-model reviewer quality
  └── Measure: is HitM actually at <1 hr/day review?
```

**Discussion prompts:**

1. Is the priority ordering correct? Should Claude (P4) be elevated?
2. Can Priority 1+2 be implemented during this huddle week?
3. Is Cursor PA fixable, or should the pipeline use a different executor mechanism?
4. What's the budget ceiling for Claude API if we go that route?
5. Should we do a live end-to-end pipeline test before the huddle ends?

