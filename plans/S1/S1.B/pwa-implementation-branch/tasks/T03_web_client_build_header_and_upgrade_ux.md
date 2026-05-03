---
task_id: T03
status: pending
owner: unassigned
phase: P3
breakpoint: BP_WEB_BUILD
last_verification: null
---

# T03 — Web: client build header + force-upgrade UX

## Objective

Send **`X-Client-Build`** on mutating requests from the SPA build pipeline; handle **409** responses with clear user action (reload / hard refresh) per API contract.

## Repo scope

- `finance_manager_web/`

## Dependencies

- T02 available in dev/staging (or mock 409 until API lands).

## Checklist

- [ ] Inject build id at build time (Vite `define` or env pattern consistent with repo).
- [ ] Centralize fetch/axios interceptor (or equivalent) for mutating methods.
- [ ] User-visible upgrade prompt; avoid infinite retry loops on 409.
- [ ] Coordinate `index.html` edits with T04/T05 per `CROSS_AGENT_COORDINATION.md`.

## Definition of done

- **BP_WEB_BUILD** PASS.
- `npm run build` + `npm run lint` green.

## Verification

```bash
cd finance_manager_web && npm run build && npm run lint
```

## Risks

- Dev vs prod build id — document local behavior when header missing.

## PR expectations

- Branch `cursor/s1b/pwa-implementation-branch`; PR to `main`; link in Cursor chat.
