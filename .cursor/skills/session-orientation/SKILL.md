---
name: session-orientation
description: Use at the start of every Cursor execution session in this repo. Confirms branch-prefix convention, reading order, and current workspace claim state before any implementation, PR, or runtime work begins.
---

# Session Orientation

Doctrine skill (session-start-loaded, duplicate-per-agent — this is Cursor's instance; Claude's
is `session-kickoff`). Per `skill_architecture.md`, this is deliberately thin: session-level
residue only, not a "read all of governance" front-load. Every phase skill loads its own
doctrine at point of use.

## Doctrine

- `AGENTS.md` §6 — Cursor reading order (exists for reference; don't re-read all of it here).
- `.cursor/rules/core-standards.mdc`, `git-repo-workflow.mdc`, `scripts-orientation.mdc`,
  `container-testing-orchestration.mdc`, `anomaly-log.mdc`, `agent-delegation.mdc` — cited as
  always-applied rules, not loaded inline.

## Loads

None — this is the floor.

## Tools

- `session_brief` — session-start orientation snapshot.
- `ws_status` — pre-existing workspace claims and dirty state.

## Procedure

1. Run `session_brief` at session start.
2. Run `ws_status` before claiming workspace or starting repo work — note any pre-existing
   claims or dirty state.
3. Confirm branch prefix for anything this session creates: `cur/s1b/{feat|fix|chore|hotfix}/<slug>`.
4. Note `AGENTS.md` §6 reading order exists — don't re-read all of it here; that's each phase
   skill's job at point of use.
5. Hand off to the task-specific phase skill that matches the session's actual work.

## Handoff

N/A — not a delegating skill.
