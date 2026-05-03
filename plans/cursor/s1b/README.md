# Stage S1.B — Distribution Readiness

**Stage-level dashboard** per hierarchical plan structure (locked huddle 2026-04-30 Topic 11 Q11.3).

## Stage metadata

- **Phase:** S1
- **Stage:** S1.B (Distribution Readiness)
- **Strategic link:** `plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md` (Stage S1.B section + Appendix A)
- **Status:** active 2026-04-30 → estimated July 2026
- **Entry triggers:** S1.A exit met (✅); Strategic Plan revision complete (✅ huddle output); Topic 8 velocity controls operational
- **Exit triggers:** see `plans/cursor/strategic-roadmap-reframe-53be/validation_gates.md` Phase S1 Stage S1.B

## Sub-plan index

Sub-plans under this Stage. Each follows the canonical Execution Plan template (`plans/_governance/plan_template.md`) with hierarchical metadata.


| Sub-plan                             | Status      | Owner                                 | Dependencies                                                     | Notes                                                                                                                                                                                                                                                                                          |
| ------------------------------------ | ----------- | ------------------------------------- | ---------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `drift-cleanup/`                     | `completed` | HitM (confirmed 2026-05-01)           | none                                                             | W1 drift scope delivered; reconcile plan_registry / validation_gates checkboxes if any remain open.                                                                                                                                                                                            |
| `entity-formation-research/`         | `draft`     | unassigned (HitM-led decisions)       | none                                                             | **Hub:** [`entity-formation-research/README.md`](./entity-formation-research/README.md) (**§0.2** pipeline lock, **§0.4** counsel tail — **not** a PWA blocker; **before** PSP go-live). **US LLC prep:** [`US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md`](./entity-formation-research/US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md). **Artifacts:** [`RESEARCH_ARTIFACTS.md`](./entity-formation-research/RESEARCH_ARTIFACTS.md). |
| `payment-provider-research/`         | `draft`     | unassigned (HitM-led decisions)       | `entity-formation-research` (entity choice constrains options)   | **Locks:** [`payment-provider-research/DECISION_MATRIX.md`](./payment-provider-research/DECISION_MATRIX.md) **PM1–PM5**. Stripe vs PayMongo vs Xendit vs hybrid; mobile-wallet primary path; [`PSP_COMPARISON_MATRIX.md`](./payment-provider-research/PSP_COMPARISON_MATRIX.md).                                                                                                                                                                                                                            |
| `ai-economics-deep-dive/`            | `shelved`   | unassigned (HitM-led)                 | `**entity-formation-research`**, `**payment-provider-research**` | Appendix A remainder **paused** 2026-05-01 until PSP + entity path; **§2.0 price/credit locks** already in `01_unit_economics_and_costs.md`.                                                                                                                                                   |
| `distribution-channel-research/`     | `draft`     | unassigned (HitM-led decisions)       | none                                                             | PH-local channels (FB primary, AI video framing, family/friend WOM seed).                                                                                                                                                                                                                      |
| `wedge-consistency-audit/`           | `draft`     | unassigned                            | landing polish underway                                          | ~1 hour slip-in audit per huddle Topic 7 Q7.3.                                                                                                                                                                                                                                                 |
| `pwa-install-offline-sync-research/` | `draft`     | unassigned (HitM-led decisions + web) | none; informs W3 and W6 vocabulary                               | **Decision + rationale hub:** [`pwa-install-offline-sync-research/README.md`](./pwa-install-offline-sync-research/README.md) §**1.1–1.7** (tier, D2 API, D3 auth, D4 smoke/ADR, **3mo seed + offline banners + atomicity**), §**6** production bar; **[`RESEARCH_ARTIFACTS.md`](./pwa-install-offline-sync-research/RESEARCH_ARTIFACTS.md)**; **D4-exec** on `:8443`; S1.B exit bullet in [`validation_gates.md`](../strategic-roadmap-reframe-53be/validation_gates.md). Sprint index: [below](#pwa-sprint-activation-index). |


## Branch naming convention

Per `plans/_governance/branching_guidelines.md`:

- Sub-plan branch: `cursor/s1b/<sub-plan-name>` (e.g. `cursor/s1b/drift-cleanup`)
- Feature branch on inactive color: `cursor/s1b/feat/<feature-name>` (e.g. `cursor/s1b/feat/email-uniqueness-fix`)
- Task branch under feature: `cursor/s1b/feat/<feature-name>/t<NN>-<slug>`

## Sequencing

Per huddle Topic 9 group ordering:

```
Group A (immediate, ~3 days):  drift-cleanup small items + monthly audit *(drift plan **completed** 2026-05-01)*
Group B (S1.B early):          drift-cleanup major items *(same — hygiene only if registry lags)*
Group C (S1.B research):       entity → payment → **resume `ai-economics-deep-dive`** (shelved 2026-05-01 until those two land) → distribution → wedge audit; **PWA install/offline** may parallel late-C once D0 closed (pre-Android win)
Group D (S1.B features):       sequential after C; per-feature color cycle; **PWA implementation** lands here after `pwa-install-offline-sync-research` D1–D2 lock unless timeboxed to research-only
Group E (parallel low-pri):    time-clock agent; huddle skill; hotfix workflow
Group F (S1.C entry prep):     founding member backend; pricing page; ToS
```

See `plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md` Stage S1.B Workstreams W1–W6 for full detail.

## Pricing and tiering (sequencing note)

**After** the S1.B feature roadmap (Group D scope) is solidified, run a dedicated pass: **Free vs Pro vs Pro+ AI entitlements**, then lock list prices and gate math with `01_unit_economics_and_costs.md` §2 + §4.1. **Pro free trial** and **wallet trial / charge-failure** behavior are parked as `**PARKING_LOT.md` P-8** until then.

## Personal constraint reminders (HitM)

- Pre-baby velocity full through ~mid-June 2026; baby due 2026-06-15. Front-load deep-focus research (**entity**, **payments**) into May–early June; `**ai-economics-deep-dive` shelved** until those complete, then close Appendix A.
- 10hr/day, 55hr/week ceiling during Sprints; 6hr/day, 30hr/week during Decompression.
- ₱100/mo runtime cost cap; Cursor cap as forcing function (no overages).
- First quarterly self-review 2026-06-30.

### External research (Gemini / Antigravity)

Read **[`GEMINI_RESEARCH_README.md`](./GEMINI_RESEARCH_README.md)** before adding or editing S1.B research so folder boundaries, HitM-only locks, and CPPRD hygiene match this workspace.

## Cross-references

<a id="pwa-sprint-activation-index"></a>

### Sprint activation index — PWA (install, offline, resync)

Use this block when the **flagship web Advanced PWA** implementation sprint is activated (after research locks; Group D sequencing per **Sequencing** above).

| Read first | Why |
| ---------- | --- |
| [`strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md`](../strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md) | **W2** PWA research line, **W3** “worth paying for” order vs PWA, **W6** Android sync vocabulary alignment. |
| [`strategic-roadmap-reframe-53be/validation_gates.md`](../strategic-roadmap-reframe-53be/validation_gates.md) (S1.B exit) | Authoritative **install-as-app** exit bullet; ties to sub-plan **completed** + **D0–D4** + **D4-exec**. |
| [`pwa-install-offline-sync-research/README.md`](./pwa-install-offline-sync-research/README.md) | **§1.1–§1.7** decision log + rationale; **§6** checklist; links to **D0 / D2 / D3 / D4 / seeding / API version** specs. |
| [`pwa-install-offline-sync-research/RESEARCH_ARTIFACTS.md`](./pwa-install-offline-sync-research/RESEARCH_ARTIFACTS.md) | One-page index of all PWA research files. |
| [`_governance/plan_registry.md`](../_governance/plan_registry.md) | Portfolio row `PLAN_RESEARCH_PWA_INSTALL_OFFLINE_SYNC_2026-05-01` (status handoff). |

Deep specs (from sub-plan README §3 + §1.7): [`D0_BROWSER_MATRIX.md`](./pwa-install-offline-sync-research/D0_BROWSER_MATRIX.md), [`D2_API_OUTBOX_CONTRACT.md`](./pwa-install-offline-sync-research/D2_API_OUTBOX_CONTRACT.md), [`D3_AUTH_OFFLINE_SESSION.md`](./pwa-install-offline-sync-research/D3_AUTH_OFFLINE_SESSION.md), [`D4_SMOKE_CHECKLIST_AND_ADR.md`](./pwa-install-offline-sync-research/D4_SMOKE_CHECKLIST_AND_ADR.md), [`SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md`](./pwa-install-offline-sync-research/SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md), [`API_VERSION_AND_CLIENT_WINDOW.md`](./pwa-install-offline-sync-research/API_VERSION_AND_CLIENT_WINDOW.md).

- Strategic context: `plans/cursor/strategic-roadmap-reframe-53be/00_strategic_context.md`
- Unit economics: `plans/cursor/strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md`
- Validation gates: `plans/cursor/strategic-roadmap-reframe-53be/validation_gates.md`
- Parking lot: `plans/cursor/strategic-roadmap-reframe-53be/PARKING_LOT.md`
- Branching workflow: `plans/_governance/branching_guidelines.md`
- Plan template: `plans/_governance/plan_template.md`
- Plan registry: `plans/_governance/plan_registry.md`

## Stage exit criteria summary (full detail in `validation_gates.md`)

- All sub-plans `completed`.
- Email uniqueness S0 fix shipped; +Bill hotfix in git; Reflex archival complete.
- Bug fixes for Issues #1, #4, #7 shipped.
- Entity, payment provider, AI economics decisions made.
- Distribution channel research complete; founder content cadence defined.
- Wedge consistency audit complete; landing-page polish landed.
- Founding member program backend ready.
- "Worth paying for" feature work complete (Pro tier demonstrably worth ₱200/mo).
- ToS + Privacy + Refund policies live.
- Android pulled forward to `android:Alpha` minimum.
- Flagship **PWA install-as-app** production bar met ([`pwa-install-offline-sync-research/README.md`](./pwa-install-offline-sync-research/README.md) **§6** + **D4-exec**); sub-plan **completed** with **D0–D4** and rationale (**§1.1–§1.7**). **Where to start coding:** [Sprint activation index — PWA](#pwa-sprint-activation-index) (this file).

When all of the above are met → S1.B → S1.C transition; deferred decisions resolved per huddle Topic 4 (US re-engagement Phase placement, AI tier final commitment). **S1.C entry still requires S1.B exit in full** — the PWA bar is part of S1.B exit, so “progress to S1.C” is blocked until install-as-app criteria pass.