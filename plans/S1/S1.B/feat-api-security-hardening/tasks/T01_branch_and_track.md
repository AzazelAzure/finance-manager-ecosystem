# T01 — Branch Hygiene and Validator Tracking

## End State
The API repo is on a clean named branch `cur/s1b/feat/api-security-hardening` (no detached HEAD), the existing security WIP commits are on that branch, and `finance/validators/password_complexity.py` is tracked by git as a staged new file.

## Acceptance Criteria
1. [V0] `git branch` shows `cur/s1b/feat/api-security-hardening` as current; no detached HEAD
2. [V0] `git status` shows `finance/validators/password_complexity.py` as a tracked file (staged or committed)
3. [V1] `python manage.py check` passes (no import errors from WIP settings changes)

## Scope Lock

### Actions
- From current detached HEAD state: `git checkout -b cur/s1b/feat/api-security-hardening`
- `git add finance/validators/password_complexity.py`
- Verify `ComplexPasswordValidator` is importable (run `python manage.py check`)
- Do not commit yet — leave staged for T02 to wire in

### Files NOT to touch
- Any endpoint files (T02 scope)
- Any migration files (T03 scope)

## Slice Decomposition
| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T01.SL1 | Create branch | V0 | `git checkout -b cur/s1b/feat/api-security-hardening` from current WIP state; verify no detached HEAD |
| T01.SL2 | Track validator | V0 | `git add finance/validators/password_complexity.py`; `python manage.py check` passes |

## Evidence
- `evidence/T01.SL1_branch_status.txt` — output of `git status` + `git log --oneline -5`
- `evidence/T01.SL2_manage_check.txt` — output of `python manage.py check`

## Clarifying Questions (ask HitM before proceeding if unclear)
1. Is the existing WIP on the API repo's HEAD the complete intended set of changes, or are there additional local modifications in the working tree that should also be included?
2. Should the existing WIP commits be squashed into one, or kept as-is?
