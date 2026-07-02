---
name: skill-gap-detection
description: Scan this session's recent command and tool-call patterns for repeated manual sequences that could become a new skill or MCP tool. Produces a candidate wishlist only — does not build automatically. On-demand invocation for now.
---

# Skill Gap Detection (Cursor instance)

Cross-cutting doctrine skill, duplicate per agent. Automates the kind of exercise that produced
`cursor_skill_audit.md` / `combined_skill_plan.md` — each agent watches its own lane's friction.

## Doctrine

None yet — new territory as of 2026-07-02.

## Loads

None.

## Tools

None fixed — reviews session activity, not a specific external tool.

## Scheduling — resolved 2026-07-02

HitM: each agent self-schedules independently rather than routing through Antigravity or staying
purely on-demand. For this instance: a Cursor-side recurring trigger — likely a
`scripts/local/`-style cron installer (matching `scripts/local/schedule_agent_sync.sh`'s existing
pattern for a different job) invoking `cursor agent` on this skill. Not yet built as a live cron
job — this records the design decision; the actual installer script is a separate task.

## Procedure

1. When invoked, review recent session activity for repeated manual patterns: same tool-call
   sequences for similar tasks, recurring workarounds, governance lookups done by hand instead of MCP.
2. For each pattern: what it is, how often it recurred, what a skill or tool would need to reference.
3. Produce a wishlist only — do not build proposed skills/tools from this pass.
4. Report wishlist to HitM for review.

## Handoff

`Skill(s) used: skill-gap-detection` plus the wishlist as deliverable.
