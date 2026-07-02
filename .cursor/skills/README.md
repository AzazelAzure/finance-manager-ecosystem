# Cursor Skills — Deploy Lifecycle Map

Ground-up rebuild per `strategy/meetings/week27/meeting2026-07-02/tp-skill-generation/cursor_skill_rebuild_spec.md` (2026-07-02). Governing architecture: `skill_architecture.md`.

Delegation routing also lives in `.cursor/rules/agent-delegation.mdc` (always-applied). Skills cite always-applied rules as doctrine — they are not migrated into skills.

## Skill taxonomy in this directory

| Type | Skills |
|---|---|
| Session doctrine (load at start) | `session-orientation`, `anomaly-registration`, `trust-but-verify`, `skill-gap-detection` |
| Phase / workflow | See phase table below |
| Handoff contract | `shared-subagent-handoff` |
| Out-of-lifecycle (kept) | `huddle-facilitation` |

## Phase routing (execution order for deploy cycle)

```text
session-orientation
  → pickup-and-claim (Phase 2)
  → Phase 3 implementation skill
  → pr-ops-merge-readiness (Phase 4 — open PR)
  → pr-review-and-merge (Phase 5 — WS3 merge)
  → deploy-execution (Phase 6a/6b — inactive deploy + smoke)
  → [HitM V3 verify] → [Claude/HFM cutover] → [Claude close]
```

## Phase table

| Phase | Skill | Notes |
|---|---|---|
| 0 | `session-orientation` | Branch prefix, `ws_status`, reading order pointer |
| 1 feeder | `functional-investigation-report` | T00-style facts for design gates |
| 2 | `pickup-and-claim` | `ws_claim`, `pre_execution` gate |
| 3 | `feature-implementation-loop` | Default implementation |
| 3 | `bugfix-investigation-loop` | Bugs/regressions |
| 3 | `ci-test-triage` | CI/test failures |
| 3 | `code-review-risk-triage` | Pre-PR self-review |
| 3 | `container-runtime-podman-triage` | Script-first runtime |
| 3 | `repo-exploration-briefing` | Unknown-ownership mapping |
| 4 | `pr-ops-merge-readiness` | Opener only — does not merge |
| 5 | `pr-review-and-merge` | WS3; loads TBV + security audit; `disable-model-invocation` |
| 6a/6b | `deploy-execution` | Inactive deploy + smoke; no cutover; `disable-model-invocation` |
| — | `orchestration-manager` | Coordinator across phases and repos (incl. parent `HFM/`) |
| — | `security-audit-hardening` | Loaded imperatively at merge gate |
| — | `shared-subagent-handoff` | Return contract with `Skill(s) used` |

## Handoff fields (required)

1. Delegation packets: **`Skill(s) to load: <name(s)`**
2. Return contracts: **`Skill(s) used: <name(s)`**

## Retired skills (removed in rebuild)

- `multi-repo-orchestration` — absorbed into `orchestration-manager` (parent repo scope fixed).
- `design-docs-sync` — deferred to Gemini.
- `roadmap-rollout-planning` — Claude `design-first-gate` owns plan authoring.

## MCP tools (common across Phase 3–6)

Prefer `hfm-scripts` MCP: `session_brief`, `ws_status`, `ws_claim`, `pr_readiness`, `ci_status`, `test_api`/`test_web`/`test_rust`, `local_stack_health`, `fm_docker_status`, `changelog_entry`, `vps_state`, `ws_review`. See `scripts/mcp/README.md`.

## Always-applied rules (cited, not skills)

`core-standards`, `git-repo-workflow`, `scripts-orientation`, `container-testing-orchestration`, `anomaly-log`, `agent-delegation`.
