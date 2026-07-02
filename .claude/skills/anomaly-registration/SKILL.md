---
name: anomaly-registration
description: Use at session start as a standing reminder of the anomaly-logging habit itself — load before diving into admin work so anomalies get caught and logged in the moment they're noticed, not retroactively reconstructed. Distinct from anomaly-scoping-and-dispatch, which handles triage after something is already suspected.
---

# Anomaly Registration (Claude instance)

Cross-cutting doctrine skill, duplicate per agent (HitM, 2026-07-02: "the idea is that skills are
loaded in when an agent starts, so it further reinforces this particular governance protocol
even further, so things are caught more frequently"). Deliberately lighter than
`anomaly-scoping-and-dispatch` — this is reinforcement of the habit, not the triage/dispatch
procedure. Mildly redundant with that skill by design; the redundancy is the point (a passive
rule in a governance file gets re-read far less often than a skill loaded at session start).

## Doctrine

- `strategy/anomalies/anomaly_template.md`.

## Loads

None — this is intentionally minimal so it's cheap to load every session.

## Tools

None directly — hands off to `anomaly-scoping-and-dispatch` for actual filing.

## Trigger list — log it now, don't wait

- A status claim (registry, tool output, a report's narrative) contradicts what direct
  observation shows.
- A task reveals scope beyond its own stated boundary.
- A governance doc's stated current state doesn't match what's actually on disk / in the repo.
- A tool that's supposed to fail loudly on error instead reports success with no findings, and
  that "no findings" result seems too clean to be believed.

## Procedure

1. Load at session start alongside `session-kickoff`.
2. Keep the trigger list above active background awareness through the session — don't defer
   "is this worth logging" to session end, when detail and context have degraded.
3. The moment a trigger fires: stop and hand off to `anomaly-scoping-and-dispatch` immediately,
   rather than making a mental note to come back to it.

## Handoff

`Skill(s) to load: anomaly-scoping-and-dispatch` the moment a trigger fires. This skill itself
doesn't file anything — it's the reason filing happens promptly instead of at cleanup time.
