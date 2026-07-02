# Inter-Agent Message Relay and Ownership Contract

## Purpose

Defines how messages are **structured**, **routed**, and **owned** across the four-agent pipeline so relays do not silently corrupt intent when multiple executors participate concurrently.

**Canonical path:** `governance/coordination/Inter_Agent_Message_Relay_and_Ownership_Contract.md`

**Related:**
- `governance/archived/agent_workspace_isolation.md` — directory layout, git identity, concurrency rules
- `AGENTS.md` §0 — three-tool model: Claude Code / Cursor / Antigravity (canonical; the legacy Slack-bridge design doc was retired 2026-06-30)
- `scripts/antigravity_slack_runner.py` — deprecated (governance overhaul PR #62) (updated 2026-06-29)
- `scripts/cursor_headless_slack_agent.py` — deprecated (governance overhaul PR #62) (updated 2026-06-29)

---

## Runtime Entities

Four identities, each with a dedicated workspace clone. No two share a working directory.

| Entity | GitHub Account | Role | Workspace | Runner |
|--------|---------------|------|-----------|--------|
| **HitM** | AzazelAzure | Orchestrator + V3 Gate | `~/Documents/python/finance_manager/` | Manual (human) |
| **cursor-executor** | Proctor-Cursor-Agents | Executor (Cursor auto/flash) | `~/agent-workspaces/cursor-executor/finance_manager/` | three-tool model: Claude Code / Cursor / Antigravity (updated 2026-06-29) |
| **antigravity-executor** | Proctor-Gemini-Executor | Executor (Gemini Flash) | `~/agent-workspaces/antigravity-executor/finance_manager/` | deprecated (governance overhaul PR #62) (updated 2026-06-29) |
| **antigravity-reviewer** | Proctor-Gemini-Agent | Reviewer (Gemini Pro) | `~/agent-workspaces/antigravity-reviewer/finance_manager/` | deprecated (governance overhaul PR #62) (updated 2026-06-29) |

**Identity rule:** every relay message names **exactly one** `owning_entity` for the current action and **at most one** `next_owner` (or explicit `none`).

---

## Slack Channel Architecture

Three pipeline channels (locked 2026-05-04, huddle D8) plus existing operational channels:

### Pipeline Channels (new)

| Channel | Purpose | Who posts | Who reads |
|---------|---------|-----------|-----------|
| `#sprint-queue` | Slice execution intake — Orchestrator posts task specs, executors pick up work | HitM, antigravity-reviewer (returning FAIL feedback) | cursor-executor, antigravity-executor |
| `#review-queue` | Executor posts completed slices with V1 evidence for review | cursor-executor, antigravity-executor | antigravity-reviewer |
| `#hitm-gate` | Reviewer posts PASS verdicts for HitM V3 verification | antigravity-reviewer | HitM |

### Existing Channels (retained)

| Channel | Purpose | Relationship to pipeline |
|---------|---------|--------------------------|
| `#cli-interface` | Cursor PA ad-hoc tasks (non-sprint work, quick fixes) | **Outside** pipeline; used for unplanned work or debugging |
| `#pull-requests` | PR lifecycle announcements | **Cross-cutting** — all entities that open PRs post here per existing protocol |
| `#beta-incidents` | Bug/incident intake | **Outside** pipeline; feeds into sprint-queue when triaged |

### Channel Routing Rules

1. **No entity posts to a channel it doesn't own.** See table above.
2. **Pipeline flow is unidirectional:** `#sprint-queue` → executor → `#review-queue` → reviewer → `#hitm-gate` → HitM. Failures loop back: `#review-queue` FAIL → `#sprint-queue`.
3. **`#cli-interface` is NOT part of the pipeline.** It remains the ad-hoc channel for Cursor PA direct tasking. Do not mix sprint slice work with ad-hoc PA requests.
4. **Thread discipline:** every slice gets its own top-level message. All status updates for that slice are threaded replies. No cross-slice chatter in the same thread.

---

## Message Format

### Slice Task (HitM → #sprint-queue)

Posted by HitM (Orchestrator) to assign work to an executor:

```
SLICE: T04.SL1
PLAN: plans/S1/S1.B/feat-f007-guided-walkthroughs/
REPO: finance_manager_web
BRANCH: agy/s1b/feat/f007-guided-walkthroughs
V_TIER: V3
EXECUTOR: cursor-executor | antigravity-executor
SCOPE: |
  TransactionsPage.tsx — List & Search Discovery tour
  Must not touch DashboardPage.tsx (assigned to other executor)
ACCEPTANCE: |
  No missing-target console errors; tour completes or skips cleanly
  Screenshot evidence required (V3)
```

### Slice Completion (Executor → #review-queue)

Posted by an executor after completing a slice:

```
SLICE: T04.SL1
PLAN: plans/S1/S1.B/feat-f007-guided-walkthroughs/
REPO: finance_manager_web
BRANCH: agy/s1b/feat/f007-guided-walkthroughs
COMMIT: abc1234
EXECUTOR: cursor-executor
V_TIER: V1
V1_EVIDENCE: |
  Build passes: `npm run build` exit 0 (log attached)
  No TypeScript errors
READY_FOR: antigravity-reviewer
```

### Review Verdict (Reviewer → #review-queue or #hitm-gate)

```
SLICE: T04.SL1
REVIEWER: antigravity-reviewer
VERDICT: PASS | FAIL | WAIVE
V_TIER: V2
V2_EVIDENCE: |
  Deployed to inactive blue: smoke passes
  Smoke log attached
NEXT: hitm-gate (if PASS) | sprint-queue (if FAIL)
FEEDBACK: |
  (if FAIL) Missing target on .tour-step-3; console error at line 47
```

---

## Ownership and Handoff Rules

### Write Lock

Only **one entity** may hold the write lock on a branch at any time. Ownership is transferred explicitly via the `EXECUTOR` or `READY_FOR` field in the Slack message. There is no implicit handoff.

| State | Write lock holder | Next |
|-------|------------------|------|
| Task posted to `#sprint-queue` | HitM (orchestrator) | Assigned executor |
| Executor working on slice | Named executor | Executor (until completion post) |
| Completion posted to `#review-queue` | Reviewer | Reviewer reads; executor must not push |
| Review PASS → `#hitm-gate` | HitM | HitM runs V3 |
| Review FAIL → `#sprint-queue` | Executor (re-assigned) | Executor fixes and re-posts |

### Branch Ownership

- **Cursor executor** uses branches: `agy/s1b/feat/<feature>` or `agy/s1b/feat/<feature>/t##-<slug>` (updated 2026-06-29)
- **Antigravity executor** uses branches: `antigravity/s1b/feat/<feature>` or `antigravity/s1b/feat/<feature>/t##-<slug>`
- **Two executors must NEVER push to the same branch.** If a feature needs both executors (e.g., API + web), they use different branches in different subrepos.

---

## Failure Modes and Mitigations

| Failure | Cause | Mitigation |
|---------|-------|------------|
| Two executors edit same file | Orchestrator assigned overlapping scope | Isolation rule #2: slice scope must be non-overlapping; Orchestrator error |
| Wrong entity picks up task | Ambiguous `EXECUTOR` field | Explicit named entity in every task message; runner checks identity |
| Stale code in workspace | Executor didn't pull before starting | Isolation rule #3: agents pull before starting; runner pre-task `git pull` |
| Review of own code | Executor and reviewer are same model | **Blocked by design:** Proctor-Gemini-Executor ≠ Proctor-Gemini-Agent; different workspaces |
| VPS deploy collision | Two agents deploy simultaneously | VPS is serialized: only one deploy at a time, coordinated via `#review-queue` threading |
| Runner posts to wrong channel | Misconfigured `AG_SLACK_CHANNEL` | Each runner has exactly one intake channel; validate at startup |

---

## Idempotency

Slack can duplicate delivery. Runners process messages **at-least-once**:

- State files (`.antigravity_slack_state.json`, `.cursor_slack_agent_state.json`) track the last processed `ts` per channel.
- Re-processing the same `ts` is a no-op (timestamp comparison).
- If a runner crashes mid-task, it will re-process the message on restart. The executor must handle this gracefully (e.g., `git push` is idempotent if the branch already has the commits).

---

## Phased Rollout

### Phase 1 (Current — Manual Pipeline)
- HitM posts tasks in `#sprint-queue` manually
- Executors work in their isolated workspaces
- Executors post results in `#review-queue` manually (or via runner auto-reply)
- Reviewer reads and posts verdict
- HitM does V3 verification

### Phase 2 (Slack Runners Active)
- `cursor_headless_slack_agent.py` (deprecated; Antigravity Pro handles scheduled automation) (updated 2026-06-29)
- `antigravity_slack_runner.py` (deprecated; Antigravity Pro handles scheduled automation) (updated 2026-06-29)
- A second `antigravity_slack_runner.py` instance (deprecated; Antigravity Pro handles scheduled automation) (updated 2026-06-29)
- Runners auto-reply with results in thread

### Phase 3 (Full Automation — Future)
- Structured envelope with `correlation_id`, `schema_version` (from original draft)
- Idempotency ledger beyond timestamp tracking
- Automated slice-to-slice progression when V-tier allows
- `sprint_verify.sh` automated smoke test integration

---

## Superseded Content

This document replaces the original draft `14_Inter_Agent_Message_Relay_and_Ownership_Contract.md` (2026-05-05) which defined a four-entity model with "Cursor PA" as a separate entity. The corrected model treats PA as a runner process for the `cursor-executor` role, not a separate identity.

Channel references to `#cli-interface` as pipeline intake are superseded by `#sprint-queue` (pipeline) vs `#cli-interface` (ad-hoc only).

---

## Revision History

| Date | Change |
|------|--------|
| 2026-05-05 | Initial draft (four-entity + relay envelope). |
| 2026-05-04 | Rewritten to align with workspace isolation, four-identity model, and locked Slack channel architecture from orchestration huddle. Phased envelope approach. |
