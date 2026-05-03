---
task_id: T13
status: pending
owner: unassigned
phase: P12
breakpoint: BP_BG_PWA
last_verification: null
---

# T13 — Blue/green + installed PWA operator smoke notes

## Objective

Document and execute operator-focused checks: production **origin** SW scope vs **jsdevtesting** separate origin; post-`switch` installed PWA still updates; smoke steps align with [`../../pwa-install-offline-sync-research/README.md`](../../pwa-install-offline-sync-research/README.md) §3.1 and `deploy/BLUEGREEN_SWITCHOVER.md`.

## Repo scope

- `deploy/` or `finance_manager_web/docs/` — short runbook addition (minimal)
- Optional: append rows to `runtime_handoff.md`

## Dependencies

- T06–T07 in place.

## Checklist

- [ ] Checklist section: inactive color validation hostnames vs prod install origin.
- [ ] Post-switch: confirm SW update + app loads (Chrome certified).
- [ ] Note cookie/session boundary between staging and prod.

## Definition of done

- **BP_BG_PWA** PASS.

## Verification

- Operator walkthrough on VPS or documented dry-run with HitM signoff.

## Risks

- Confusing testers with wrong hostname — bold warnings in doc.

## PR expectations

- Docs-only PR acceptable; or append to existing ops doc PR.
