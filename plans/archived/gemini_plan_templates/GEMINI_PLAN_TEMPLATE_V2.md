# Gemini Plan Template V2 (Collaboration & Living Design)

Use this template when creating an implementation plan for subagents or other collaborators. Adheres to the **11 Golden Rules** and the **Living Design System** philosophy.

## 0) Metadata
- Plan ID: `PLAN_<topic>_<YYYY-MM-DD>`
- Owner: Gemini (Agent)
- Requested by: User / Gemini
- Status: `draft | ready_for_execution | in_progress | blocked | done`
- Priority: `P0 | P1 | P2`
- Target repos/areas: (api / cli / reflex / docs / mixed)

## 1) Objective
State the business/engineering objective in 2-4 lines. Emphasize how this contributes to a "Living and Human" experience.

## 2) Scope
### In scope
- ...
### Out of scope
- ...

## 3) Inputs / Source Docs
- `design_docs/00_Coding_Guidelines.md` (Mandatory)
- `finance_manager_reflex/CHANGELOG.md` (Mandatory check before start)
- `design_docs/Roadmap_Overview.md`

## 4) Constraints & Guardrails (The 15 Golden Rules)
- **Efficiency & Readability:** Rules #1 & #2.
- **Lean & Focused:** Rules #3 & #4 (300-500 lines per file, one task per snippet).
- **Tooling:** Rule #5 (Create/reuse tools for shared logic).
- **DB Performance:** Rule #6 (Max 12 hits, 10 goal).
- **Seniority:** Rule #7 (No hacks, use standard dependencies).
- **Collaboration:** Rule #8 (Check CHANGELOG before, Update CHANGELOG after).
- **Lifecycle:** Rule #9 (Tag features to production phase/pipeline).
- **Stability:** Rule #10 ("Fix it Forever" - solve root causes).
- **Partnership:** Rule #11 (Feedback and tool recommendations are expected).
- **Traceability:** Rule #12 (Git First, clear commits and version tags).
- **Planning:** Rule #13 (Plan-Based Execution & Archiving).
- **Knowledge:** Rule #14 (Source of Truth hierarchy).
- **Execution:** Rule #15 (The Hive Protocol for complex builds).
- **PR Authorization Protocol (Workspace Standard):**
  - Post PR open message to Slack `#pull-requests` with repo, branch, and PR URL.
  - Wait/read Slack automation authorization (`approved`, `merged`, `changes_requested`, `blocked`).
  - Reconcile Slack authorization with GitHub mergeability/check state before merge.
  - If Slack says approved but GitHub is `CONFLICTING`/`DIRTY`, classify as blocked and resolve conflicts before merge.

## 5) Execution Breakdown

### Task T1: <name>
- **Goal:**
- **Files to edit:**
- **Design Fidelity:** How does this make the UI more "Living"? (e.g. adding depth, motion, or feedback).
- **Implementation notes:**
- **Acceptance criteria:**
- **Verification commands:**
- **Risks/rollback notes:**

### Task T2: <name>
- **Goal:**
- **Files to edit:**
- **Design Fidelity:**
- **Implementation notes:**
- **Acceptance criteria:**
- **Verification commands:**

## 6) Subagent Request Protocol
- Subagent type: `explore | generalPurpose | shell | browser-use`
- Purpose:
- Mode: `readonly | write`
- Completion criteria:

## 7) Verification Plan
- Unit tests:
- Integration/Reflex Smoke Checks:
- Design Audit: Does it feel "Living" and "Human"? (Motion check, depth check).

## 8) Documentation & Feature Tracking
- [ ] Update `CHANGELOG.md` for relevant subsection (Rule #8).
- [ ] Update Roadmap/Production Phase tagging if applicable (Rule #9).
- [ ] Document any new tools created (Rule #5).

## 9) Completion Criteria
- 11 Golden Rules satisfied.
- Acceptance criteria met.
- Root cause resolved (no bandaids).
- Feedback/Tool suggestions provided (if any).
- **Atomic Commit**: Changes committed on feature branch(es) with clear description.
- **PR Gate**: Slack authorization observed in `#pull-requests` and GitHub mergeability/check/signoff gates satisfied.
- **Version Tag**: Repository tagged with incremented `vX.Y.Z`.
- **Plan moved to `plans/archived/` upon completion.**
