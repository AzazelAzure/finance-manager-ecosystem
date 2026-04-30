# T04 — Pre-Governance Plans Formal Close

## Objective

Formally close the seven pre-governance plans that executed during S1.A under prior conventions. Update plan files with final status; ensure registry consistency.

This is paperwork only — code already shipped via those plans during S1.A. The goal is registry hygiene + audit trail.

## Scope Boundary

- Repo: workspace root (`plans/cursor/*` directory edits only)
- Branch: `cursor/s1b/drift-cleanup/t04-pre-governance-plans-close`
- No code changes; no deploy.

## Plans to Close

Per `_governance/plan_registry.md` Recently Completed section (already updated at huddle close-out):

| plan_id | plan_root | Action |
|---|---|---|
| `PLAN_API_REFLEX_BETA_READINESS_2026-04-28` | `plans/cursor/api-reflex-beta-readiness-plan-53be/` | Add closure marker file |
| `PLAN_SERVER_BETA_INSTALL_BLUEGREEN_2026-04-28` | `plans/cursor/server-beta-install-bluegreen-53be/` | Add closure marker file |
| `PLAN_VPS_BETA_ROLLOUT_OPS_2026-04-28` | `plans/cursor/vps-beta-rollout-ops/` | Add closure marker file |
| `PLAN_SECURITY_HARDENING_MIDDLEWARE_ALIGNMENT_2026-04-28` | `plans/cursor/security-hardening-plan-53be/` | Add closure marker file |
| `PLAN_FEAT_DASHBOARD_I18N_CALENDAR_2026-04-28` | `plans/feat/dashboard-transactions-i18n-calendar-month/` | Add closure marker file |
| `PLAN_VPS_REFLEX_BLUEGREEN_RECOVERY_2026-04-29` | `plans/cursor/vps-reflex-bluegreen-recovery-53be/` | Add closure marker file |
| `PLAN_FINANCE_MANAGER_WEB_BETA_ROLLOUT_2026-04-29` | `plans/cursor/finance-manager-web-beta-rollout-53be/` | Add closure marker file |

## Implementation

For each plan, add a `CLOSED.md` file at the plan root with:

```markdown
# Plan Closed

This plan is formally closed as of 2026-04-30 (post-beta huddle Topic 11).

## Final Status

- Status: `completed`
- Phase: S1.A (pre-governance era; mapped to S1.A in the canonical S1–S6 model)
- Outcomes: see `plans/_governance/plan_registry.md` Recently Completed section for strategic impact summary.

## Why This Was a "Pre-Governance" Plan

This plan was authored before the plan governance system at `plans/_governance/` was established. It does not have the YAML metadata header from the canonical `plan_template.md` and was executed under prior conventions. Its outcomes are real and shipped; the close-out is registry hygiene only.

## Reference

Strategic Plan canonical: `plans/cursor/strategic-roadmap-reframe-53be/`.
Closure decision: `plans/volatile/post_beta_huddle_2026-04-30/DECISIONS.md` (Topic 9 close).
```

## Acceptance Criteria

- All seven plans have a `CLOSED.md` file with the above content (adapted per plan_id).
- `plans/_governance/plan_registry.md` is verified consistent (no plans listed `in_progress` that have been closed).
- No code changes; no deploy.

## Verification Commands

```bash
# Verify all closure markers exist
for d in plans/cursor/api-reflex-beta-readiness-plan-53be \
         plans/cursor/server-beta-install-bluegreen-53be \
         plans/cursor/vps-beta-rollout-ops \
         plans/cursor/security-hardening-plan-53be \
         plans/feat/dashboard-transactions-i18n-calendar-month \
         plans/cursor/vps-reflex-bluegreen-recovery-53be \
         plans/cursor/finance-manager-web-beta-rollout-53be; do
  test -f "$d/CLOSED.md" && echo "OK: $d" || echo "MISSING: $d"
done

# Verify registry is consistent
grep -A 2 "## In Progress" plans/_governance/plan_registry.md | head -10
```

## Risks / Rollback

Trivial. If a closure is wrong (plan should still be in_progress), revert the specific `CLOSED.md` and adjust registry.

## Slack Gates

- `pre_execution`: optional (paperwork-only).
- `pre_merge`: required.
- `pre_close`: optional.

## Estimated Effort

30–60 minutes (mostly mechanical — write 7 closure markers; verify registry).
