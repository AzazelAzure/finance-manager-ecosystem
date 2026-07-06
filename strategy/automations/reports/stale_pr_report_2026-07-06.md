# Stale PR Report — 2026-07-06

**Captured (UTC):** 2026-07-06T01:00:31Z  
**Stale threshold:** last activity ≥7 days ago (`updatedAt` before 2026-06-29T01:00:31Z)  
**Repos scanned:** 8 (parent ecosystem + 7 sub-repos per `scripts/repos.txt` + `finance-manager-design-docs`)

---

## Summary

| Metric | Count |
|---|---|
| Open PRs (all repos) | 2 |
| **Stale PRs (7+ days, no updates)** | **0** |
| Repos with stale PRs | 0 |

**Headline:** No stale pull requests. The open queue is two parent-repo security-audit fixes opened minutes before this scan.

---

## Stale PRs by repo

### finance-manager-ecosystem

*None.*

### finance-manager-api

*None.*

### finance-manager-web

*None.*

### finance-manager-design-docs

*None.*

### finance-manager-cli

*None.*

### finance-manager-andriod

*None.*

### finance-manager-rust-tools

*None.*

### finance-manager-rust-middleware

*None.*

---

## Active open PRs (not stale — for queue awareness)

Both are from `PLAN_CROSS_SECURITY_AUDIT_FIXES_2026-07-02`; merge in task order (T01 before T05).

### finance-manager-ecosystem

| PR | Title | Age | Last update | vs `main` | Issues |
|---|---|---|---|---|---|
| [#96](https://github.com/AzazelAzure/finance-manager-ecosystem/pull/96) | Parent: fix security audit suite (T01 — bandit + env poisoning) | ~4 min | 2026-07-06T00:57:33Z | ahead 1 / behind 0 | **MERGEABLE**, `mergeStateStatus: CLEAN`. Security Reviewer check NEUTRAL. No human reviews. `CHANGELOG.md` touched — rebase sibling #97 `[Unreleased]` after squash-merge per CPPR discipline. |
| [#97](https://github.com/AzazelAzure/finance-manager-ecosystem/pull/97) | Parent: harden inactive rebuild + sprint_verify path (T05) | ~4 min | 2026-07-06T00:57:35Z | ahead 1 / behind 0 | **MERGEABLE**, `mergeStateStatus: CLEAN`. Security Reviewer check NEUTRAL. No human reviews. Both PRs edit `CHANGELOG.md` — merge #96 first, then sync #97 `[Unreleased]` before merging. |

**Theme:** Parent-repo ops hardening (security audit tooling + inactive-color rebuild safety). No API/Web/CLI surface changes.

---

## Recently cleared (context)

Heavy merge activity through 2026-07-02 cleared prior queues:

- **API:** F-006 dashboard layout (#85), F-009 auto_deduct (#84), security CVE batch (#83) — all closed 2026-07-02.
- **Web:** F-006 dashboard widgets T02–T04 (#110–#112), F-009 auto-deduct (#108–#109) — all closed 2026-07-02.
- **Parent:** skill-generation + governance reorg (#95) closed 2026-07-02.

No evidence of PRs sitting open ≥7 days without updates at capture time.

---

## Method

```bash
gh pr list --repo AzazelAzure/<repo> --state open --json number,title,createdAt,updatedAt,...
gh api repos/AzazelAzure/finance-manager-ecosystem/compare/main...<branch>
```

Stale = `updatedAt` < cutoff (7 days before capture). Merge/conflict checks via GitHub API `compare` + PR `mergeable` / `mergeStateStatus`.
