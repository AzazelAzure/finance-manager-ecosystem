# T01 — `+Bill` Disable Retroactive Commit

## Objective

Commit the `+Bill` quick-action disable that was applied as a runtime hotfix during S1.A launch sprint but never made it to git. Eliminates the runtime/source drift flagged in BP7 snapshot.

## Scope Boundary

- Repo: `finance_manager_web/`
- Branch: `cursor/s1b/drift-cleanup/t01-bill-disable-retro-commit`
- Files: `src/components/dashboard/QuickActions.tsx` (or wherever the disable lives in current codebase)
- No deploy required — code already running on VPS; this just brings git into alignment.

## Current Evidence

Per `design_docs/10_Current_State/01_Runtime_Validation_Checklist.md` §H BP7 snapshot:

> "Important restore note: the deployed `+Bill` disable is currently a VPS hotfix in the runtime build context (`finance_manager_web/src/components/dashboard/QuickActions.tsx`) and is not represented by a new git commit hash yet."

## Implementation Notes

1. SSH to VPS as `dev@159.198.75.194`.
2. `cd ~/finance_manager/finance_manager_web` and check the running code state.
3. Compare with your local **`finance_manager_web`** submodule: `src/components/dashboard/QuickActions.tsx` (sibling under the parent repo root).
4. Apply the same disable to the local clone if not present.
5. Commit on branch `cursor/s1b/drift-cleanup/t01-bill-disable-retro-commit`.
6. Open PR to `main`.
7. Per HitM lesson 6.4, also create a follow-up TODO for the eventual `+Bill` rework (Issue #2 → "quick pay bill" feature in W3).

## Acceptance Criteria

- Local `finance_manager_web/src/components/dashboard/QuickActions.tsx` matches VPS runtime state.
- Git commit hash now represents the deployed code.
- PR merged.
- BP7 snapshot note updated in `01_Runtime_Validation_Checklist.md` §H to remove the "not in git" caveat.
- Follow-up task tracked for Issue #2 (quick pay bill rework).

## Verification Commands

```bash
# Local compare
diff finance_manager_web/src/components/dashboard/QuickActions.tsx \
     <(ssh dev@159.198.75.194 cat ~/finance_manager/finance_manager_web/src/components/dashboard/QuickActions.tsx)

# After commit
git log --oneline -5 finance_manager_web/src/components/dashboard/QuickActions.tsx
```

## Risks / Rollback

- Trivial; if disable is wrong (e.g. should be enabled now), revert the commit. No production impact since runtime is already in disabled state.

## Slack Gates

- `pre_execution`: required (P0 plan default).
- `pre_merge`: required.
- `pre_close`: optional (low-risk paperwork-style task).

## Estimated Effort

5–15 minutes.
