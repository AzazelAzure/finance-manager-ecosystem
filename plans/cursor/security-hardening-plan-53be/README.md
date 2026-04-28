# Security Hardening and Middleware Alignment Plan

## 0) Metadata
- Plan ID: `PLAN_SECURITY_HARDENING_MIDDLEWARE_ALIGNMENT_2026-04-28`
- Status: `ready_for_execution`
- Priority: `P0`
- Plan root: `plans/cursor/security-hardening-plan-53be/`
- Intended orchestration branch: `cursor/security-hardening-plan-53be`
- Target repos/areas: `finance_manager_api`, `finance_manager_reflex`, `design_docs`, `finance_manager_rust_middleware`, `finance_manager_rust_tools`

## 1) Objective
Close the security gaps that matter before wider beta use while keeping the current API and Reflex application usable. Establish low-rebuild seams for later Rust/ZK middleware work so future encryption, rolling-key, or gateway integration does not require replacing the current app surface.

## 2) Scope

### In scope
- Remove tracked secret backups and harden ignore/rotation guidance.
- Enforce authenticated-by-default API access and add negative auth tests.
- Clarify beta token/cookie posture for Reflex and the API.
- Redact or remove sensitive payload/identifier logging.
- Document current beta security posture versus future ZK/Rust middleware posture.
- Align Rust middleware starter repos and docs around lockfiles, integration mode, and envelope/header contracts.

### Out of scope
- Full zero-knowledge implementation.
- Rust crypto implementation beyond scaffolding/contract decisions.
- New product features unrelated to security posture.
- Merge actions without Slack `#pull-requests` authorization and GitHub mergeability/check reconciliation.

## 3) Source Evidence
- `finance_manager_api/finance_api/settings.py` lacks `REST_FRAMEWORK.DEFAULT_PERMISSION_CLASSES`.
- `finance_manager_api/.env.bak` is tracked and contains secret-like values.
- `finance_manager_reflex/finance_manager_reflex/core/auth_state.py` stores access/refresh tokens in `rx.Cookie`.
- `finance_manager_api/finance/views/tx_views.py` logs invalid transaction request `data`.
- `design_docs/00_Encryption_Strategy.md` and `design_docs/40_System_Design/Authentication.md` define future passphrase, rolling-key, and ZK direction.
- `design_docs/rust_docs/00_Rust_Overview.md` lists FFI, service, and gateway modes but does not freeze one.
- `docs/DEPENDENCY_LOCKFILES.md` says shipped Rust binaries/services should commit `Cargo.lock`, while current Rust starter `.gitignore` files ignore it.

## 4) Phase Plan

### Phase A: Immediate beta blockers
- Goal: Remove direct secret exposure and make authenticated API access explicit.
- Entry criteria: API repo clean feature branch exists.
- Exit criteria: `.env.bak` is removed/ignored, secrets are documented for rotation, finance routes deny anonymous requests with 401 unless explicitly public, and targeted tests pass.
- Breakpoints: Security Breakpoint A.
- Triggers: Continue only after no tracked secret backup remains and anonymous finance-route tests prove default auth.
- Dependencies: `finance_manager_api` tests and changelog.
- Required implementation updates: `tasks/T02_secret_hygiene.md`, `tasks/T01_api_auth_defaults.md`.
- Verification gate: `validation_gates.md`.
- Risks and mitigations: Permission default changes can break public endpoints; require explicit `AllowAny` list and regression tests.

### Phase B: Token and logging posture
- Goal: Reduce token theft and sensitive logging risk before beta support expands.
- Entry criteria: API auth defaults are fixed or accepted as in-progress blocker.
- Exit criteria: Reflex/API token model has an agreed beta stance; sensitive request payloads and raw usernames are not logged by default.
- Breakpoints: Security Breakpoint B.
- Triggers: Continue after token/cookie behavior is documented and logging tests/manual checks prove redaction.
- Dependencies: API and Reflex behavior decisions.
- Required implementation updates: `tasks/T03_reflex_token_storage.md`, `tasks/T04_logging_redaction.md`.
- Verification gate: `validation_gates.md`.
- Risks and mitigations: HttpOnly refresh-cookie migration may be larger than current wave; if deferred, document the accepted beta risk and CSP/HTTPS mitigations.

### Phase C: Future Rust/ZK alignment
- Goal: Define seams that let Rust middleware attach later without API/Reflex rebuild.
- Entry criteria: Current beta posture is documented honestly as JWT/OAuth plus plaintext finance payloads over HTTPS.
- Exit criteria: Design docs define current-vs-future security posture, crypto envelope placeholder, rolling-key header names, feature flag, and integration-mode decision path.
- Breakpoints: Security Breakpoint C.
- Triggers: Continue after docs distinguish beta requirements from future ZK work.
- Dependencies: design docs and Rust starter repos.
- Required implementation updates: `tasks/T05_middleware_alignment_docs.md`.
- Verification gate: `validation_gates.md`.
- Risks and mitigations: Avoid implementing crypto prematurely; freeze contracts and feature flags first.

## 5) Execution Order
1. `tasks/T02_secret_hygiene.md`
2. `tasks/T01_api_auth_defaults.md`
3. `tasks/T04_logging_redaction.md`
4. `tasks/T03_reflex_token_storage.md`
5. `tasks/T05_middleware_alignment_docs.md`

## 6) Completion Criteria
- No tracked secret backup remains in API repo.
- Authenticated finance endpoints fail closed by default.
- Token/cookie beta posture is explicit and does not conflict with future Rust middleware.
- Logs omit sensitive finance payloads and raw user identifiers by default.
- Design docs clearly separate current beta security from future ZK/Rust middleware.
- Rust starter docs/ignore policy align with the chosen lockfile and integration contract direction.
- Every implementation repo has focused branch/PR, validation evidence, Slack `#pull-requests` post, and GitHub mergeability/check reconciliation.
