# PR #12 Design Docs Conflict Note

## Objective
Record the observed merge issue in `finance-manager-ecosystem` PR #12 so the worker resolving that PR can target the actual conflict without disturbing active submodule work.

## Observed PR State
- PR: `https://github.com/AzazelAzure/finance-manager-ecosystem/pull/12`
- Branch: `cursor/api-reflex-beta-readiness-plan-53be`
- GitHub merge state: `DIRTY`
- Files changed by PR #12:
  - `design_docs`
  - `finance_manager_api`
  - `scripts/cursor_headless_slack_agent.py`

## Root Cause
The merge conflict is the parent repo's `design_docs` submodule gitlink.

`git merge-tree` reported:

```text
changed in both
  base   160000 40ffb6fc30a76d589e3b7dae9879e76bf30eab94 design_docs
  our    160000 59e60d1450dc8a8c280a773ea4a382b73ffa168a design_docs
  their  160000 22565127cc1ad7d3410af0917d7dbd8d41c7598f design_docs
```

`finance_manager_api` and `scripts/cursor_headless_slack_agent.py` merged cleanly in the same merge-tree analysis.

## Interpretation
- `origin/main` already advanced `design_docs` to `59e60d1`.
- PR #12 advances `design_docs` to `2256512`, likely the docs commit from `finance-manager-design-docs` PR #7.
- Git cannot auto-resolve submodule pointers when both sides changed the gitlink, even when the desired resolution is probably the newer docs commit.
- Dependent PRs observed as merged:
  - `finance-manager-design-docs` PR #7: merged.
  - `finance-manager-api` PR #16: merged.

## Recommended Resolution
On PR #12's branch, update the parent repo gitlink to the intended merged docs commit, then commit and push.

Suggested worker steps:

```bash
git fetch origin main
git checkout cursor/api-reflex-beta-readiness-plan-53be
git pull origin cursor/api-reflex-beta-readiness-plan-53be
git -C design_docs fetch origin main
git -C design_docs checkout 22565127cc1ad7d3410af0917d7dbd8d41c7598f
git add design_docs
git commit -m "chore: resolve design docs pointer conflict"
git push -u origin cursor/api-reflex-beta-readiness-plan-53be
```

If `2256512` is not the desired final design-docs commit, replace it with the merge commit on `finance-manager-design-docs/main` that contains PR #7.

## Verification
- `git ls-tree HEAD design_docs` shows the intended docs commit.
- `gh pr view 12 --repo AzazelAzure/finance-manager-ecosystem --json mergeStateStatus` no longer reports `DIRTY`.
- Re-read `#pull-requests` automation state and reconcile with GitHub checks before merge.
