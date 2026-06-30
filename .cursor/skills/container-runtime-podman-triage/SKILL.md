---
name: container-runtime-podman-triage
description: Diagnose and repair container startup, crash loops, and bottlenecks on Linux using Podman-compatible workflows and project scripts. Use when Docker/compose images fail, restart repeatedly, or perform poorly.
---

# Container Runtime Podman Triage

## Runtime Assumptions

- Host runtime is Linux.
- Prefer Podman-compatible commands and compose providers.
- Prefer project automation under `scripts/` before ad-hoc container commands.

## Script-First Entry Points

- `scripts/fm_docker.sh` for compose up/down/build/rebuild/status.
- `scripts/fm_services.sh` for non-container service start/stop/status checks.
- `scripts/check_repos.sh` and related git scripts for multi-repo execution context.

## Triage Routine

- [ ] Capture runtime mode, compose provider, and current status.
- [ ] Reproduce failure with script-first command path.
- [ ] Collect logs and crash signatures per service.
- [ ] Classify issue: build failure, startup failure, runtime crash, performance bottleneck, networking/config drift.
- [ ] Apply minimal fix and rerun script-based validation.
- [ ] Document root cause, fix, and prevention steps.

## Runtime Ownership Protocol

- Declare a single runtime owner before any container lifecycle command.
- If not runtime owner, do not run start/stop/rebuild/clean.
- Record owner/sublet state in `governance/Runtime_Signup_Sheet.md`.
- During handoff, include:
  - runtime mode
  - last command executed
  - current status
  - pending test breakpoint
- Prefer runtime subletting and ownership transfer over redundant spin-down/spin-up cycles.

## Testing Breakpoint Protocol

For larger plans, execute in explicit windows:

1. Breakpoint A: baseline spin-up and smoke checks
2. Breakpoint B: post-fix batch validation
3. Breakpoint C: regression sanity pass

At each breakpoint, pause new code edits until runtime validation outcomes are reported.

## Delegation Defaults

- Use `shell` subagent for command-heavy runtime triage.
- Use `generalPurpose` for config/script/code updates needed to fix root causes.
- Use `design-docs-sync` when runtime behavior or operations guidance changes.

## Guardrails

- Do not bypass project scripts unless script path is proven broken.
- Keep fixes reproducible and compatible with Podman-focused Linux flow.
- Avoid one-off manual state changes that cannot be captured in scripts/docs.
- Use `shared-subagent-handoff` when handing results back.
- Do not mix local-service and containerized stacks unless explicitly required and documented.
