# Stale PR Report

**Generated:** 2026-06-26 00:21 UTC
**Stale definition:** open PR created at least 7 days ago with no updates in the last 7 days.
**Scope:** all workspace GitHub repos: ecosystem, android, API, CLI, design docs, rust middleware, rust tools, web.
**Baseline evidence:** `gh pr list/view` plus local `git fetch` of `origin/main` and PR refs for stale API/Web PRs.

---

## Executive signal

- **4 stale PRs found**, all in **API** and **Web**.
- **No stale PRs** in ecosystem, android, CLI, design docs, rust middleware, or rust tools.
- All 4 stale PRs are reported by GitHub as **MERGEABLE / CLEAN**, and local `git merge-tree --write-tree origin/main origin/pr/<n>` exited `0`; no direct merge conflicts against current `origin/main` were found.
- Main queue risks are **duplication/order**, not raw conflicts:
  - API #34 includes all API #33 commits plus `7b6f564` (F-013), so #33 is redundant if #34 is the intended merge vehicle.
  - Web #60 and #61 both change `src/offline/profileOutboxOverlay.ts` from `/finance/profile/` to `/finance/appprofile/` and both touch `CHANGELOG.md`.

---

## Repo coverage

| Repo | Open PRs | Stale PRs | Notes |
|---|---:|---:|---|
| `finance-manager-ecosystem` | 1 | 0 | Fresh PR #63 updated 2026-06-26. |
| `finance-manager-andriod` | 0 | 0 | No open PRs. |
| `finance-manager-api` | 3 | 2 | Stale #33/#34; fresh #35 updated 2026-06-26. |
| `finance-manager-cli` | 0 | 0 | No open PRs. |
| `finance-manager-design-docs` | 0 | 0 | No open PRs. |
| `finance-manager-rust-middleware` | 0 | 0 | No open PRs. |
| `finance-manager-rust-tools` | 0 | 0 | No open PRs. |
| `finance-manager-web` | 3 | 2 | Stale #60/#61; fresh #62 updated 2026-06-26. |

---

## Stale PRs by repo

### `finance-manager-api`

#### #33 — `feat(infra): F-012 Support intake backend implementation`

- **URL:** https://github.com/AzazelAzure/finance-manager-api/pull/33
- **Branch:** `agy/s1b/feat/infra-support-intake` -> `main`
- **Age / quiet:** ~9d 20h old; no update for ~9d 15h (`updatedAt` 2026-06-16 08:55 UTC).
- **Evidence from commits/files:** commits `277228a` (F-012 backend), `f6911a` (support fixes), `2e27df9` (CHANGELOG); 22 files including support serializers/views/tasks/tests, Celery settings, `pyproject.toml`, `uv.lock`.
- **Against current main:** GitHub `MERGEABLE` / `CLEAN`; local merge-tree against API `origin/main` (`113fc05`) exited `0`; PR branch contains current `origin/main`.
- **Issues:** No approving reviews; only neutral Cursor automation checks. API #33 is an ancestor of API #34, so merging #34 makes #33 redundant.

#### #34 — `agy/s1b/feat/infra user activity logs`

- **URL:** https://github.com/AzazelAzure/finance-manager-api/pull/34
- **Branch:** `agy/s1b/feat/infra-user-activity-logs` -> `main`
- **Age / quiet:** ~9d 10h old; no update for ~9d 10h (`updatedAt` 2026-06-16 13:58 UTC).
- **Evidence from commits/files:** includes all #33 commits plus `7b6f564` (`feat(infra): F-013 Per-User Diagnostic Logs backend implementation`); 26 files including `finance/utils/incident_extractor.py`, support log tests, simulator/adversarial tests, logging config, support views.
- **Against current main:** GitHub `MERGEABLE` / `CLEAN`; local merge-tree against API `origin/main` (`113fc05`) exited `0`; PR branch contains current `origin/main`.
- **Issues:** No approving reviews; only neutral Cursor automation checks. This is the broader API infra PR; decide whether it supersedes #33 before merging either.

### `finance-manager-web`

#### #60 — `fix(offline): correct appprofile regex and add transaction outbox overlay tests`

- **URL:** https://github.com/AzazelAzure/finance-manager-web/pull/60
- **Branch:** `agy/s1b/fix/pwa-profile-regex` -> `main`
- **Age / quiet:** ~10d 1h old; no update for ~10d 1h (`updatedAt` 2026-06-15 23:00 UTC).
- **Evidence from commits/files:** commits `8a13a00` (offline regex/test fix), `b8de85c` (CHANGELOG); files `CHANGELOG.md`, `src/offline/profileOutboxOverlay.ts`, `src/offline/transactionOutboxOverlay.test.ts`.
- **Against current main:** GitHub `MERGEABLE` / `CLEAN`; local merge-tree against Web `origin/main` (`c855791`) exited `0`; PR branch contains current `origin/main`.
- **Issues:** No reviews and no status checks. Overlaps with Web #61 on `CHANGELOG.md` and the same `profileOutboxOverlay.ts` regex change.

#### #61 — `feat(infra): F-012 Support intake frontend implementation`

- **URL:** https://github.com/AzazelAzure/finance-manager-web/pull/61
- **Branch:** `agy/s1b/feat/infra-support-intake` -> `main`
- **Age / quiet:** ~9d 20h old; no update for ~9d 15h (`updatedAt` 2026-06-16 08:55 UTC).
- **Evidence from commits/files:** commits `9b2ecbe` (F-012 frontend), `0525b12`/`092186f` (remove diagnostic log key from forms/schema), `e66c2bb` (CHANGELOG); 9 files including `SupportPage.tsx`, `DashboardPage.tsx`, `i18n.ts`, `ProtectedShell.tsx`, `TourProvider.tsx`.
- **Against current main:** GitHub `MERGEABLE` / `CLEAN`; local merge-tree against Web `origin/main` (`c855791`) exited `0`; PR branch contains current `origin/main`.
- **Issues:** No reviews and no status checks. Duplicates Web #60's `profileOutboxOverlay.ts` path correction; cross-merge with #60 is clean locally, but merge order should account for duplicate changelog/regex edits.

---

## Theme clusters

### F-012 / F-013 support infrastructure

- API #33 implements F-012 backend support intake.
- API #34 stacks F-013 per-user diagnostics on top of #33.
- Web #61 implements F-012 frontend support intake.
- Signal: merge vehicle/order needs a decision; conflicts are not the blocker.

### PWA/offline profile overlay fix

- Web #60 is the narrow app profile regex/test PR.
- Web #61 carries the same `profileOutboxOverlay.ts` regex correction as part of broader support-intake UI work.
- Signal: avoid merging duplicate intent without confirming which PR owns the offline fix and changelog entry.

---

## Non-stale open PRs observed

- Ecosystem #63 — `docs(strategy): standby queue closeout status` — updated 2026-06-26.
- API #35 — `security(api): Argon2, axes lockout, password complexity` — updated 2026-06-26; review decision `CHANGES_REQUESTED`.
- Web #62 — `fix(web): CSP, dashboard header cleanup, F-012 build lineage` — updated 2026-06-26.

---

*Sources: `gh pr list/view --json`, stale PR commit/file metadata, local `git fetch origin refs/heads/main:refs/remotes/origin/main refs/pull/<n>/head:refs/remotes/origin/pr/<n>`, `git merge-tree --write-tree`, branch ancestry checks, and local PR diff file overlap checks.*
