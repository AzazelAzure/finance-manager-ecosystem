---
name: dependabot-batch-triage
description: Triage open Dependabot PR batches for api/web using dependabot_batch MCP, classify risk, and route merges through WS3. Use when multiple Dependabot PRs are open or pip-audit/uv lock updates need batch handling.
---

# Dependabot Batch Triage

Phase 3/4 cross-cutting skill — complements `ci-test-triage` (single failure) with
**batch** dependency-update workflows.

## Doctrine

- `.cursor/rules/git-repo-workflow.mdc` — one PR per logical change; Dependabot PRs are pre-opened.
- `deploy/CPPR_AND_CPPRD.md` — changelog only when merging agent-opened fixes, not raw Dependabot merges.

## Loads

- `security-audit-hardening` — when a Dependabot bump touches auth, crypto, or secret-handling deps.

## Tools

- `dependabot_batch` — list open Dependabot PRs (`api`, `web`, or `all`).
- `branch_delta` — scope a single PR before merge decision.
- `ci_status` / `pr_readiness` — check state per PR.
- `test_api` / `test_web` — targeted regression after risky bumps.
- `review_push` + `ws_review` — enqueue WS3 after any agent-opened fix PR (not for direct Dependabot merges).

## Procedure

1. Run `dependabot_batch` (default `all`) — capture the open PR table.
2. **Classify each PR:**
   - *Low risk:* patch/minor tooling, dev-only, or lockfile-only with green CI → candidate for WS3 batch merge.
   - *Medium:* runtime dep minor bump → read `branch_delta` or `gh pr diff`; run targeted `test_*`.
   - *High:* major version, security-sensitive crate/lib, or CI red → hold; load `security-audit-hardening` if exploit surface changes.
3. **Never** loop `gh pr view`/`gh pr diff` manually when MCP/script covers it — one `dependabot_batch` call first.
4. For merges: hand off to WS3 with `Skill(s) to load: pr-review-and-merge` per PR (or `ws_review.sh --next` if enqueued).
5. If a Dependabot PR needs a companion fix (lock conflict, test patch), open a **separate** agent PR — do not patch on the Dependabot branch.
6. Return via `shared-subagent-handoff` with disposition table: merged / deferred / needs-fix PR links.

## Handoff

`Skill(s) used: dependabot-batch-triage` plus per-PR disposition. WS3 merges only after `pr_readiness` green.

## Guidance

- Prefer merging Dependabot PRs in dependency-order (transitive base libs first) when batches are large.
- Do not batch multiple unrelated agent fixes into one PR to "clear the queue."
