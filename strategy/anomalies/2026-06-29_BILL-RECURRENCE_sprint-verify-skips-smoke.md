---
logged: 2026-06-29
agent: cursor
plan_context: PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29 / inactive-deploy
status: unreviewed
severity_guess: medium
---

## What was found

`scripts/sprint_verify.sh` was invoked with `--smoke --smoke-color inactive`, but the
remote smoke step never executed. The run log ends with `Rebuild complete for blue.`
followed immediately by `=== sprint_verify complete ===`, with no smoke output. The only
`smoke` occurrence in the 2089-line log is the post-rebuild hint line printed by
`fm_server_beta.sh`. Running `./scripts/fm_server_beta.sh smoke --color blue` directly on
the VPS afterward worked fine and returned `Smoke checks passed for blue`, so smoke itself
is healthy — the gap is that `sprint_verify.sh` silently skipped it.

Likely cause: the `DO_SMOKE` / `SMOKE_TARGET` env vars are passed as prefix assignments on
the `ssh ... bash -s` line (sprint_verify.sh:147-156), and inside the remote heredoc the
`if [[ "$DO_SMOKE" == "1" ]]` guard (line 179) evaluates false — the prefix-assigned vars
are not reaching the heredoc'd `bash -s` environment as expected. Net effect: `--smoke` is
a no-op via this wrapper, so a deploy can report success without ever smoke-testing.

## Where

`scripts/sprint_verify.sh:147-181` — the `ssh ... VAR=... bash -s <<'REMOTE_EOF' ... fi`
block; specifically the `DO_SMOKE`/`SMOKE_TARGET` passthrough vs. the `if [[ "$DO_SMOKE" == "1" ]]`
guard.

## What agent was doing

Deploying the merged bill recurrence engine (API #63/#64/#65, Web #91) to inactive BLUE on
the VPS via `sprint_verify.sh`. Noticed smoke output was missing from the run log, then ran
smoke manually to confirm BLUE was healthy.

## Why outside scope

This deploy task is scoped to shipping the recurrence engine to inactive color, not to
reworking the shared VPS deploy wrapper. `sprint_verify.sh` is cross-cutting deploy tooling
maintained outside this plan; fixing the env passthrough should be its own change with its
own validation.

## Possible owner

Cursor (deploy-tooling pass) / HitM — fix env passthrough so `--smoke` is honored, or have
`sprint_verify.sh` fail loudly when `--smoke` is requested but the smoke step is skipped.

## Notes

Workaround in effect: after any `sprint_verify.sh` run, smoke must be run manually
(`./scripts/fm_server_beta.sh smoke --color <color>`) until the wrapper is fixed. Otherwise
a green "sprint_verify complete" gives false confidence that the color was smoke-verified.
Possible fixes: heredoc-substitute the values in (drop the quotes on `'REMOTE_EOF'` for
those vars), or `export` them in the outer ssh command via `env DO_SMOKE=... bash -s`.
