# Changelog — finance-manager-ecosystem (parent)

Notable changes to this **parent** repository: submodule pins, `plans/`, `deploy/`, and cross-cutting docs. Product changelogs live in each component repository.

## [Unreleased]

### 2026-05-01 — Plans archive, governance hygiene, design_docs CPPRD (ecosystem)

- **Plans:** Moved legacy top-level `plans/feat/`, `plans/fix/`, `plans/volatile/`, and `plans/volatile_standby/` under `plans/archived/`; refreshed cross-references; corrected post-beta huddle and PH Android archive paths; `plans/_governance/README.md`, `plan_registry.md`, and `glossary.md` updated for hierarchical layout and archive index row; strategic plan README stage line and `00_strategic_context.md` broken-path fix.
- **Cursor skills:** `huddle-facilitation` and `roadmap-rollout-planning` aligned with `plans/cursor/<phase-stage>/<sub-plan>/` and archived volatile conventions.
- **Submodules:** `design_docs` pinned to `7c9a57e` on branch `cursor/strategic-doc-sync-2026-05-01` (vault strategic alignment, `design_docs/CHANGELOG.md`, **resolved** strategic-doc conflict set: PH-first `07_Server_Runtime_and_Scaling.md` §2, web-first golden rule / phase triggers, `20_Roadmap/_historical/` for calendar + orchestration_manager packs).

### 2026-05-01 — Plans, deploy runbook, submodule sync

- **Plans:** S1.B drift-cleanup and strategic roadmap README/context updates; T04/T06 task note refresh; governance branching doc table and list formatting.
- **Deploy:** `deploy/BLUEGREEN_SWITCHOVER.md` — Podman `depends_on` / proxy ordering when recycling inactive `api-*` / `web-*` after image rebuilds; API `--no-cache` rebuild caveat.
- **Submodules:** Pinned `finance_manager_api`, `finance_manager_web`, and `finance_manager_reflex` to current `origin/main` after merged beta work (email uniqueness, web onboarding, Reflex archival record). `design_docs` bumped to `main` including design-docs PR [#12](https://github.com/AzazelAzure/finance-manager-design-docs/pull/12) (runtime validation, deployment strategy, triage cross-refs).
