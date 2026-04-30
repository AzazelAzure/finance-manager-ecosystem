# Agent launch prompt — web parity sweep #1 (orchestration manager)

Copy everything inside the fence into a new agent task.

```text
You are the orchestration manager for plan:
  plans/feat/web-reflex-parity-sweep-1/

First action (mandatory): read
  .cursor/skills/orchestration-manager/SKILL.md
  plans/feat/web-reflex-parity-sweep-1/README.md
  plans/feat/web-reflex-parity-sweep-1/validation_gates.md
  plans/feat/web-reflex-parity-sweep-1/CROSS_AGENT_COORDINATION.md
  plans/feat/web-reflex-parity-sweep-1/runtime_handoff.md
Then read the task packets in order:
  plans/feat/web-reflex-parity-sweep-1/tasks/T00_plan_freeze.md
  plans/feat/web-reflex-parity-sweep-1/tasks/T01_foundations.md
  ... through T17_polish_hardening.md

You are managing a multi-PR rollout. Each phase produces one PR per repo
touched (web is primary; ecosystem parent gets a submodule-bump PR per phase).
Do NOT proceed past a breakpoint (BP1..BP7) without a PASS recorded in
validation_gates.md.

Routing defaults (per .cursor/rules/agent-delegation.mdc):
- T01..T15 implementation work → feature-implementation-loop (generalPurpose)
- T16 polish → feature-implementation-loop, then code-review-risk-triage
- T17 hardening → ci-test-triage + code-review-risk-triage
- Any blocker → bugfix-investigation-loop
- VPS / container issues → container-runtime-podman-triage
- PR opening / Slack #pull-requests / merge readiness → pr-ops-merge-readiness
- API / docs drift → design-docs-sync (only if behavior changes outside web)

Repo boundaries:
- Primary repo: finance_manager_web/  (branch per phase per README)
- Ecosystem parent: finance_manager/   (submodule bump PR per phase, branch
  feat/web-parity-sweep-1-bump or per-phase variant)
- finance_manager_api/ should NOT be modified in this sweep unless a task
  packet explicitly authorizes it; if you find an API gap, log it under
  CROSS_AGENT_COORDINATION.md "API gaps for sweep #2" — do not implement.

VPS:
  dev@159.198.75.194
  Repo path: /home/dev/finance_manager
  Active color: blue (web-blue, api-blue, reflex-blue serve traffic)
  Compose: podman compose -f docker-compose.bluegreen.yml --env-file
           .secrets/server.env up -d
  jsdev hostnames: https://jsdevtesting.thehivemanager.com  (and api-jsdevtesting for staging API)

Slack:
  Channel #pull-requests — post on every PR open; wait/read for automation
  authorization state; reconcile with GitHub mergeability.

Per-phase merge protocol (user-driven; orchestrator must NOT merge):
  1. Open PR(s) for the phase.
  2. Post to #pull-requests.
  3. Wait for user to merge + pull on VPS + confirm in chat.
  4. User runs manual verification on VPS for that phase's BP gate.
  5. Mark BP gate PASS (or open follow-up via correct skill if FAIL).
  6. Open the next phase.

Hard stop: do not start P2 before BP1 PASS, P3 before BP2, etc.
End-of-sweep: do not declare "sweep #1 complete" until all of:
  - BP1..BP7 PASS in validation_gates.md
  - All phase PRs merged
  - VPS smoke documented in runtime_handoff.md
  - finance_manager_web CHANGELOG.md has an entry per phase
  - User signs off in validation_gates.md "Sweep #1 sign-off"

Begin at T00, then T01.
```

