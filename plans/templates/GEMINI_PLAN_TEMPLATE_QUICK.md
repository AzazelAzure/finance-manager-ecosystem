# Gemini Quick Plan Template (small tasks)

Use this template for low-risk, narrowly scoped tasks that do not require a full multi-phase plan.

## 0) Metadata
- Plan ID: `PLAN_<topic>_<YYYY-MM-DD>`
- Status: `draft | ready_for_cursor | in_progress | blocked | done`
- Priority: `P0 | P1 | P2`
- Target area: `api | cli | reflex | docs | mixed`

## 1) Objective (1-3 lines)
What should change and why.

## 2) Scope
### In scope
- ...

### Out of scope
- ...

## 3) Cursor Task Block
- Task ID:
- Files to edit:
- Requested change:
- Acceptance criteria:
- Verification command(s):
- Expected output/artifacts:

## 4) Subagent (optional)
Only include if needed.

- Subagent type: `explore | generalPurpose | shell | browser-use | best-of-n-runner`
- Purpose:
- Deliverables:
- Scope boundaries:
- Mode: `readonly | write`

## 5) Docs Impact
- Docs to update (if any):

## 6) Handoff Snippet for `design_docs/CHAT_LOG.md`

**[Gemini] - <YYYY-MM-DDTHH:MMZ>:**
*Task Assignment (Quick Plan)*
- Task ID: <...>
- Source plan: `plans/<plan_filename>.md`
- Requested change:
- Scope constraints:
- Acceptance checks:
- Verification command(s):
- Status: `planned`
- Notes/blockers:

## 7) Completion Rule
Mark done only after verification runs, Cursor logs outcome in `design_docs/CHAT_LOG.md`, Slack `#pull-requests` authorization is observed, and GitHub mergeability/check/signoff gates are satisfied.

## 8) PR Authorization Protocol (Mandatory)
- Open PR from a feature branch (never direct feature work on `main`/`master`).
- Post PR details to Slack `#pull-requests` (repo, branch, PR URL).
- Wait/read Slack automation final state before merge actions.
- Reconcile Slack authorization with GitHub mergeability/check state.
- If Slack says approved but GitHub is `CONFLICTING` or `DIRTY`, treat as blocked until conflict resolution completes.
