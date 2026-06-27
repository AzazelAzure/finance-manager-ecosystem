---
plan_id: PLAN_CROSS_SIGNUP_CLICKWRAP_2026-06-27
status: completed
priority: P1
created: 2026-06-27
updated: 2026-06-28
owner: pproctor

plan_root: plans/S1/S1.B/feat-signup-clickwrap/
intended_branch: cur/s1b/feat/signup-clickwrap
target_repos:
  - finance_manager_web
  - finance_manager_api

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with:
  - PLAN_CROSS_EMAIL_COMMS_2026-06-27
  - PLAN_CROSS_UI_UX_TEST_SEED_2026-06-27
conflicts_with:
  - PLAN_CROSS_API_SECURITY_HARDENING_2026-06-26

manual_gates:
  pre_execution: optional
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [api, js]
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - POST /api/auth/register/ with tos_version + tos_accepted_at fields (201)
    - POST /api/auth/register/ without tos_accepted_at (400 validation error)
    - GET /signup renders checkbox + ToS/Privacy links
  notes: >-
    Requires migration on API side (new AppProfile fields). Must deploy after
    PLAN_CROSS_LEGAL_PAGES_2026-06-27 — the ToS checkbox links to /terms and
    /privacy which must exist. Can be implemented in parallel with legal-pages but
    deploy AFTER legal-pages is live on VPS.
    Conflicts with API security hardening: both touch AppProfile and/or auth
    registration flow. Sequence this AFTER security hardening sprint completes
    to avoid migration conflicts.

standalone: false
standalone_notes: >-
  Must deploy AFTER PLAN_CROSS_LEGAL_PAGES_2026-06-27 is live (links to /terms
  and /privacy in the clickwrap checkbox). Implementation can proceed in parallel.

legal_impact:
  tos: true
  privacy_policy: true
  cookie_policy: false
  notes: >-
    This plan implements the N2 requirement: timestamp + ToS version logged on
    account creation. Privacy Policy §11 (age self-declaration) and ToS §1
    (affirmative acceptance required) both reference this mechanism.
    When complete, update legal_workflow_coordination.md to close N2.
---

## 0) Strategic Inheritance

- Wedge respected: yes — clickwrap is a legal compliance requirement, not a feature gate
- Locked decisions touched: none
- Cost cap impact: none — one migration, small API field additions
- Validation gates affected: S1.B public beta gate (legal compliance: affirmative ToS acceptance required before account creation)

## 1) Objective

Implement affirmative consent (clickwrap) on the account creation flow. When a user signs up, they must check a box "I agree to the Terms of Service and Privacy Policy." The accepted ToS version and timestamp are stored on the API. This satisfies N2 from `strategy/legal/scope_analysis.md` and ToS §1 requirement for logged affirmative acceptance.

Additionally, add visible links to Terms of Service and Privacy Policy on the login page (for users who want to review before re-authenticating).

## 2) Scope

### In scope
- `SignupPage.tsx`: add required checkbox "I agree to the [Terms of Service] and [Privacy Policy]" above the submit button; form cannot submit until checked; links open `/terms` and `/privacy` respectively
- API: add `tos_version` (CharField, max_length=20) and `tos_accepted_at` (DateTimeField, nullable=false) to `AppProfile` model
- API: new migration for the above fields
- API: registration endpoint updated to require and store `tos_version` and `tos_accepted_at`; return 400 if missing
- `LoginPage.tsx`: add a small footnote line "By logging in you agree to our [Terms of Service] and [Privacy Policy]" with links (informational only, no checkbox required on login)
- `SignupPage.tsx` + `LoginPage.tsx`: both already have Helmet SEO — no changes needed there

### Out of scope
- Storing a full audit log of every ToS version a user accepted — V1 is: store the version at account creation; re-consent on ToS version bump is a follow-up
- Re-consent flow when ToS version changes — separate plan when needed
- GDPR explicit consent checkboxes beyond ToS/Privacy — deferred
- Age verification beyond self-declaration already stated in ToS §2 — no additional checkbox (ToS acceptance covers this)
- Email confirmation of ToS acceptance to user — separate from email comms plan

## 3) Source Evidence

- `strategy/legal/scope_analysis.md` — N2: "Clickwrap: timestamp + ToS version logged in account creation flow"
- `strategy/legal/drafts/tos_v1.md §1` — "Affirmative acceptance is required. A binding agreement is formed when you complete account registration... The timestamp and version of the Terms you accepted will be logged."
- `finance_manager_web/src/pages/SignupPage.tsx` — existing signup form
- `finance_manager_web/src/pages/LoginPage.tsx` — existing login form
- `finance_manager_api/finance/models.py` — AppProfile model (check for existing fields before migration)
- `finance_manager_api/finance/factories.py` — AppProfileFactory (update to include tos fields)

## 4) Phase Plan — Task List

| Task | Title | Slices | V-tier |
|---|---|---|---|
| T01 | API: model + migration | T01.SL1 AppProfile fields; T01.SL2 Migration; T01.SL3 Registration endpoint | V1 |
| T02 | Web: signup + login updates | T02.SL1 Signup clickwrap; T02.SL2 Login footnote | V3 |

## 5) Execution Order

T01 (API) and T02 (Web) can be implemented in parallel. Deploy order: T01 must be deployed before T02 goes live (API must accept the new fields before the web sends them).

1. `tasks/T01_api_tos_fields.md` — T01.SL1 → T01.SL2 → T01.SL3
2. `tasks/T02_web_clickwrap.md` — T02.SL1 → T02.SL2 (parallel with T01)

## 6) Verification Gates

- [V1] `python manage.py makemigrations --check` produces no additional migrations after T01.SL2
- [V1] `pytest` passes on registration endpoint tests (new test: missing `tos_accepted_at` → 400)
- [V1] `npm run build` passes with updated SignupPage
- [V3] Browser: Signup form shows checkbox; submit button is disabled until checkbox is checked
- [V3] Browser: Clicking "Terms of Service" in checkbox opens `/terms`
- [V3] Browser: Clicking "Privacy Policy" in checkbox opens `/privacy`
- [V3] Browser: Successful signup confirms `tos_accepted_at` is stored (check Django admin or API response)
- [V3] Browser: Login page shows footnote with ToS/Privacy links

## 7) Documentation Sync Required

- `strategy/legal/legal_workflow_coordination.md`: close N2 ("Clickwrap: timestamp + ToS version") when plan completes
- `governance/plan_registry.md`: move to Completed

## 8) Strategic Phase Impact

When closing:
- [ ] Update `strategy/legal/legal_workflow_coordination.md` — mark N2 closed
- [ ] Update `governance/plan_registry.md` status to `completed`
- [ ] Post completion summary to IDE Chat

## 9) Completion Criteria

- All V1/V3 gates in §6 met
- HitM confirms signup flow works on VPS with clickwrap (pre_merge gate)
- PR merged (both API and Web; coordinate deploy order per §5)
- §8 actions complete

## 10) Risks and Rollback

| Risk | Trigger | Rollback action | Owner |
|---|---|---|---|
| Migration conflict with security hardening (AppProfile/User) | `makemigrations` produces unexpected state | Sequence this plan AFTER security hardening sprint completes | HitM to sequence |
| Existing users have null tos_accepted_at | Backfill needed | Allow null=True initially; set default for existing users in data migration; require non-null for new signups only | Cursor |
| Web sends fields API doesn't expect yet | 400 on signup | Deploy T01 (API) first; then T02 (Web) | HitM to coordinate deploy order |
