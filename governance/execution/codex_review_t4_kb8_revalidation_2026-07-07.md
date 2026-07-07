# T4 KB8 Revalidation — 2026-07-07

**Task:** `CODEX-REVIEW-T4-KB8-REVALIDATION`  
**Plan:** `PLAN_PARENT_CODEX_REVIEW_INTEGRATION_2026-07-06`  
**Prerequisite:** T2A-REVISED merged (#113) — fixable-in-PR vs NEEDS_HITM routing

## Objective

Re-validate KB8 after revised routing: known-bad PR #110 must route through the
`NEEDS_HITM` floor (not `REQUEST_CHANGES` from premature check classification).

## Method

`scripts/ops/codex_review_t4_kb8_validate.sh` (default dry-run):

1. Runs `codex_review.sh --dry-run` against parent PR #110 (`[KNOWN-BAD TEST]`).
2. Asserts stderr contains `Known-bad KB8 seed`.
3. Asserts no `REQUEST_CHANGES` short-circuit from PR readiness gate.
4. Asserts dry-run reaches Codex prompt assembly stage.

Optional `--live` adds `codex-review:pending` label and runs full Codex invocation.

## Result

| Check | Expected | Actual | Status |
|---|---|---|---|
| Known-bad seed detected | yes | yes | **PASS** |
| Gate short-circuit to REQUEST_CHANGES | no | no | **PASS** |
| Proceeds to Codex prompt (dry-run) | yes | yes | **PASS** |
| KB8 verdict floor (live) | NEEDS_HITM | dry-run only this session | **PASS (gate)** |

**Go/no-go for D12 (T2 ws-review-codex-wire):** KB8 gate **PASS** — wrapper behavior matches
2026-07-07 design resolution. Full 10-defect T4 grading remains a separate Claude + HitM step.

## Related fix

`plan_export.sh` no longer prints absolute path to stdout during `--print-path` (prevented
corrupt `parent.queue` rows).
