---
logged: YYYY-MM-DD
agent: cursor
plan_context: PLAN_ID / T##
status: unreviewed
severity_guess: low | medium | high
---

## What was found

[Concrete description of the anomaly. What specifically looks wrong? What behavior did you observe or expect to observe?]

## Where

[File path and line number, or system/component. Be as specific as possible.]

`path/to/file.py:42` or `VPS: fm-beta_celery-worker_1 container`

## What agent was doing

[Task and slice context. What were you working on when you found this? This helps the reviewer understand if it's in-scope for an adjacent task or needs a new plan.]

## Why outside scope

[One sentence: why you didn't fix it inline.]

## Possible owner

[Which tool/scope likely owns this — Cursor / Claude Code / HitM / VPS manual / external service]

## Notes

[Anything else useful — a suspicion about root cause, a related file to check, or a pointer to a prior incident.]
