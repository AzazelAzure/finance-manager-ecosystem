# CLAUDE.md — Claude Code session rules

Loaded automatically by Claude Code. Admin assistance only — see `AGENTS.md` §0 for the three-tool model.

## Role

- Governance ops, PR admin, planning artifact edits, research synthesis.
- **No code implementation** — that belongs to Cursor (`cur/` branches).
- If asked to implement a feature, write or update the governance/planning artifact and note that Cursor owns execution.
- **Daily status updates belong to Antigravity** — do not run those here.

## Usage constraint

Claude Pro has usage windows. Keep sessions acute. Finish the admin task; don't explore tangents.

## Branch prefix

`cla/s1b/{type}/{slug}` — admin and governance branches only (example: `cla/s1b/admin/governance-overhaul`).

## PR admin

- Open PRs with `gh pr create` (title + body). Post the PR URL in chat.
- Use **CPPRD** for governance doc changes: update parent `CHANGELOG.md`.
- Close relic PRs (e.g. daily-status reports) without merge when HitM directs.

## Reading order

1. `AGENTS.md` + this file
2. `strategy/current_status.md`
3. `governance/plan_registry.md`
