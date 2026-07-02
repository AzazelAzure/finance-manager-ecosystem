---
name: pr-review-and-merge
description: WS3-scoped PR review and merge gate — full TBV pass, security audit, DoD and Golden Rules compliance before merge. Use only when reviewing and merging PRs opened by another agent. Never opens PRs or pushes feature code.
disable-model-invocation: true
---

# PR Review and Merge

Phase 5 skill — distinct role from PR opener (`pr-ops-merge-readiness`). WS3 executes via
`ws_review.sh`; never opens PRs or pushes feature code.

## Doctrine

- `governance/execution/workspace_protocol.md` §2 — WS3 role.
- `governance/plans/definition_of_done.md`.
- `design_docs/00_Coding_Guidelines.md` — Golden Rules.
- `governance/execution/execution_protocols.md` §1.2 (`pre_merge` gate).

## Loads (imperative — mandatory first actions)

1. **First, read** `.cursor/skills/trust-but-verify/SKILL.md` and run a full TBV pass on all
   claims that gate this merge decision.
2. **Then, read** `.cursor/skills/security-audit-hardening/SKILL.md` and confirm audit passes
   before merge.

## Tools

- `ws_review` — WS3 PR review workflow (`action`: auto, approve, reject).
- `gh pr merge` — merge only after all gates pass.
- `pr_readiness` — merge conflicts, checks, mergeability.

## Procedure

1. Confirm delegation packet includes `Skill(s) to load: pr-review-and-merge`.
2. Run imperative loads (TBV, then security audit) — do not skip.
3. Confirm `pr_readiness` shows no merge conflicts and required checks are satisfied.
4. Confirm Golden Rules compliance on the diff (`design_docs/00_Coding_Guidelines.md`).
5. Confirm Definition of Done compliance for the plan task/slice.
6. Reconcile `pre_merge` gate state per `execution_protocols.md` §1.2.
7. Merge via `ws_review.sh` / `gh pr merge` only when all above pass.
8. **Never** open PRs or push feature code in this skill.

## Handoff

Return via `shared-subagent-handoff` with:

`Skill(s) used: pr-review-and-merge, trust-but-verify, security-audit-hardening`

On failure/block, hand off per `execution_protocols.md` §2.3 `[HANDOFF: failure]` with
`Skill(s) to load` naming the Phase-3 skill that must re-engage.
