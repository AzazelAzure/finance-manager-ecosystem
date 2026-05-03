# T01 — Submodule + GitHub remote

## Objective

`finance_manager_web` exists as a proper git submodule of the ecosystem parent, tracking `git@github.com:AzazelAzure/finance-manager-web.git`.

## Steps (human or agent with git access)

1. In parent repo: `git submodule add git@github.com:AzazelAzure/finance-manager-web.git finance_manager_web`  
   - If path already exists as untracked files: follow git docs to import or move carefully (no data loss).
2. Inside `finance_manager_web/`: `git remote -v` → origin should be the GitHub URL above.
3. Ensure `.gitignore` includes `node_modules/`, `dist/`, `.env*local`.
4. Push submodule default branch; parent commit updates submodule SHA.

## Handoff output

- Parent PR: submodule pointer + `.gitmodules`
- Web repo PR: initial README + minimal legal files if needed

## Sibling check

Reflex plan [runtime_handoff.md](../../vps-reflex-bluegreen-recovery-53be/runtime_handoff.md) — avoid pushing parent during active VPS surgery without coordination.
