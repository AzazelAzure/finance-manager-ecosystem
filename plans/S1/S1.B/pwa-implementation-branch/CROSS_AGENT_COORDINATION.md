# Cross-agent coordination — PWA + SEO sprint

**Plan ID:** `PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03`

## File ownership / merge order

| Path | Primary track | Notes |
| ---- | ------------- | ----- |
| `finance_manager_web/index.html` | **Shared** — SEO P0 (T04) + PWA head (manifest link, SW registration script from T05–T07) | **Rule:** Land **T04** early **or** combine T04 + T05 in one web PR with a single editor owning `index.html` for that merge. Avoid parallel PRs both editing `index.html` without rebase coordination. |
| `finance_manager_web/public/*` | T04 (`robots.txt`, `sitemap.xml`), T05 (icons) | Low conflict if icons in `public/` subpaths distinct from new SEO files. |
| `finance_manager_api/**` | T01, T02 | Serialize with web outbox tasks: web T10+ assumes API contract merged or feature-flagged. |

## Parallel lanes

- **Lane API:** T01 → T02 (same repo; can be one PR or two sequential).
- **Lane Web core:** T03 after API build contract usable in dev; T05–T07 sequential.
- **Lane SEO P0:** T04 after **T00**; prefer before T06 changes that heavily touch build pipeline (optional parallelism with T03 if `index.html` coordinated).

## PR notification

- Post PR links in **Cursor chat** (repo, branch, full URL) per `AGENTS.md`. Reconcile **GitHub** mergeability and checks before treating work as merged.

## Handoff format

Delegated agents return: objective, assumptions, files changed, verification status, risks, recommended next action, branch/PR state (per `shared-subagent-handoff` skill).
