---
name: meeting-closeout-bookkeeping
description: Use throughout an admin meeting session to keep decisions.md, exit_criteria.md, state_snapshot.md, and the meeting README in sync every time a talking point resolves — not batched at the end. Distinct from huddle-facilitation, which runs the meeting itself.
---

# Meeting Closeout Bookkeeping

The mechanical half of running this project's admin meeting format — `huddle-facilitation`
decides what to talk about and in what order; this skill keeps the paper trail current as each
topic actually resolves.

## Doctrine

- `governance/coordination/meeting_artifact_protocol.md` — meeting artifact structure and update expectations.

## Loads

None.

## Tools

- `new_meeting_day` — scaffold (used by `huddle-facilitation`, not this skill directly).

## Procedure

On every talking-point resolution (a `tp-*/` folder reaches a decision, an agenda item closes):

1. Append to `decisions.md` — what was decided, why (the reasoning HitM gave, not just the
   outcome), and any consequence for other open items.
2. Check off the matching line in `exit_criteria.md`, or add one if the resolution surfaced a
   new exit condition that wasn't anticipated at meeting start.
3. Update the relevant section of `state_snapshot.md` if the resolution changes live state
   (a plan's status, a queue dispatch, a VPS drift figure) — don't let the snapshot go stale
   mid-meeting.
4. Update the meeting `README.md`'s agenda list status if a numbered agenda item just closed.

Do this **at the moment each topic resolves**, not batched at the end — batching is how partial
or inaccurate closeout notes happen when a long session runs across many topics.

## Handoff

`Skill(s) used: meeting-closeout-bookkeeping` isn't typically reported externally (this runs
inline during a session Claude is already driving) — its output *is* the updated meeting docs.
