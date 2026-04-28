# Execution Manifest

## Plan Root
- `plans/cursor/security-hardening-plan-53be/`

## Intended Branches
- Parent/docs plan branch: `cursor/security-hardening-plan-53be`
- API security branch: `cursor/api-security-hardening-53be`
- Reflex token branch, if behavior changes: `cursor/reflex-token-hardening-53be`
- Design docs branch: `cursor/security-posture-docs-53be`
- Rust alignment branch, only if starter repo metadata changes: `cursor/rust-security-contracts-53be`

## Scope Boundary
- Keep implementation commits scoped to one repository at a time.
- Do not combine API, Reflex, Rust, and docs changes in one sub-repo PR.
- Prioritize fixes that make the beta usable without forcing the future Rust/ZK middleware to rebuild the current API surface.

## Routing
| Task | Primary repo/area | Skill route | Runtime required |
|---|---|---|---|
| `T01_api_auth_defaults` | `finance_manager_api` | `security-audit-hardening`, `feature-implementation-loop` | no |
| `T02_secret_hygiene` | `finance_manager_api` | `security-audit-hardening`, `pr-ops-merge-readiness` | no |
| `T03_reflex_token_storage` | `finance_manager_reflex`, API handoff | `security-audit-hardening`, `repo-exploration-briefing` | partial |
| `T04_logging_redaction` | `finance_manager_api` | `security-audit-hardening`, `bugfix-investigation-loop` | partial |
| `T05_middleware_alignment_docs` | `design_docs`, Rust starter repos | `design-docs-sync`, `security-audit-hardening`, `repo-exploration-briefing` | no |

## Breakpoints
1. **Breakpoint A:** Critical/high beta blockers fixed or explicitly accepted with mitigation.
2. **Breakpoint B:** Logging/token handling risk reduced and documented.
3. **Breakpoint C:** Future Rust/ZK integration seams documented without implementing crypto prematurely.
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
