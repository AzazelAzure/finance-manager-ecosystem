# Changelog — finance-manager-ecosystem (parent)

Notable changes to this **parent** repository: submodule pins, `plans/`, `deploy/`, and cross-cutting docs. Product changelogs live in each component repository.

## [Unreleased]

### 2026-05-01 — Plans, deploy runbook, submodule sync

- **Plans:** S1.B drift-cleanup and strategic roadmap README/context updates; T04/T06 task note refresh; governance branching doc table and list formatting.
- **Deploy:** `deploy/BLUEGREEN_SWITCHOVER.md` — Podman `depends_on` / proxy ordering when recycling inactive `api-*` / `web-*` after image rebuilds; API `--no-cache` rebuild caveat.
- **Submodules:** Pinned `finance_manager_api`, `finance_manager_web`, and `finance_manager_reflex` to current `origin/main` after merged beta work (email uniqueness, web onboarding, Reflex archival record). `design_docs` bumped to `main` including design-docs PR [#12](https://github.com/AzazelAzure/finance-manager-design-docs/pull/12) (runtime validation, deployment strategy, triage cross-refs).
