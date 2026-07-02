---
name: huddle-facilitation
description: Use to run this project's structured admin meeting format — scaffold the meeting folder and agenda from live state, create talking-point (tp-*) subfolders per topic, and facilitate topic-by-topic resolution across a session that may span many hours or days.
---

# Huddle Facilitation

Confirmed Claude's territory 2026-07-02. Historical continuity: this project ran hands-on
engineering "huddles" early on; as HitM's role shifted to admin-plus-automation, the same
underlying need (structured, multi-topic working sessions) became today's meeting format.
Cursor's old `huddle-facilitation` skill (frontmatter-broken, execution-scoped) is reference
material only, not a copy target — this is written fresh for the admin layer.

## Doctrine

- `governance/coordination/meeting_artifact_protocol.md` — meeting artifact structure.
- `AGENTS.md` / `CLAUDE.md` reading order — for what the meeting needs to be grounded in before
  agenda items get set.

## Loads

- `session-kickoff` (imperative) — orient before scaffolding anything.

## Tools

- `new_meeting_day` — scaffold `strategy/meetings/week<N>/meeting<date>/`.
- `new_tp` — scaffold a `tp-<slug>/` talking-point folder per topic.
- `session_brief` / `workspace_brief` — pull live state to seed the agenda.

## Procedure

1. Load `session-kickoff` first.
2. Scaffold the meeting folder (`new_meeting_day`) if one doesn't already exist for today.
3. Build the agenda from **live state**, not assumption — pull `plan_registry.md`,
   `strategy/anomalies/`, open PRs, and prior meeting exit criteria to determine what's actually
   open, not just what was planned yesterday.
4. For any topic substantial enough to need its own working notes: scaffold a `tp-<slug>/`
   folder (`new_tp`) rather than cramming it into the top-level meeting docs.
5. Facilitate one topic at a time — resolve it (or explicitly park it) before moving to the next.
   Hand off each resolution to `meeting-closeout-bookkeeping` immediately, not batched.
6. Nothing gets committed to git until HitM explicitly says the meeting is finished, regardless
   of how many topics have individually resolved.

## Handoff

Each topic resolution: `Skill(s) to load: meeting-closeout-bookkeeping`. Session end:
`Skill(s) used: huddle-facilitation, meeting-closeout-bookkeeping` (+ whatever topic-specific
skills fired during the session).
