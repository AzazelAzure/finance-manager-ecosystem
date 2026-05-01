# PWA install / offline / sync — research artifacts (this folder)

**Stage:** S1.B research only. **No** `finance_manager_web` or `finance_manager_api` contract is locked until decision gates close and a separate **execution** plan links here.

**Cross-links:** S1.B stage hub + sprint activation table → [`../README.md`](../README.md#pwa-sprint-activation-index); strategic exit bar → [`../../strategic-roadmap-reframe-53be/validation_gates.md`](../../strategic-roadmap-reframe-53be/validation_gates.md) (S1.B bullet); phase detail → [`../../strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md`](../../strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md).

Use this folder as the **single plans-side source** for PWA research until dev work starts; future tactical plans should link these paths instead of duplicating prose.


| Artifact                                                                 | Role                                                                                                                         |
| ------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------- |
| `[README.md](./README.md)`                                               | Sub-plan metadata, D0–D4 gates, verification checklists, §3.1 blue/green + SW, §11 infrastructure lessons, §12 effort bands. |
| `[D0_BROWSER_MATRIX.md](./D0_BROWSER_MATRIX.md)`                         | **D0:** certified vs best-effort browser/install matrix; options A–C; lock in README appendix.                             |
| `[D2_API_OUTBOX_CONTRACT.md](./D2_API_OUTBOX_CONTRACT.md)`               | **D2:** API idempotency, `X-Client-Build`, force-upgrade 409, v1 path allowlist, DELETE semantics.                            |
| `[D3_AUTH_OFFLINE_SESSION.md](./D3_AUTH_OFFLINE_SESSION.md)`             | **D3:** JWT/localStorage, refresh-first replay, logout + outbox, cross-tab, security notes.                                   |
| `[D4_SMOKE_CHECKLIST_AND_ADR.md](./D4_SMOKE_CHECKLIST_AND_ADR.md)`       | **D4:** smoke checklist, ADR stub, D4-exec template, Advanced v1 out-of-scope.                                                |
| `[SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md](./SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md)` | **HitM intent:** ~3mo install seed, offline banners, atomicity + reconciliation.                                      |
| `[API_VERSION_AND_CLIENT_WINDOW.md](./API_VERSION_AND_CLIENT_WINDOW.md)` | Client/API version skew, support windowing, force-upgrade contract, outbox replay rules, Cloudflare note.                    |
| `[RESEARCH_ARTIFACTS.md](./RESEARCH_ARTIFACTS.md)`                       | This index.                                                                                                                  |


**After research close:** copy or summarize stable sections into `design_docs/` and/or `finance_manager_web/` only when implementation CPPRD requires repo-local developer docs.