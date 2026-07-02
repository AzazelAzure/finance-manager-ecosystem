---
name: container-runtime-podman-triage
description: Diagnose and repair container startup, crash loops, and bottlenecks on Linux using Podman-compatible workflows and project scripts. Use when Docker/compose images fail, restart repeatedly, or perform poorly.
---

# Container Runtime Podman Triage

Phase 3 skill — script-first diagnosis before durable fixes.

## Doctrine

- `.cursor/rules/container-testing-orchestration.mdc` — always-applied (cited).
- `governance/deployment/Runtime_Signup_Sheet.md` — single runtime owner.
- `governance/plans/definition_of_done.md`.
- `.cursor/rules/anomaly-log.mdc` → `strategy/anomalies/anomaly_template.md`.

## Loads

None — `container-testing-orchestration.mdc` is always-applied via rules.

## Tools

- `fm_docker_status` — `scripts/local-stack/fm_docker.sh status`
- `local_stack_health` — stack health snapshot
- `scripts/local-stack/fm_docker.sh` / `fm_services.sh` — lifecycle (runtime owner only)

## Procedure

- [ ] Confirm runtime owner on `Runtime_Signup_Sheet.md`; do not lifecycle if not owner.
- [ ] Check status: `fm_docker_status` + `fm_services.sh status` — avoid mixed local/container mode.
- [ ] Reproduce via script-first path (`fm_docker.sh` / `fm_services.sh`), not ad-hoc compose.
- [ ] Collect logs and classify: build | startup | crash loop | performance | networking/config.
- [ ] Apply minimal fix; re-run script-based validation.
- [ ] Record handoff state: runtime mode, last command, status, blockers.
- [ ] Return via `shared-subagent-handoff` with `Skill(s) used: container-runtime-podman-triage`.

## Testing breakpoints (larger plans)

- Breakpoint A: baseline spin-up and smoke
- Breakpoint B: post-fix batch validation
- Breakpoint C: regression sanity pass

Pause new implementation at each breakpoint until runtime validation passes.

## Delegation defaults

- `shell` subagent for command-heavy diagnosis.
- `generalPurpose` for durable config/script fixes.

## Guardrails

- Do not bypass project scripts unless proven broken (report blocker).
- Do not mix local-service and containerized stacks without explicit documentation.
