---
name: anomaly-registration
description: Session-start reminder of the anomaly-logging habit — log scope drift, contradictory tool output, and governance/state mismatches in the moment they are noticed. Distinct from Claude's anomaly-scoping-and-dispatch, which triages after suspicion.
---

# Anomaly Registration (Cursor instance)

Cross-cutting doctrine skill, duplicate per agent. Lighter than
`anomaly-scoping-and-dispatch` — reinforces the habit at session start so mid-execution
anomalies get filed promptly, not reconstructed at cleanup.

## Doctrine

- `.cursor/rules/anomaly-log.mdc` — always-applied rule (cited, not migrated).
- `strategy/anomalies/anomaly_template.md` — filing format.

## Loads

None — intentionally minimal for every-session load.

## Tools

- `anomaly_new` — scaffold a new anomaly file when a trigger fires.

## Trigger list — log it now

- A task reveals scope beyond its stated boundary.
- A tool's output contradicts a registry or status claim.
- A governance doc's stated state doesn't match observed repo/runtime reality.
- A check reports success or "0 findings" when underlying execution looks broken or skipped.

## Procedure

1. Load at session start alongside `session-orientation`.
2. Keep trigger list as active background awareness through the session.
3. The moment a trigger fires: file via `anomaly_new` and `anomaly_template.md` — do not defer to session end.
4. Do not fix anomalous code inline; the anomaly log is the only output for out-of-scope findings.

## Handoff

`Skill(s) used: anomaly-registration` when reporting that a trigger fired and an anomaly was filed.
