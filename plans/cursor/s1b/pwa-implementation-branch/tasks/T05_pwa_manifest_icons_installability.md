---
task_id: T05
status: pending
owner: unassigned
phase: P4
breakpoint: BP_MIN_PWA
last_verification: null
---

# T05 — PWA manifest + icons + installability

## Objective

Meet **manifest** and **install** production checklist items per [`../../pwa-install-offline-sync-research/README.md`](../../pwa-install-offline-sync-research/README.md) §6: `name`, `short_name`, `start_url`, `display` standalone-compatible, icons **192** and **512**, HTTPS-safe.

## Repo scope

- `finance_manager_web/` (`public/manifest.webmanifest` or Vite convention, icons, `index.html` link)

## Dependencies

- T03/T04 coordination for `index.html`.

## Checklist

- [ ] Web app manifest valid JSON; linked from document.
- [ ] Icons 192×192 and 512×512 (maskable if recommended by audit).
- [ ] Chrome **Install** / Android **Add to Home screen** succeeds; launches standalone.
- [ ] Certified testing on **Chrome desktop + Chrome Android** only for exit claims.

## Definition of done

- **BP_MIN_PWA** PASS.

## Verification

- Manual on real devices + `npm run build`.
- Lighthouse PWA category spot-check (informational).

## Risks

- Wrong `start_url` breaking deep links — align with router base.

## PR expectations

- Web repo PR; screenshot evidence in PR optional.
