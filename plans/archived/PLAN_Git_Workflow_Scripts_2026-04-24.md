# Gemini Plan Template (for Cursor execution)

## 0) Metadata
- Plan ID: `PLAN_Git_Workflow_Scripts_2026-04-24`
- Owner: Gemini
- Requested by: User
- Status: `ready_for_cursor`
- Priority: `P1`
- Target repos/areas: `scripts/` (workspace root)

## 1) Objective
Create a suite of Bash scripts at the workspace root to automate Git tasks across a multi-repo environment (`finance_manager_api`, `finance_manager_cli`, `finance_manager_reflex`).

## 2) Scope
### In scope
- Creating the `scripts/` directory at the root if it doesn't exist.
- Implementing robust, executable bash scripts that iterate over the 3 component directories to perform common Git operations.
- `scripts/status.sh`: Run `git status -s` and show current branch across all repos.
- `scripts/git_sync.sh`: Fetch and pull latest changes for the current branch in all repos.
- `scripts/feature_branch.sh <branch_name>`: Create and checkout a new branch uniformly.
- `scripts/tag_release.sh <tag_name>`: Tag the current commit in all repos.

### Out of scope
- Modifying the component code or any existing tests.
- Actually initializing the Git repos (the user/admin will do this manually or via another process; these scripts assume the directories are or will be Git repos).

## 3) Inputs / Source Docs
- `design_docs/30_Releases/Git_and_Workflow_Strategy.md`
- The target directories:
  - `finance_manager_api/`
  - `finance_manager_cli/`
  - `finance_manager_reflex/`

## 4) Constraints & Guardrails
- Scripts must be generic enough to handle adding the Rust middleware folder later.
- If a folder is not a valid Git repository, the script should print a warning for that folder and continue to the next, not crash entirely.
- Ensure scripts are executable (`chmod +x`).

## 5) Execution Breakdown (Cursor-facing tasks)

### Task T1: Create `status.sh`
- Goal: Provide a quick multi-repo git status overview.
- Files to edit: `scripts/status.sh`
- Implementation notes: Loop over `finance_manager_api`, `finance_manager_cli`, `finance_manager_reflex`. Use `git branch --show-current` and `git status -s`.
- Acceptance criteria: Outputs a readable summary of each repo's branch and uncommitted changes.

### Task T2: Create `git_sync.sh`
- Goal: Automate pulling latest changes across all repos.
- Files to edit: `scripts/git_sync.sh`
- Implementation notes: Loop over repos. Run `git pull origin $(git branch --show-current)`. Handle detached HEAD gracefully.
- Acceptance criteria: Updates each repo's current branch from the remote.

### Task T3: Create `feature_branch.sh`
- Goal: Uniformly checkout a new branch.
- Files to edit: `scripts/feature_branch.sh`
- Implementation notes: Accept a branch name as `$1`. Validate input. Loop over repos and run `git checkout -b "$1"`.
- Acceptance criteria: Successfully creates a new feature branch in all available repos.

### Task T4: Create `tag_release.sh`
- Goal: Cut a unified release tag across repos.
- Files to edit: `scripts/tag_release.sh`
- Implementation notes: Accept a tag name as `$1`. Validate input. Loop over repos and run `git tag "$1"`.
- Acceptance criteria: Successfully tags the current commit in all available repos.

## 6) Subagent Request Protocol (when needed)
- Subagent type: `shell`
- Purpose: Test script execution.
- Scope boundaries: `scripts/` directory.

## 7) Verification Plan
- CLI/manual smoke checks: Run `scripts/status.sh` locally to ensure it loops through the directories and prints the expected output (even if the folders aren't git repos yet, it should print the safe failure warning).

## 8) Documentation Updates Required
- Create a `scripts/README.md` explaining how to use these 4 scripts.

## 9) Completion Criteria
Mark plan complete only when:
- Scripts are created and marked executable.
- `scripts/README.md` is populated.
- The Cursor report is logged in `CHAT_LOG.md`.