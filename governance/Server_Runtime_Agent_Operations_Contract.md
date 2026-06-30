# Server Runtime Agent Operations Contract

## Purpose

Define how cloud-planned work is executed on live/staging runtime hosts without requiring direct cloud-agent SSH into production infrastructure.

This contract separates:

- **Control plane** (planning/orchestration, PR decisions)
- **Execution plane** (server-local runner performing approved runtime actions)

## Operating model

| Plane | Role | Location |
|------|------|----------|
| Control plane | Plans work, approves deploy intent, tracks PR/readiness gates | Cloud agents + human operators |
| Execution plane | Executes scripted runtime actions, reports evidence | Server-local runtime agent |

## Core principles

1. **Pull execution from server-local agent**
   - Runtime hosts execute commands locally based on approved tasks.
   - Do not treat direct cloud-agent SSH as primary operations path.
2. **Script-first execution**
   - Use project scripts (`scripts/fm_server_beta.sh`, `scripts/server/*`). (updated 2026-06-30)
   - Avoid ad-hoc runtime commands unless incident response requires it.
3. **Artifact-based deployments**
   - Deploy tested runtime bundles from development/staging workflows.
   - Verify `RELEASE_MANIFEST.txt` on host before startup/cutover.
4. **Least privilege + auditability**
   - Restrict runtime agent to deployment directories and required service commands.
   - Persist command/result logs and manifest identity for each deploy window.
5. **No-downtime intent**
   - Validate inactive color before cutover.
   - Keep rollback path deterministic and rehearsed.

## Runtime command policy

### Allowed
- `scripts/server/create_runtime_bundle.sh` (build release artifact from approved commit state)
- `scripts/server/push_runtime_bundle.sh` (upload/extract runtime artifact to VPS target path)
- `scripts/server/verify_release_manifest.sh`
- `scripts/server/install_prereqs.sh`
- `scripts/server/bootstrap_env.sh --validate-only`
- `scripts/fm_server_beta.sh {status,start,stop,restart,rebuild}` (updated 2026-06-30)
- `scripts/fm_server_beta.sh {status,check,deploy,smoke,switch,rollback,logs}`

### Disallowed by default
- Arbitrary shell execution unrelated to deploy/runtime checks.
- Destructive data operations without explicit approved runbook step.
- Secret material echoing or copying into chat channels.

## Approval gates

Before runtime execution:
- Plan/task packet exists under `plans/<Phase>/<Stage>/<sub-plan>/` (active) or a documented path under `plans/archived/` (read-only evidence), and is listed or cross-linked from `governance/plan_registry.md` when the work is governed.
- Scope and target repo/runtime are explicit.
- Required environment and manifest are present.
- If bundle workflow is used, the pushed artifact identity (`bundle_name`, commit SHA, dirty flag) is recorded in task evidence.

Before production cutover:
- Inactive color smoke passes.
- Core user flows smoke pass.
- Rollback command verified in current runtime context.
- Human/operator approval recorded in coordination channel/thread.

## Incident and rollback protocol

1. Classify incident:
   - implementation defect
   - contract mismatch
   - runtime/test instability
   - missing context/ownership
2. Stop forward changes.
3. Execute rollback (`fm_server_beta.sh rollback` or prior runbook step).
4. Record:
   - manifest identity
   - timestamp
   - failing check
   - rollback result
5. Open follow-up task packet before next cutover attempt.

## Coordination channels

- `#cli-interface`: task intake and execution progress.
- `#pull-requests`: PR state + mergeability reconciliation.
- Runtime execution should post concise evidence links/snippets, not raw secret-bearing logs.

## Deferred enhancements

- Dedicated dev-host to inactive-color routing lane (for example `dev.<domain>` -> inactive color) after baseline VPS stability.
- Optional access controls for dev-host lane (allowlist/basic auth).
