# Execution Manifest

## Plan Root
- `plans/archived/cursor-layout-era/api-reflex-beta-readiness-plan-53be/`

## Intended Branches
- Parent/docs/plan branch: `cursor/api-reflex-beta-readiness-plan-53be`
- API implementation branch: `cursor/api-beta-hardening-53be`
- Reflex implementation branch, only if needed: `cursor/reflex-beta-smoke-fixes-53be`
- Bridge/runtime script branch, only if needed in parent repo: `cursor/cli-bridge-runtime-refinement-53be`

## Scope Boundary
- Keep implementation commits scoped to one repository at a time.
- Do not commit API, Reflex, and parent script changes in the same repository commit.
- Use the local CLI bridge agent for runtime/container checks that are unavailable in cloud.

## Routing
| Task | Primary repo/area | Skill route | Runtime required |
|---|---|---|---|
| `T04_cli_bridge_reply_refinement` | parent `scripts/` if present on local runtime | `container-runtime-podman-triage`, `feature-implementation-loop` | yes, local |
| `T01_api_production_settings` | `finance_manager_api` | `feature-implementation-loop` | partial |
| `T02_api_test_triage` | `finance_manager_api` | `ci-test-triage`, `bugfix-investigation-loop` | partial |
| `T03_reflex_runtime_smoke` | `finance_manager_reflex` | `container-runtime-podman-triage`, `repo-exploration-briefing` | yes, local |
| `T05_beta_readiness_docs_sync` | `design_docs` / parent plan docs | `design-docs-sync`, `pr-ops-merge-readiness` | no |

## Breakpoints
1. **Breakpoint A:** CLI bridge replies in concise chunks and reports container status without mixed runtime.
2. **Breakpoint B:** API production config and targeted test fixes validated.
3. **Breakpoint C:** Reflex + proxy runtime smoke validated through local bridge.
4. **Final Gate:** PRs posted to `#pull-requests`; Slack authorization and GitHub mergeability/checks reconciled.

## Handoff Contract
Every worker result must use:

```markdown
## Objective
## Assumptions and Unknowns
## Evidence
## Files
## Risks
## Verification
## Branch/PR Status
## Next Action
```

