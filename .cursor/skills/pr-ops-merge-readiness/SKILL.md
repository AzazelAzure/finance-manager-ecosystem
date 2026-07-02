---
name: pr-ops-merge-readiness
description: Open PRs, update CHANGELOG, post PR link, and wait for HitM merge authorization — opener side only. Does not merge. Use when preparing commits, opening PRs, or triaging review comments before WS3 merge.
---

# PR Ops Merge Readiness

Phase 4 skill — **opener side only**. Merge is `pr-review-and-merge` (WS3, Phase 5).

## Doctrine

- `deploy/CPPR_AND_CPPRD.md` — CPPRD documentation obligation.
- `.cursor/rules/git-repo-workflow.mdc` — branch/PR/changelog discipline.
- `governance/execution/branching_guidelines.md` §3.2/§3.4.
- `governance/execution/execution_protocols.md` §1.2 (`pre_merge` gate).

## Loads

None. Gate-protocol mechanics inlined below — resolved 2026-07-02, doctrine citation above was
sufficient across all 3 gate-using skills; no separate reference skill needed.

## Tools

- `gh pr create` — open PR via GitHub CLI.
- `pr_readiness` — checks and mergeability before handoff to WS3.
- `ci_status` — pipeline state.
- `branch_delta` — full change scope for PR body.
- `changelog_entry` — CPPRD `[Unreleased]` stub.

## Procedure

- [ ] Confirm feature branch and target repo (`cur/s1b/*`, not `main`).
- [ ] Inspect status/diff/log for full change intent.
- [ ] Update subrepo `CHANGELOG.md` `[Unreleased]` via `changelog_entry`.
- [ ] Push branch; verify remote tracking.
- [ ] Draft PR summary with test plan; open via `gh pr create`.
- [ ] **Post PR link in Cursor chat** (repo, branch, URL) — not Slack.
- [ ] Post `[PR]` / `pre_merge` gate per `execution_protocols.md` §1.2; wait for HitM merge authorization.
- [ ] Run `pr_readiness` and `ci_status` before handoff to WS3.
- [ ] **Do not merge** — hand off to WS3 with `Skill(s) to load: pr-review-and-merge`.
- [ ] Return via `shared-subagent-handoff` with `Skill(s) used: pr-ops-merge-readiness`.

## Handoff to Phase 5

Delegation packet to WS3 must include:

`Skill(s) to load: pr-review-and-merge`

Plus: PR URL, branch, plan ID, validation summary, unresolved risks.

## Guidance

- Small coherent commits; why-oriented messages.
- Do not hide failing checks — surface with next steps.
- If GitHub `CONFLICTING`/`DIRTY`, record blocker and resolve before WS3 handoff.
