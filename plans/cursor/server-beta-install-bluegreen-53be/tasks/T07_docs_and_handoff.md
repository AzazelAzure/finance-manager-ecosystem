# T07 Docs and Server Handoff

## Objective
Document the final server beta installation workflow, runtime ownership model, and unresolved risks after scripts and runtime configs are implemented.

## Scope Boundary
- Primary repo/path: `design_docs/`
- Related parent artifacts:
  - `plans/cursor/server-beta-install-bluegreen-53be/`
  - deployment scripts/config added during this plan
- Do not rewrite historical status logs; append/update current-state docs.

## Required Docs Updates
- Beta execution/readiness docs should state:
  - install package exists
  - blue/green strategy exists
  - Redis/session decision
  - proxy/TLS assumptions
  - deploy and rollback command names
  - current blockers for real server launch
- Runtime docs should explain:
  - server runtime owner process
  - how to verify active color
  - how to avoid local-vs-container mixed mode
  - how to hand off runtime to the CLI bridge agent

## Acceptance Criteria
- A new operator can read docs and understand:
  - how to install
  - how to configure secrets
  - how to deploy green while blue stays live
  - how to cut over
  - how to roll back
- Docs do not claim zero downtime; they state "minimized downtime" with concrete health/cutover/rollback behavior.
- Docs distinguish server beta from local workstation runtime.

## Verification
```bash
rg -n "server beta|blue|green|rollback|Redis|install" design_docs plans/cursor/server-beta-install-bluegreen-53be
```

## Handoff Output
- Docs changed.
- Commands documented.
- Residual manual server steps.
- Branch/PR status.
