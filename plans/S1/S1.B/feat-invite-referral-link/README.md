---
plan_id: PLAN_CROSS_INVITE_REFERRAL_LINK_2026-06-30
status: draft
priority: P2
created: 2026-06-30
updated: 2026-06-30
owner: pproctor

plan_root: plans/S1/S1.B/feat-invite-referral-link/
intended_branch: cur/s1b/feat/invite-referral-link
target_repos:
  - finance_manager_api
  - finance_manager_web

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with:
  - PLAN_CROSS_INVITE_REFERRAL_LINK_2026-06-30
conflicts_with: []

manual_gates:
  pre_execution: none
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [api, js]
  bundle_required: false
  rollback_plan_id: null
  smoke_targets:
    - /invite/<token>/
    - POST /finance/invite/generate/
  notes: "Invite token model + web invite landing route"

standalone: true
standalone_notes: ""

legal_impact:
  tos: false
  privacy_policy: true
  cookie_policy: false
  notes: "Invite tokens are user-generated links. Must document scope, expiry, and what recipient sees before landing in app. Update analytics_and_data_sharing_overview.md at close."
---

## 0) Strategic Inheritance

- Wedge respected: yes — organic invite sharing supports "living on thin margins" community growth without paid acquisition cost
- Locked decisions touched: PH-first market (locked 2026-04-30); pseudo-open beta strategy (organic invite sharing per `strategy/project_beta_strategy.md`)
- Cost cap impact: none at plan level; invite feature itself is zero marginal cost
- Validation gates affected: none directly — supports S1.B distribution readiness

## 1) Objective

Allow existing beta users to generate personal invite links that grant new users access to the app. This is the technical backbone of the pseudo-open beta growth strategy: organic word-of-mouth invite sharing without HitM manually provisioning each user. Separate from F-010 data portability (users sharing their *data*) — this is users sharing *access*.

## 2) Scope

### In scope
- Invite token model on the API: user-generated, time-limited (e.g. 7-day expiry), single-use or limited-use (TBD — HitM to decide)
- `POST /finance/invite/generate/` — authenticated endpoint for existing users to create a token
- `GET /invite/<token>/` — public landing route on the web (pre-auth, shows invite context + signup CTA)
- Invite token validated at signup: invited user gets standard account; token consumed
- Basic tracking: who invited whom (stored on `AppProfile`, not surfaced to inviter — operator-only)
- Graceful expiry: expired/invalid token shows a clear message, not a broken page

### Out of scope
- Referral rewards or gamification (no points, no credits, no discounts — this is invite-only, not referral marketing)
- Multi-use "referral codes" with tracking dashboards for inviters
- Email invite sending from within the app (user copies the link; app does not email on their behalf)
- Rate-limiting invite generation per user (can add later if abuse appears)
- Admin invite management UI (operator uses Django admin)

## 3) Source Evidence

- `strategy/project_beta_strategy.md` — pseudo-open beta, organic invite sharing as growth mechanism
- F-010 RCA (`strategy/audits/2026-06-29_share-link-exposure_rca.md`) — prior incident with public bearer URLs; this plan must not repeat that pattern
- `governance/definition_of_done.md` §5a — privacy gate: this feature introduces a public route (`/invite/<token>/`) that does NOT return user financial data (just invite context), so AllowAny is acceptable here; document this explicitly in §6
- `strategy/analytics_and_data_sharing_overview.md` — update at plan close

## 4) Task List (stub — HitM to mark up before ready)

| Task | Slug | Surface | Notes |
|---|---|---|---|
| T01 | `invite-token-model` | API | `InviteToken` model (creator, token, expiry, used_at, invited_user); migration; `generate/` endpoint |
| T02 | `invite-signup-integration` | API | Validate token at signup; link `invited_by` on `AppProfile`; consume token on use |
| T03 | `invite-landing-web` | Web | `/invite/<token>/` public route — invite context card + signup CTA; expired/invalid state |
| T04 | `invite-generation-ui` | Web | Settings or profile section — "Invite a friend" with copy-link button; show active invites (optional) |

## 5) Execution Order

1. T01 — API model + generate endpoint
2. T02 — API signup integration (depends on T01)
3. T03 — Web landing route (depends on T01 for token validation shape)
4. T04 — Web generation UI (depends on T01/T02)

## 6) Verification Gates

- `POST /finance/invite/generate/` requires authentication; returns 401 if not authenticated
- `GET /invite/<token>/` is public (`AllowAny`); returns invite context only — no user financial data, no personal data of the inviting user beyond a display name or masked identifier (TBD — HitM to decide what recipient sees)
- Expired token: `GET /invite/<token>/` returns a graceful expired state, not 404 or 500
- Used token: cannot be used a second time for signup
- Signup with valid token: new user created, `invited_by` linked, token consumed — verified in API test
- Smoke: `/invite/<token>/` loads on inactive color before promote

**Privacy note (§5a DoD):** `/invite/<token>/` is `AllowAny` but returns **no user financial data** — only invite metadata (e.g. "You've been invited to Hive Finance Manager"). This is explicitly acceptable. HitM risk-acceptance recorded here: ✅ accepted by HitM (confirm before transitioning to `ready`).

## 7) Documentation Sync Required

- `strategy/analytics_and_data_sharing_overview.md` — add invite token to §2a and §3 (what is/isn't collected)
- `strategy/legal/drafts/` — Privacy Policy may need a note on invite link scope if tokens are stored with user identity
- `plan_registry.md` — update status on transitions

## 8) Strategic Phase Impact

When closing this plan:
- [ ] Update `plan_registry.md` status to `completed`
- [ ] Update `analytics_and_data_sharing_overview.md` §2 + §3
- [ ] Review Privacy Policy draft for invite token disclosure
- [ ] Post completion summary to IDE Chat

## 9) Completion Criteria

- T01–T04 merged and live on VPS
- Invite flow manually verified end-to-end (generate → copy link → open in incognito → signup → account created → token consumed)
- No user financial data accessible through invite route
- Privacy Policy updated or explicitly waived by HitM

## 10) Risks and Rollback

| Risk | Trigger | Rollback action | Owner |
|---|---|---|---|
| Token enumeration abuse | Short/predictable tokens lead to unauthorized signups | Rotate to 32-char cryptographic token; add rate limit on `/invite/<token>/` | Cursor |
| Invite spam | Single user generates many tokens for mass signups | Cap tokens per user (configurable env var); default 5 active per user | Cursor |
| Repeat F-010 pattern | Public route inadvertently returns user data | DoD §5a gate; pre-merge review against this risk explicitly | HitM |
