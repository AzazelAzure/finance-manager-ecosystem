# F-004 Runtime Handoff

**Plan:** `PLAN_CROSS_STS_BILL_REALISM_F004_2026-05-05`  
**Agent:** Cursor — `cur/s1b/feat/f004-sts-pay-cycles-bill-realism`  
**Updated:** 2026-06-28

## Active task

T01–T06 implementation and VPS deploy complete. Runtime ownership released after green promotion.

## Branch map

| Repo | Branch | Task | PR |
|------|--------|------|-----|
| API | `.../t01-pay-cycle-profile` | T01 | https://github.com/AzazelAzure/finance-manager-api/pull/52 |
| API | `.../t02-bill-realism-schema` | T02 | https://github.com/AzazelAzure/finance-manager-api/pull/53 |
| API | `.../t03-api-serializers` | T03 | https://github.com/AzazelAzure/finance-manager-api/pull/54 |
| API | `.../t04-sts-pay-window-engine` | T04 | https://github.com/AzazelAzure/finance-manager-api/pull/55 |
| Web | `.../t05-web-bill-editor` | T05 | https://github.com/AzazelAzure/finance-manager-web/pull/81 |
| Web | `.../t06-web-sts-upcoming-views` | T06 | https://github.com/AzazelAzure/finance-manager-web/pull/82 (base: T05 branch) |
| Web | `.../f004-t06-web-sts-upcoming-views-remerge` | T06 recovery | https://github.com/AzazelAzure/finance-manager-web/pull/83 |

## Completed

- Plan tasks T01–T06 authored
- T01–T04 merged to API `main`
- T05 merged to Web `main`
- T06 recovery PR #83 merged to Web `main` after original stacked PR #82 landed on the T05 branch
- Local validation passed before deploy: API F-004 tests, Web build, Web Vitest
- VPS deploy complete: pulled API/Web `main`, rebuilt inactive green, smoked green, switched active color blue -> green
- Post-switch checks passed: `smoke --color green`, public web 200, public API health 200
- DB migrations applied on VPS: `0011_tos_acceptance_fields`, `0012_appprofile_pay_cycle_fields`, `0013_upcomingexpense_bill_realism_fields`

## Blockers

- None

## Next

1. Monitor active green after deploy
2. Roll back to blue with `./scripts/fm_server_beta.sh rollback` if a production blocker appears
