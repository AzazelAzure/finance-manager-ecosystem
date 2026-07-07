# Skill: context-integrity-preflight
Use when: every review invocation (before applying lenses)

Blocking findings:
- Missing or empty diff when PR has file changes
- plan_id in body but plan_lookup returned not-found
- pr_readiness collection failed entirely

Warnings:
- Submodule context missing on parent submodule-bump PR
- Plan context truncated or stale vs export hash

Evidence required:
- PR metadata JSON, diff, pr_readiness output, plan_lookup output
- SKILLS_LOADED list from wrapper

Route to NEEDS_HITM when:
- Any required injected context is absent and cannot be inferred safely
- Wrapper reports skill file missing

Output notes:
- Set CONTEXT_LOADED fields to no for each missing slice
- Do not APPROVE on partial context
