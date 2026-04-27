---
name: pr-ops-merge-readiness
description: Keep pull requests merge-ready with commit hygiene, clear summaries, and unresolved-risk tracking. Use when preparing commits, opening PRs, triaging review comments, or validating merge readiness.
---

# PR Ops Merge Readiness

## Workflow Checklist

- [ ] Confirm current branch and target repo boundary.
- [ ] Confirm work is on a feature branch (not `main`/`master`).
- [ ] Inspect status/diff/log to understand full change intent.
- [ ] Validate commit grouping and message quality.
- [ ] Push branch and verify remote tracking state.
- [ ] Ensure changelog/docs updates match behavior changes.
- [ ] Draft PR summary with concise test plan.
- [ ] Open/update PR and record URL/status.
- [ ] Post Slack message to `#pull-requests` announcing PR open (`repo`, `branch`, `PR URL`).
- [ ] Wait/read `#pull-requests` for automation authorization state (`approved`, `merged`, `changes_requested`, `blocked`).
- [ ] Reconcile Slack authorization with live GitHub PR state before merge.
- [ ] If Slack approval conflicts with GitHub mergeability (`CONFLICTING`/`DIRTY`), record blocker and resolve conflicts first.
- [ ] Confirm required checks and signoffs/approvals state.
- [ ] List unresolved risks/blockers explicitly.

## Guidance

- Prefer small, coherent commits.
- Include why-oriented commit/PR messaging, not only what changed.
- Do not hide failing checks; surface them with next steps.
- Do not merge while required checks/signoffs are pending or failing.
- Use Slack `#pull-requests` automation replies as the PR lifecycle coordination signal.
- Resume paused PR workflows when Slack reaches final authorization state and GitHub gate conditions are satisfied.
- Use `shared-subagent-handoff` for final readiness report.
