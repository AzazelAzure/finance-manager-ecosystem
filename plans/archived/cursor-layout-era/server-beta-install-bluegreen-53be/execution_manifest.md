# Execution Manifest

## Plan Root
- `plans/archived/cursor-layout-era/server-beta-install-bluegreen-53be/`

## Intended Branches
- Parent install/ops branch: `cursor/server-beta-install-bluegreen-53be`
- API branch if app changes are required: `cursor/api-server-deploy-readiness-53be`
- Reflex branch if app changes are required: `cursor/reflex-server-deploy-readiness-53be`
- Design docs branch: `cursor/server-beta-deploy-docs-53be`

## Scope Boundary
- Keep implementation PRs scoped per repo.
- Parent repo may own deployment scripts, compose overlays, proxy templates, install package docs, and orchestration wrappers.
- API and Reflex repos own application changes only when deployment requirements expose code/config gaps.
- Runtime/container lifecycle checks must go through the local bridge agent or declared runtime owner.

## Routing
| Task | Primary repo/area | Skill route | Runtime required |
|---|---|---|---|
| `T01_runtime_inventory` | parent/local server runtime | `container-runtime-podman-triage`, `repo-exploration-briefing` | yes |
| `T02_install_package_layout` | parent `scripts/`, `deploy/`, docs | `feature-implementation-loop` | partial |
| `T03_blue_green_runtime` | parent compose/proxy/deploy config | `container-runtime-podman-triage`, `feature-implementation-loop` | yes |
| `T04_redis_session_cache` | parent/API/Reflex/design docs | `repo-exploration-briefing`, `security-audit-hardening` | partial |
| `T05_proxy_cutover_tls` | parent proxy/TLS/deploy config | `container-runtime-podman-triage`, `feature-implementation-loop` | yes |
| `T06_deploy_rollback_scripts` | parent scripts/runtime | `container-runtime-podman-triage`, `feature-implementation-loop` | yes |
| `T07_docs_and_handoff` | `design_docs` | `design-docs-sync` | no |

## Breakpoints
1. **Breakpoint A:** Server/runtime inventory and constraints captured.
2. **Breakpoint B:** Install package and env bootstrap validate on local runtime without destructive actions.
3. **Breakpoint C:** Blue/green compose/proxy design validates with health checks and no mixed runtime.
4. **Breakpoint D:** Deploy/cutover/rollback dry-run succeeds.
5. **Final Gate:** PRs posted to `#pull-requests`; Slack authorization and GitHub mergeability/checks reconciled.

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
