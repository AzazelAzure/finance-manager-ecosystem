# Inactive Blue Polish — jsdevtesting Checklist (2026-06-29)

Use **jsdevtesting.thehivemanager.com** (inactive blue) after PR merges and redeploy.  
**Do not flip** until all items below pass.

## Merge order

| Order | Repo | PR | Branch |
|-------|------|-----|--------|
| 1 | API | [#66](https://github.com/AzazelAzure/finance-manager-api/pull/66) | `cur/s1b/fix/share-link-disable` |
| 2 | Web | [#92](https://github.com/AzazelAzure/finance-manager-web/pull/92) | `cur/s1b/fix/share-ui-remove` |
| 3 | Parent | [#81](https://github.com/AzazelAzure/finance-manager-ecosystem/pull/81) | `cur/s1b/chore/share-link-rca` |
| 4 | Web | [#93](https://github.com/AzazelAzure/finance-manager-web/pull/93) | `cur/s1b/feat/dashboard-nav-polish` |
| 5 | Web | [#94](https://github.com/AzazelAzure/finance-manager-web/pull/94) | `cur/s1b/feat/datahub-profile-restructure` (after #92) |
| 6 | Web | [#95](https://github.com/AzazelAzure/finance-manager-web/pull/95) | `cur/s1b/feat/guide-walkthrough-expansion` (after #94) |

Also open from earlier today (if not merged): parent [#79](https://github.com/AzazelAzure/finance-manager-ecosystem/pull/79), [#80](https://github.com/AzazelAzure/finance-manager-ecosystem/pull/80), design_docs [#21](https://github.com/AzazelAzure/finance-manager-design-docs/pull/21).

## Redeploy inactive blue (after API + Web merges)

```bash
./scripts/sprint_verify.sh \
  --color blue --branch main --repos api,web \
  --smoke --smoke-color inactive \
  --evidence /tmp/fm_sprint_evidence

# sprint_verify --smoke is currently a no-op — run manually:
ssh dev@159.198.75.194 'cd ~/finance_manager && ./scripts/fm_server_beta.sh smoke --color blue'
```

Confirm migration `0018_revoke_export_share_tokens` applied on blue API.

## Security (Theme 1)

- [ ] Data Hub has **no** Share Data card
- [ ] Profile → Data tab has export only (CSV + full backup)
- [ ] `GET /finance/export/share/{any-uuid}/` returns **404** on origin
- [ ] RCA readable: `strategy/audits/2026-06-29_share-link-exposure_rca.md`

## Bill recurrence (prior deploy)

- [ ] Cadence UI: weekly, biweekly, **semimonthly** (1st/15th), monthly, custom
- [ ] Dashboard `UpcomingBillsWidget` shows cadence labels
- [ ] Settling a bill advances due date by cadence (not start/due delta)

## Dashboard + nav (Theme 2, PR #93)

- [ ] **Goals** appears in desktop sidebar and mobile More drawer
- [ ] Mobile More → **Home** returns to landing page (`/`)
- [ ] Spending-by-tag and Recent transactions have visible gap (not touching)
- [ ] Balance trends chart: **no** "unknown" / "unknown source" series in legend

## Data Hub + Profile (Theme 3, PR #94)

- [ ] Data Hub tabs: Overview, Sources, Categories, Tags — one panel at a time
- [ ] Overview KPIs moved from Profile (assets, spending, etc.)
- [ ] Profile tabs: Settings, Security, **Data** (export) — no Overview tab
- [ ] Row Edit/Delete buttons fit without overflow (compact size)
- [ ] Export still blocked offline / with pending outbox

## Guide mode + tours (Theme 4, PR #95)

- [ ] **Calendar:** Guide mode highlights nav, filters, grid, day detail (not empty)
- [ ] **Data Hub:** Guide mode covers tabbed sections
- [ ] **Dashboard:** Guide mode covers new widgets (goals, upcoming bills, balance history, etc.)
- [ ] Replay tours: Data Hub, Profile, Goals pages
- [ ] Quick Add / transaction / bill forms: walkthrough steps into fields
- [ ] Upcoming tour strings localized (tl-PH spot-check)

## PWA / mobile

- [ ] Offline read still works on Data Hub lists after tab restructure
- [ ] Goals page reachable from nav on mobile

## Flip gate

Only after all above pass:

```bash
ssh dev@159.198.75.194 'cd ~/finance_manager && ./scripts/fm_server_beta.sh switch'
```

Update `design_docs/30_Releases/Runtime_Signup_Sheet.md` on flip.
