# Runtime handoff — PLAN_CROSS_PRODUCTION_UX_FIX_2026-06-28

**Updated:** 2026-06-28  
**Branches:** web `cur/s1b/feat/production-ux-batch` · api `cur/s1b/feat/production-ux-batch`  
**Status:** completed — merged, promoted to production (active color **blue**), HitM-verified

## Done this session

| Task | Summary |
|---|---|
| T01 | Brand → landing; authenticated `/login` return CTA |
| T03 | Form label i18n (`form.label.*`, `upcoming.editor.label.*`) |
| T04 | Legal copy — removed internal codes |
| T02 | API: interval-based due-date advance + catch-up endpoint; one-time bills marked paid on tx link. Web: overdue actions on upcoming list |
| T05 | Option C wizard (currency + source), auth gate, signup/login redirect, Profile "Run setup wizard again"; `T05_tour-gap-list.md` |

## HitM decisions recorded

- **T02:** Advance by bill interval (option B); monthly fallback when interval unknown. Full cycle engine deferred — see `strategy/anomalies/2026-06-28_PRODUCTION-UX-FIX_T02_bill-interval-cycle-revamp.md`
- **T05:** Option C (short wizard + tours follow-up)

## CPPRD status

- **Commits:** api `b3dad4d`, web `d861967` on `cur/s1b/feat/production-ux-batch`
- **PRs:** api [#51](https://github.com/AzazelAzure/finance-manager-api/pull/51) · web [#80](https://github.com/AzazelAzure/finance-manager-web/pull/80) (base `main`, cross-linked)
- **Docs:** subrepo CHANGELOGs + anomaly log + plan registry updated

## Deploy + smoke (inactive blue; active = green)

- VPS clones checked out to branch HEADs; `rebuild-color --no-cache blue` — `api-blue` healthy
- `fm_server_beta.sh smoke --color blue` — pass (redis, api health, web serve, public edge)
- T02 route live on blue: internal `POST .../catch-up/` → 401 (registered, auth-guarded); active green prod API → 404 (old code, expected)
- External staging path: `api-jsdevtesting.thehivemanager.com/api/health/` → 200; catch-up → 401

## Runtime owner

- **Released 2026-06-28.** See `design_docs/30_Releases/Runtime_Signup_Sheet.md`.
  VPS left live on active **blue** after closeout smoke; no further lifecycle
  commands from this plan.

## Post-review fixes (2026-06-28, commit web `581b649`)

HitM reported two regressions in the first batch; both fixed and re-verified in-browser on `jsdevtesting`:

- **Login interstitial removed:** `/login` no longer renders an "already signed in / return to dashboard" page. Authenticated users (fresh login or revisit) redirect straight into the app. Public header login pill becomes "Return to Dashboard" when authenticated.
- **Onboarding only on account creation:** gated on explicit `fm_onboarding_active_v1` marker (set at signup / manual restart, cleared on finish/skip). Existing users with empty localStorage no longer forced into the wizard.

Browser verification (jsdevtesting, blue): cleared localStorage → fresh login as existing `ux_demo` → landed directly on `/app/dashboard` (no interstitial, no onboarding). Authenticated landing header shows "Return to Dashboard". Unauthenticated landing shows Log in / Get started.

## HitM final-check surface

- Web: **https://jsdevtesting.thehivemanager.com** (serves blue bundle; SPA → `api-jsdevtesting.thehivemanager.com` = blue API)
- Verify: brand→landing nav (T01), form labels (T03), legal copy (T04), overdue bill mark-paid+advance / bulk catch-up (T02), new-user 2-step wizard + Profile "run setup wizard again" (T05)

## Closeout (done 2026-06-28)

- Merged: api #51 (`43b88fb`), web #80 (`e9e326c`); VPS clones on `main`.
- `fm_server_beta.sh switch --to blue` — green → **blue** after pre-cutover smoke.
- Production smoke: web 200, api health 200, catch-up route live (401 unauth).
- Plan README + `governance/plan_registry.md` marked completed.
- Rollback if needed: `fm_server_beta.sh rollback` (back to green).
