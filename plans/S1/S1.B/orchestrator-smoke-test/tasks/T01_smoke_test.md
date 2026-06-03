# T01 — Orchestrator Pipeline Validation

## End State

A file exists at `plans/S1/S1.B/orchestrator-smoke-test/output/smoke_result.md` containing:
- A summary of the project's governance directory (file names and line counts)
- The current git branch name
- The current date/time
- Confirmation that the orchestrator pipeline completed successfully

No production code is modified. No existing files are changed. This task only creates new files in the smoke test output directory.

## Acceptance Criteria

1. [V0] File `plans/S1/S1.B/orchestrator-smoke-test/output/smoke_result.md` exists
2. [V0] File contains a list of governance files with line counts
3. [V0] File contains the current git branch name
4. [V0] No files outside `plans/S1/S1.B/orchestrator-smoke-test/output/` were created or modified

## Scope Lock

### Files to create
- `plans/S1/S1.B/orchestrator-smoke-test/output/smoke_result.md`

### Files to modify
- (none)

### Files NOT to touch
- Everything else. This is a read-only validation task.
- Especially: `governance/*`, `finance_manager_api/*`, `finance_manager_web/*`

## Technical Decisions (pre-locked)

- Per D01: Read-only smoke test. No production changes.

## Slice Decomposition

| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T01.SL1 | Generate smoke result | V0 | Read governance directory, get git branch, write smoke_result.md |

## Anti-Patterns (do NOT do these)

- Do NOT modify any existing files
- Do NOT run npm, pip, or any package manager commands
- Do NOT access files outside the project workspace
- Do NOT create files outside the output/ directory
- Do NOT run git commands that modify state (only `git branch --show-current` is allowed)

## Context Links

- Plan root: `plans/S1/S1.B/orchestrator-smoke-test/`
- Decision Log: `plans/S1/S1.B/orchestrator-smoke-test/DECISION_LOG.md`
- Runtime handoff: `plans/S1/S1.B/orchestrator-smoke-test/runtime_handoff.md`
