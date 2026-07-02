---
name: session-kickoff
description: Use at the start of every Claude Code admin session in this repo. Confirms branch-prefix convention, reading order, and current workspace/plan state before any governance, PR-admin, or planning work begins.
---

# Session Kickoff

Doctrine skill (session-start-loaded, duplicate-per-agent — this is Claude's instance; Cursor's
is `session-orientation`, tailored to its own lane). Per `skill_architecture.md`'s resolution,
this is deliberately thin: session-level residue only, not a "read all of governance" front-load.
Every later skill in this set loads its own doctrine at point of use — this skill doesn't
pre-load it for them.

## Doctrine

- `CLAUDE.md` — role (admin/governance/planning only, no code implementation), branch prefix
  (`cla/s1b/{type}/{slug}`), tooling rule (MCP/script-first), reading order.
- `AGENTS.md` §6 — the wider ecosystem reading order, for context on what Cursor/Antigravity see.

## Loads

None — this is the floor.

## Tools

- `session_brief` — session-start orientation snapshot.
- `workspace_brief` — queue / sign-out context.
- `plan_lookup` — orient to whatever plan(s) are currently active.

## Procedure

1. Run `session_brief` (and `workspace_brief` if picking up mid-queue-cycle).
2. Confirm branch prefix for anything this session creates: `cla/s1b/{type}/{slug}`.
3. Note `CLAUDE.md`'s reading order exists (`AGENTS.md` + `CLAUDE.md` → `strategy/current_status.md`
   → `governance/plans/plan_registry.md`) — don't re-read all of it here; that's what `plan_lookup` and
   the task-specific skill below are for.
4. Do not do governance/planning work from this skill directly — it hands off to whichever
   task-specific skill matches what the session is actually about (design review, status
   verification, meeting facilitation, etc.).
