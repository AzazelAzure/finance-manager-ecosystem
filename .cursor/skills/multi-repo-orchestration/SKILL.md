---
name: multi-repo-orchestration
description: Coordinate tasks that span API, Web (flagship SPA), and CLI repositories while preserving repo boundaries and explicit handoffs. Use when changes require cross-repo sequencing, dependency notes, or staged execution across multiple subprojects.
---

# Multi-Repo Orchestration

## When to Use

Use this skill when a request affects two or more repos:

- `finance_manager_api/`
- `finance_manager_web/`
- `finance_manager_cli/`
- (optional / archived) `finance_manager_reflex/`

## Orchestration Routine

- [ ] Identify initiating repo and final user-visible outcome.
- [ ] Split work into per-repo deliverables (one intent per repo), and when a governed plan exists, align slices to **`T##.SL#`** per `governance/plan_template.md` §1a (one surface per slice where possible).
- [ ] Define dependency order (upstream contract first, consumers second).
- [ ] Ensure each touched repo uses its own feature branch.
- [ ] For each repo: implement, verify, and record handoff.
- [ ] Open/link per-repo PRs where shared history merge is expected.
- [ ] For each opened PR, post to `#pull-requests` with repo/branch/PR URL.
- [ ] Pause and read `#pull-requests` for automation final state (`approved`, `merged`, `changes_requested`, `blocked`).
- [ ] Reconcile Slack authorization with live GitHub PR mergeability/check state before merge.
- [ ] Capture unresolved cross-repo dependencies as explicit follow-up items.

## Delegation Defaults

- Use `explore` subagent to map cross-repo impact quickly.
- Use `generalPurpose` for repo-specific implementation.
- Use `shell` for repo-scoped git/gh operations.

## Guardrails

- Never stage or commit across repos in one step.
- Keep each repo's changelog update with that repo's behavior changes.
- Keep PR links/check status explicit in cross-repo handoffs.
- Use `#pull-requests` automation replies as authoritative cross-agent PR coordination state, with GitHub as mergeability source of truth.
- If blocked in repo N, stop downstream repo work and publish handoff.
- Use `shared-subagent-handoff` for all repo-to-repo transitions.
