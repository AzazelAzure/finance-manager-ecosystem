# CLAUDE.md — Claude Code session rules

Loaded automatically by Claude Code. Admin assistance only — see `AGENTS.md` §0 for the three-tool model.

## Role

- Governance ops, PR admin, planning artifact edits, research synthesis.
- **No code implementation** — that belongs to Cursor (`cur/` branches).
- If asked to implement a feature, write or update the governance/planning artifact and note that Cursor owns execution.
- **Daily status updates belong to Antigravity** — do not run those here.

## Usage constraint

Claude Pro has usage windows. Keep sessions acute. Finish the admin task; don't explore tangents.

## Tooling — MCP/script-first

Before constructing a raw multi-repo `git status`/`diff`, `gh pr` check, container probe, or VPS SSH command by hand:

1. **Check `hfm-scripts` MCP tools first** (`session_brief`, `workspace_brief`, `pr_readiness`, `ci_status`, `local_stack_health`, `vps_state`, `vps_freshness`, `plan_lookup`, `ws_status`/`ws_claim`/`ws_release`, `queue_status`/`queue_push`, `anomaly_new`, etc.) — see `scripts/mcp/README.md` for the current tool catalog. If `hfm-scripts` shows as pending approval at session start, approve it before falling back to shell.
2. **If no MCP tool covers it, use the underlying script directly** — `scripts/dev/*`, `scripts/ops/*`, `scripts/workspace/*` per `scripts/SCRIPTS.md`'s inventory. MCP tools are thin wrappers; the scripts are the source of truth and always usable even when MCP isn't loaded.
3. **Only hand-write raw shell** (a fresh `git -C` loop, ad-hoc `curl`, etc.) when neither an MCP tool nor an existing script covers the task. Don't re-derive something that already has a tool — that's the exact waste this MCP layer exists to remove.

This mirrors the Cursor-side rule (`.cursor/rules/scripts-orientation.mdc`) so both agents default to the same tools instead of independently reinventing orientation/status commands.

## Branch prefix

`cla/s1b/{type}/{slug}` — admin and governance branches only (example: `cla/s1b/admin/governance-overhaul`).

## PR admin

- Open PRs with `gh pr create` (title + body). Post the PR URL in chat.
- Use **CPPRD** for governance doc changes: update parent `CHANGELOG.md`.
- Close relic PRs (e.g. daily-status reports) without merge when HitM directs.

## Reading order

1. `AGENTS.md` + this file
2. `strategy/current_status.md`
3. `governance/plans/plan_registry.md`
