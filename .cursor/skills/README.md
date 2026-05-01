# Skills and Delegation Map

This project uses shared skills in `.cursor/skills/` plus delegation rules in `.cursor/rules/agent-delegation.mdc`.

## Guideline Alignment Matrix

- `core-standards.mdc` -> global quality defaults; every workflow skill inherits correctness-first, root-cause fixes, and maintainability.
- `git-repo-workflow.mdc` -> repo boundaries, feature-branch + PR defaults, and changelog discipline; all execution-oriented skills include explicit repo/branch confirmation.
- `api-architecture.mdc` -> backend layering constraints; referenced by `feature-implementation-loop` and `bugfix-investigation-loop` when working in API paths.
- `reflex-frontend.mdc` -> **legacy** Reflex paths only (archived product). For active UI work, follow `finance_manager_web/` conventions and `feature-implementation-loop` / `bugfix-investigation-loop` in that repo.
- `agent-delegation.mdc` -> task classification, routing defaults, handoff contract, and verification expectations.

## Task Routing Defaults

- Code review -> `code-review-risk-triage` -> subagent: `generalPurpose` (or `explore` for readonly triage).
- Bug investigation/fix -> `bugfix-investigation-loop` -> subagent: `generalPurpose`.
- Feature/refactor implementation -> `feature-implementation-loop` -> subagent: `generalPurpose`.
- Test/CI failures -> `ci-test-triage` -> subagent: `shell` for command-heavy diagnosis, then `generalPurpose` for code edits.
- PR merge-readiness and hygiene -> `pr-ops-merge-readiness` -> subagent: `shell` for git/gh workflows.
- Codebase exploration and context briefs -> `repo-exploration-briefing` -> subagent: `explore`.
- Cross-repo dependency execution -> `multi-repo-orchestration` -> subagent sequence: `explore` then `generalPurpose` by repo.
- Design documentation updates -> `design-docs-sync` -> subagent sequence: `explore` doc targeting then `generalPurpose`.
- Roadmap/feature rollout planning -> `roadmap-rollout-planning` -> subagent sequence: `explore` then `generalPurpose`.
- Container/runtime failure triage -> `container-runtime-podman-triage` -> subagent sequence: `shell` (diagnose with scripts) then `generalPurpose` (durable fix).
- Plan execution coordination -> `orchestration-manager` -> subagent sequence: `generalPurpose` coordinator delegating to specialized workflow skills.
- Security review and hardening -> `security-audit-hardening` -> subagent sequence: `explore` (surface map) then `generalPurpose`/`shell` (fix and verify).

## New Workflow Notes

- Multi-repo routine enforces repo-by-repo sequencing and explicit cross-repo handoffs.
- Git workflow defaults are branch-first with PR/check/signoff merge gates (no direct feature work on `main`/`master`).
- PR coordination is Slack-first: announce PRs in `#pull-requests`, wait/read automation authorization, then reconcile with GitHub mergeability/check state before merge.
- Any Slack-vs-GitHub mismatch (for example Slack approved but GitHub `CONFLICTING`/`DIRTY`) is treated as a blocker until resolved.
- Documentation routine keeps `design_docs` aligned with behavioral, architectural, and rollout changes.
- Planning routine standardizes phases, breakpoints, triggers, dependencies, and validation gates.
- Container routine standardizes Linux Podman-first script workflows for image/runtime failures and crash-loop bottlenecks.
- Container orchestration rule enforces single runtime owner and mandatory testing breakpoints in larger plans.
- Orchestration manager enforces plan-driven delegation, retasking on failures, and final readiness gates before declaring complete.
- Security routine enforces severity-based findings, exploitability prioritization, and verification before release readiness.

## Shared Handoff Contract

Every delegated workflow should return this structure:

1. Objective and scope boundary
2. Assumptions and unknowns
3. Evidence gathered (commands/searches/tests)
4. Files touched or candidate files
5. Risks/regressions
6. Verification status
7. Next action recommendation
