---
name: skill-gap-detection
description: Use periodically, or when explicitly invoked, to scan this session's own recent command and tool-call patterns for repeated manual sequences that could become a new skill or MCP tool. Produces a candidate wishlist only — does not build anything automatically.
---

# Skill Gap Detection (Claude instance)

Cross-cutting doctrine skill, duplicate per agent (HitM, 2026-07-02: "each agent has different
scope, so their perspective on skills particular to their lane will be unique"). This is the
Claude-lane version — automates the same kind of exercise that produced
`cursor_skill_audit.md`/`claude_skill_inventory.md`/`combined_skill_plan.md`, so it doesn't have
to happen as a one-off meeting deep-dive every time.

## Doctrine

None yet — this is new territory as of 2026-07-02, no governing doc predates it.

## Loads

None.

## Tools

None fixed — this reviews session activity/history, not a specific external tool.

## Scheduling — resolved and live, 2026-07-02

HitM: each agent self-schedules independently. Live routine created via Claude Code's `schedule`
mechanism: **"Weekly Skill Gap Detection (Claude, HFM)"**, `trig_01VtGi5taki4rsMGxh2cx6hB`,
weekly Sunday 23:00 Asia/Manila (`0 15 * * 0` UTC) — deliberately timed after weekly credit-usage
reset and outside work hours.

**Important constraint the live routine had to account for, not present in the on-demand version
above:** this runs as a **cloud** agent — isolated sandbox, fresh clone, zero access to local
session history or uncommitted state. It cannot literally do step-by-step "scan this session's
tool-call patterns" (there is no session to scan). The scheduled version instead reviews what's
**committed and pushed** since its last run — recent `strategy/meetings/` folders,
`strategy/anomalies/`, and `git log` — for repeated friction patterns documented in writing, and
opens a PR with a `strategy/automations/reports/skill_gap_scan_<date>.md` wishlist (or an honest
"nothing new" if it finds no pattern). This is a narrower, cloud-appropriate version of the
on-demand procedure below, not identical to it — the on-demand version (this file's own
Procedure) stays as the fuller version for actual live sessions.

Cursor's instance needs its own separate trigger (not this one) — see that skill's own file;
likely a `scripts/local/`-style cron installer, not yet built.

## Procedure

1. When invoked, review recent session activity for repeated manual patterns: the same sequence
   of tool calls run more than once for materially similar tasks, a recurring multi-step
   workaround, a governance lookup that keeps happening by hand instead of through a tool.
2. For each pattern found, note: what it is, how often it's recurred, what a skill or tool
   covering it would need to reference (doctrine, existing tools it could wrap).
3. Produce a wishlist — do not build the proposed skill/tool from this pass. That's a separate,
   explicit decision (same gate as the rest of this session's skill-generation work).
4. Report the wishlist to HitM for review, same shape as `combined_skill_plan.md`'s disposition
   tables (position, evidence, candidate doctrine/tools).

## Handoff

`Skill(s) used: skill-gap-detection` plus the wishlist itself as the deliverable — not a
delegation to another skill.
