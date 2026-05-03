---
task_id: T11
status: pending
owner: unassigned
phase: P10
breakpoint: BP_D3_AUTH
last_verification: null
---

# T11 — D3 auth: refresh-first drain, logout confirm, cross-tab

## Objective

Implement [`../../pwa-install-offline-sync-research/D3_AUTH_OFFLINE_SESSION.md`](../../pwa-install-offline-sync-research/D3_AUTH_OFFLINE_SESSION.md): queue when refresh exists or access valid; **refresh-first** then outbox drain on **main thread**; **Auth blocked** if no refresh; **logout** with non-empty outbox requires confirm (**Sync now** / **Discard** / **Cancel**); cross-tab `AUTH_CHANGED_EVENT`.

## Repo scope

- `finance_manager_web/`

## Dependencies

- T10 outbox drain hooks.

## Checklist

- [ ] Refresh token flow integrated with replay (no silent drain on invalid session).
- [ ] Logout modal/confirm when outbox non-empty.
- [ ] Cross-tab: pause or coordinate drain on auth change.
- [ ] Copy distinguishes network vs auth blocked.

## Definition of done

- **BP_D3_AUTH** PASS.

## Verification

- Manual matrix: offline writes → token refresh path → drain; logout with pending items; two tabs.

## Risks

- Race on token rotation — serialize refresh + drain per D3.

## PR expectations

- Web PR; link D3 doc in PR description.
