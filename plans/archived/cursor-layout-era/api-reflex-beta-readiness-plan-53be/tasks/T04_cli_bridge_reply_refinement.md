# T04 CLI Bridge Reply Refinement

## Objective
Make the local Slack bridge reliable enough for cloud agents to request runtime checks and receive complete, parseable handoffs.

## Scope Boundary
- Repo/path: parent workspace runner files if present on the target machine, especially `scripts/cursor_headless_slack_agent.py`.
- Coordination channel: `#cli-interface`.
- Do not change API or Reflex application behavior in this task.

## Background Evidence
- `!cursor` prefix-only control ping succeeded.
- Model/usage forwarding is controlled by `CURSOR_AGENT_EXTRA_ARGS`, for example:
  `["--approve-mcps","--model","composer-2-fast"]`.
- A long runtime-status response was clipped after `scripts/fm_docker.sh status`.
- Threaded follow-up retasks did not reliably produce another agent reply during the stress test.

## Requested Change
Refine the bridge runner and/or its operating prompt so runtime responses are short, chunked, and follow-up friendly.

## Implementation Notes
- Prefer deterministic output constraints over relying on the model to stay concise.
- If implementation is in `scripts/cursor_headless_slack_agent.py`, consider:
  - maximum Slack message chunk size below Slack/MCP clipping risk, e.g. 2000-2500 characters
  - automatic splitting of long agent output into numbered thread replies
  - preserving code blocks only when they fit in a chunk
  - logging full raw output locally while posting concise summaries to Slack
  - making threaded task detection explicit if currently only top-level prefix tasks are handled
- Keep model selection as env-driven unless product constraints require another mechanism:
  - `CURSOR_AGENT_EXTRA_ARGS='["--approve-mcps","--model","composer-2-fast"]'`

## Acceptance Criteria
- A short control task receives a reply.
- A deliberately long output is split into multiple readable thread replies instead of clipped.
- A follow-up task in the original thread is either handled or explicitly documented as unsupported.
- Bridge docs are updated if the command surface or thread behavior changes.

## Verification Commands / Checks
Use `#cli-interface`:

```text
!cursor
REPO: finance_manager_api
WORKSPACE_PATH: /home/pproctor/Documents/python/finance_manager
RUNTIME: local
TASK: |
  Reply with exactly three numbered chunks, each under 1000 characters, proving chunk handling works.
```

Then run the API + Reflex runtime task from `T03_reflex_runtime_smoke.md` and confirm no clipped report.

## Risks / Rollback
- Slack spam risk: cap chunks and include a summary first.
- Thread detection may vary by Slack event shape; keep top-level tasking supported even if threaded tasking remains a follow-up.

## Required Handoff
Use the shared handoff format:
- Objective
- Assumptions and Unknowns
- Evidence
- Files reviewed/changed
- Risks
- Verification
- Branch/PR Status
- Next Action
