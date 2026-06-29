---
logged: 2026-06-29
agent: cursor
plan_context: PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29 / T04
status: unreviewed
severity_guess: medium
---

## What was found

PR **#76** ("Local security audit T04: anomaly queue integration") shows `state: MERGED`
on GitHub, but its `baseRefName` is `cur/s1b/chore/local-security-audit-t02-audit-script`
(the T02 feature branch) — **not `main`**. Because T02 (#75) had already merged to `main`
before #76 merged, the T04 content (`lib_anomaly_write.sh`, `test_anomaly_integration.sh`,
and the `run_audit.sh` anomaly wiring) was integrated only into the now-defunct T02 branch
and **never reached `main`**.

Net effect: a PR that reads as "merged" in `gh pr list` silently left `main` missing the
feature it claimed to land. `scripts/security/run_audit.sh` on `main` is the T02 version
with no anomaly-queue integration. This was only caught by `git fetch` + comparing
`origin/main` tree contents against the merged PRs (trust-but-verify), not by the PR state.

Re-landed via a corrective PR (**#77**) cherry-picking the two T04 commits onto current
`main`; this anomaly tracks the process gap, not the missing content.

## Where

- GitHub PR #76 — `baseRefName: cur/s1b/chore/local-security-audit-t02-audit-script`,
  `mergeCommit: f877c0c`, `state: MERGED`.
- `origin/main` (`9f5e9bd`) `scripts/security/` — has `check_tools.sh`, `TOOL_VERSIONS`,
  `run_audit.sh` (T02), `.gitleaksignore`, `.semgrepignore`; **missing**
  `lib_anomaly_write.sh` and `test_anomaly_integration.sh`.
- Stale stacked branch still on remote: `cur/s1b/chore/local-security-audit-t02-audit-script`
  at `f877c0c` (holds the #76 merge that never reached `main`).

## What agent was doing

Live verification / closeout of the 2026-06-29 Cursor execution list (Item 2, Local
Security Audit Suite). Fetched all repos and reconciled merged-PR claims against actual
`origin/main` tree contents before reporting completion.

## Why outside scope

The closeout task is status verification + corrective PR creation, not a redesign of the
stacked-PR merge workflow. The systemic hazard (retargeting a stacked PR's base to a
sibling feature branch instead of `main` causes silently-dropped content while still
reading as MERGED) is a process/tooling concern broader than this one suite.

## Possible owner

Cursor / HitM merge discipline — when merging stacked PRs, confirm each PR's base is
`main` (or that the chain ultimately lands on `main`) before trusting "MERGED". Consider a
pre-merge check that fails when a `cur/s1b/*` PR targets another `cur/s1b/*` branch. Relates
to the existing learned preference about squash-merging stacked PRs breaking CHANGELOG
`[Unreleased]` sections.

## Notes

Corrective action already taken: PR **#77**
(`cur/s1b/chore/local-security-audit-t04-to-main`) cherry-picks the T04 commits onto `main`,
diff verified to be exactly the T04 delta with no accidental removal of T01 files. After
#77 merges, delete the stale `...t02-audit-script` and `...t04-anomaly-integration` branches
to prevent re-confusion.
