# PLAN_API_OAuth_Integration_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_API_OAuth_Integration_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P0`
- Target repos/areas: `finance_manager_api` (Auth/Infrastructure)

## 1) Objective
Implement a production-ready OAuth2 authentication system in the `finance_manager_api`. This will allow users to authenticate via third-party providers (initially Google and GitHub) and bridge these sessions with our existing JWT-based authentication system.

## 2) Scope
### In scope
- Integration of `django-allauth` for social account management.
- Integration of `dj-rest-auth` for REST-compliant auth endpoints.
- Configuration of Google and GitHub social login providers.
- JWT-bridge for social logins (returning SimpleJWT tokens).
- Blacklisting and rotation policies for OAuth-generated tokens.

### Out of scope
- Frontend (Reflex) UI for OAuth (handled in a separate Reflex plan).
- Password reset email templates (baseline setup only).

## 3) Inputs / Source Docs
- `finance_manager_api/finance_api/settings.py` (Current JWT config)
- `design_docs/00_Coding_Guidelines.md`
- `design_docs/20_Roadmap/Phase_2_Beta_Preparation.md`

## 4) Constraints & Guardrails
- **Rule #10 (Fix it Forever):** Ensure social login accounts are correctly linked to our `AppProfile` via signals to prevent data fragmentation.
- **Rule #7 (Professionalism):** Use `dj-rest-auth` and `django-allauth` as the industry standards for DRF OAuth.
- **Security:** Secret keys for OAuth providers MUST be pulled from environment variables, never hardcoded.

## 5) Execution Breakdown

### Task T1: Dependency & Baseline Config
- **Goal:** Install and register OAuth dependencies.
- **Files to edit:** `finance_manager_api/pyproject.toml`, `finance_manager_api/finance_api/settings.py`.
- **Implementation notes:**
    - Add `django-allauth` and `dj-rest-auth`.
    - Update `INSTALLED_APPS`: add `allauth`, `allauth.account`, `allauth.socialaccount`, `dj_rest_auth`, `dj_rest_auth.registration`.
    - Add `allauth.socialaccount.providers.google` and `github`.
    - Set `SITE_ID = 1`.
- **Acceptance criteria:** `uv sync` completes; Django starts without errors.

### Task T2: URL Routing
- **Goal:** Expose the OAuth and social registration endpoints.
- **Files to edit:** `finance_manager_api/finance_api/urls.py`.
- **Implementation notes:**
    - Include `dj_rest_auth.urls`.
    - Include `dj_rest_auth.registration.urls`.
    - Include `allauth.socialaccount.urls`.
- **Acceptance criteria:** `/api/auth/` endpoints are visible in `drf-spectacular` (Swagger).

### Task T3: JWT Bridge Configuration
- **Goal:** Ensure social logins return standard SimpleJWT tokens.
- **Files to edit:** `finance_manager_api/finance_api/settings.py`.
- **Implementation notes:**
    - Set `REST_USE_JWT = True`.
    - Set `JWT_AUTH_COOKIE = 'finance-auth'`.
    - Set `REST_AUTH_SERIALIZERS` if custom profile creation is needed.
- **Acceptance criteria:** Social login attempts (even if failing due to missing keys) trigger JWT generation logic.

### Task T4: Provider & Signal Hardening
- **Goal:** Ensure every OAuth user gets an `AppProfile` and has correct isolation.
- **Files to edit:** `finance_manager_api/finance/api_tools/signals.py` (verify).
- **Implementation notes:**
    - Ensure the existing `AppProfile` signal triggers correctly for users created via `allauth`.
- **Acceptance criteria:** Creating a user via OAuth results in a corresponding `AppProfile` entry.

## 6) Verification Plan
- **Integration Check:** Use `drf-spectacular` to verify the presence of social login endpoints.
- **Unit Test:** Mock a social login response and verify a JWT is returned.
- **Security Check:** Verify that OAuth secrets are not in the codebase and are successfully pulled from `.env`.

## 7) Documentation & Feature Tracking
- [ ] Update `finance_manager_api/CHANGELOG.md` (Rule #8).
- [ ] Tag as "Phase 2: Backend Hardening" (Rule #9).
- [ ] Move plan to `plans/archived/` upon completion (Rule #12).
