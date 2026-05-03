---
task_id: T02
status: pending
owner: unassigned
phase: P2
breakpoint: BP_API_D2_BUILD
last_verification: null
---

# T02 — API: X-Client-Build + 409 force-upgrade

## Objective

Implement `X-Client-Build` parsing, write enforcement when `CLIENT_BUILD_MIN_WRITE` (or equivalent settings) is set, and standardized **409** JSON body for force-upgrade per D2 + [`../../pwa-install-offline-sync-research/API_VERSION_AND_CLIENT_WINDOW.md`](../../pwa-install-offline-sync-research/API_VERSION_AND_CLIENT_WINDOW.md).

## Repo scope

- `finance_manager_api/`

## Dependencies

- T01 merged or same PR stack (T02 may follow T01 in one branch).

## Checklist

- [ ] Settings knobs documented in API `README` or deploy env sample (no secrets).
- [ ] Allowlisted mutators return 409 with stable machine-readable shape when build too old.
- [ ] Health or lightweight endpoint exposes server build / min client if required for web version check (align with D4 smoke).
- [ ] Changelog entry.

## Definition of done

- **BP_API_D2_BUILD** PASS.
- Contract matches D2 doc; web team can integrate T03 against staging.

## Verification

- Automated tests for 409 path + acceptable build path.
- Manual: `curl` with/without header against local or staging API.

## Risks

- False positives blocking real users — feature-flag rollout; document bypass for operators only if needed.

## PR expectations

- Web repo may depend on this API PR merging first; document handoff in PR body.
