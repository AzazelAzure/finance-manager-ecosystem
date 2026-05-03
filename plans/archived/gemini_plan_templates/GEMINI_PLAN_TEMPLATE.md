# Gemini Plan Template (for Cursor execution)

Use this template when creating an implementation plan for Cursor.

## 0) Metadata
- Plan ID: `PLAN_<topic>_<YYYY-MM-DD>`
- Owner: Gemini
- Requested by: User / Gemini
- Status: `draft | ready_for_cursor | in_progress | blocked | done`
- Priority: `P0 | P1 | P2`
- Target repos/areas: (api / cli / reflex / docs / mixed)

## 1) Objective
State the business/engineering objective in 2-4 lines.

## 2) Scope
### In scope
- ...

### Out of scope
- ...

## 3) Inputs / Source Docs
List exact files used as source of truth:
- `design_docs/...`
- `plans/...`
- `docs/...`

## 4) Constraints & Guardrails
- User instruction overrides all plan details.
- Respect existing architecture unless explicitly changed.
- No destructive operations without explicit user approval.
- Keep docs updated when behavior changes.
- Use feature branches for all implementation work (no direct feature work on `main`/`master`).
- PR gate is Slack-first: post PR details to `#pull-requests`, wait/read automation authorization, then reconcile with GitHub checks/mergeability before merge.
- If Slack shows approved but GitHub shows `CONFLICTING` or `DIRTY`, treat as blocked until conflicts are resolved.

## 5) Execution Breakdown (Cursor-facing tasks)
For each task, provide:

### Task T1: <name>
- Goal:
- Files to edit:
- Implementation notes:
- Acceptance criteria:
- Verification commands:
- Risks/rollback notes:

### Task T2: <name>
- Goal:
- Files to edit:
- Implementation notes:
- Acceptance criteria:
- Verification commands:
- Risks/rollback notes:

## 6) Subagent Request Protocol (when needed)
Use subagents only for bounded, high-value parallelizable work.

### When to request subagents
- Broad codebase exploration across multiple areas.
- Independent tasks that can run in parallel (e.g., docs audit + lint pass).
- Long-running or specialized workflows (shell-heavy checks, browser verification).

### Subagent request format (to place in CHAT_LOG)
- Subagent type: `explore | generalPurpose | shell | browser-use | best-of-n-runner`
- Purpose (1 line):
- Exact deliverables:
- Scope boundaries (files/dirs):
- Readonly vs write mode:
- Completion criteria:

### Example subagent request
- Subagent type: `explore`
- Purpose: Identify all API envelope shapes consumed by Reflex transactions views.
- Deliverables: File list + envelope summary + mismatch risks.
- Scope boundaries: `finance_manager_reflex/features/transactions/`, `finance_manager_api/finance/views/tx_views.py`
- Mode: readonly
- Completion criteria: Return concise findings ready for direct implementation tasking.

## 7) Verification Plan
- Unit tests:
- Integration checks:
- CLI/manual smoke checks:
- Lint/type checks:

## 8) Documentation Updates Required
List docs that must be updated if implementation succeeds.

## 9) Handoff Entry for CHAT_LOG.md
Paste this block into `design_docs/CHAT_LOG.md`:

**[Gemini] - <YYYY-MM-DDTHH:MMZ>:**
*Task Assignment*
- Task ID: <...>
- Source plan: `plans/<plan_filename>.md`
- Requested change:
- Scope constraints:
- Acceptance checks:
- Verification command(s):
- Status: `planned`
- Notes/blockers:

## 10) Completion Criteria
Mark plan complete only when:
- Acceptance criteria are met,
- Verification commands pass (or failures are documented),
- Required docs are updated,
- Cursor report is logged in `CHAT_LOG.md`,
- PR has Slack authorization evidence in `#pull-requests`,
- GitHub mergeability/check/signoff gates are satisfied.
