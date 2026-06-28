# Anomaly Log

Observations made by agents while working on a task that fall outside the current scope. Logged here instead of being silently skipped or fixed inline.

## Lifecycle

```
unreviewed  →  dispatched  →  resolved
                          →  wont-fix
```

| Status | Meaning |
|---|---|
| `unreviewed` | Logged by agent, not yet looked at |
| `dispatched` | HitM reviewed; assigned to a scope for investigation |
| `resolved` | Fixed, or confirmed non-issue with explanation |
| `wont-fix` | Acknowledged; not acting; reason noted |

## File naming

```
YYYY-MM-DD_<plan-slug>_<short-desc>.md
```

Examples:
- `2026-06-28_CI-CD-T01_orphaned-container-after-rebuild.md`
- `2026-06-29_F012-support-queue_missing-auth-guard-on-endpoint.md`

## What qualifies as an anomaly

**Log it** if you notice:
- Broken behavior (endpoint errors, failed imports, missing config) in code you're passing through
- Security concern (missing auth guard, exposed credential pattern, unvalidated input path)
- Data integrity risk (migration that seems incomplete, field constraint mismatch)
- Configuration inconsistency (env var referenced but not in `.env.example`, duplicate setting with different values)
- A test that passes but obviously shouldn't based on what you're seeing

**Don't log:**
- Code style or formatting issues
- TODO/FIXME comments (they're already noted inline)
- Things already described in `DECISION_LOG.md` or an existing plan task
- Minor tech debt that's obviously known (commented-out code blocks, debug prints)
- Anything you have scope to fix yourself — fix it, note it in your task output

## Sweep integration

`scripts/gather_doc_context.sh` scans this directory for `status: unreviewed` entries daily. The daily doc sweep prompt triages them and surfaces a dispatch table in the daily summary.
