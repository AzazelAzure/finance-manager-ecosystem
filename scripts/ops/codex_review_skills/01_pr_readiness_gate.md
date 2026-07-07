# Skill: pr-readiness-gate
Use when: every review (KB8 revised routing)

Blocking findings:
- (none from this skill alone — routes verdict)

Warnings:
- PENDING checks noted in SUMMARY; do not APPROVE until resolved

Evidence required:
- scripts/dev/pr_readiness.sh output
- mergeable / mergeStateStatus from PR metadata

Route to NEEDS_HITM when:
- Infra/deploy/smoke/external check FAILED
- CANCELLED or TIMED_OUT checks
- BLOCKED merge state not fixable by author rebase alone

Route to REQUEST_CHANGES when:
- Test/lint/build/typecheck/ci check FAILED (fixable in PR)
- CONFLICTING / DIRTY merge state (rebase fixable)

Output notes:
- Code-test failures must not become NEEDS_HITM
