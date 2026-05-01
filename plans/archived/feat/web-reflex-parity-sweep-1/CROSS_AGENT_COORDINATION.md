# Cross-agent coordination — web parity sweep #1

Sibling plans this sweep depends on or touches:

| Plan | What we expect from it |
|------|------------------------|
| [`cursor/finance-manager-web-beta-rollout-53be`](../../cursor/finance-manager-web-beta-rollout-53be/README.md) | Foundation for the web app deployment story (Docker, proxy, jsdev hostnames, CORS). This sweep **builds on** that infrastructure; it does not replace it. |
| [`cursor/vps-reflex-bluegreen-recovery-53be`](../../cursor/vps-reflex-bluegreen-recovery-53be/README.md) | VPS blue/green ownership for the API/Reflex/proxy stack. This sweep ships **`web-blue` / `web-green`** images alongside; respect runtime ownership. |

## Repo boundary policy (this sweep)

- **finance_manager_web**: open. Every phase commits + PRs here.
- **finance_manager (ecosystem parent)**: submodule pointer bump only, one PR
  per phase.
- **finance_manager_api**: **DO NOT** modify in this sweep. If a missing /
  broken endpoint is discovered, log it below in **API gaps for sweep #2**.
- **finance_manager_reflex**: **DO NOT** modify. The Reflex app stays as the
  visual + behavioral reference for parity.

## Runtime ownership

- VPS container restarts: confirm with [Runtime Signup
  Sheet](../../../design_docs/30_Releases/Runtime_Signup_Sheet.md) before
  rebuilding `web-blue` / `web-green`. The blue/green sibling agent may be the
  active runtime owner; coordinate before any `podman compose ... up -d
  --build`.
- Local dev: each engineer's own machine; no coordination required.

## Slack `#pull-requests`

Per `.cursor/rules/git-repo-workflow.mdc`:
- Post on every PR open: repo, branch, PR URL.
- Wait/read for automation final state (`approved`, `merged`,
  `changes_requested`, `blocked`) before merge.
- Reconcile Slack with GitHub mergeability; Slack `approved` does not override
  GitHub `CONFLICTING` / `DIRTY`.

## API gaps for sweep #2 (DO NOT FIX HERE — log only)

_(append dated lines as the orchestrator/feature agents discover gaps; sweep #2
opens an API PR if needed)_

- _example:_ `2026-04-29: GET /finance/upcoming_expenses/?currency_code=…`
  documented in OpenAPI but not forwarded by view; affects Bills page filter
  parity.

## Last cross-repo changes (this sweep)

| Date | Repo | Change | PR |
|------|------|--------|----|
| 2026-04-29 | finance_manager (ecosystem) | Plan freeze: `plans/archived/feat/web-reflex-parity-sweep-1/` | https://github.com/AzazelAzure/finance-manager-ecosystem/pull/20 |

_(append on every PR open)_
