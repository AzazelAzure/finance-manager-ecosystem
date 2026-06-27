---
plan_id: PLAN_CROSS_API_SECURITY_HARDENING_2026-06-26
status: completed
priority: P1
created: 2026-06-26
updated: 2026-06-27
owner: pproctor

plan_root: plans/S1/S1.B/feat-api-security-hardening/
intended_branch: cur/s1b/feat/api-security-hardening
target_repos:
  - finance_manager_api

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with:
  - PLAN_FEAT_F007_WALKTHROUGH_SANDBOX_2026-06-03
conflicts_with: []

manual_gates:
  pre_execution: optional
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [api]
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - GET /api/health/
    - POST /finance/auth/login/ (5 bad attempts → 429 lockout)
    - POST /finance/auth/change-password/ (weak password → 400 rejection)
  notes: >-
    Security hardening only; no new endpoints. Django-axes lockout and Argon2 hashing
    require migrations before deploy. Axes must be configured for nginx proxy
    IP passthrough before going live on VPS — do NOT deploy without T02.SL2 complete.

standalone: true
standalone_notes: ""
---

## 0) Strategic Inheritance

- **Wedge respected:** yes — no user-visible product changes; backend security only
- **Locked decisions touched:** API hardening pattern (S1.A precedent — HSTS, log redaction, env hygiene); password-policy not locked, this sets a new minimum
- **Cost cap impact:** none — no new services or third-party costs
- **Validation gates affected:** none directly; unblocks VPS deployment hygiene (`strategy/strategic-roadmap-reframe-53be/validation_gates.md` — no specific gate, but security hygiene is implied pre-S1.C)

## 1) Objective

Ship the uncommitted API security WIP (django-axes lockout, Argon2 hashing, password complexity validator) as a clean, tested, deploy-ready commit. The WIP exists locally but is on a detached HEAD with an untracked validator file, no proxy config, no tests, and no migrations committed — none of which can merge as-is.

## 2) Scope

### In scope
- Create proper branch `cur/s1b/feat/api-security-hardening` from current API WIP state
- Track and wire `finance/validators/password_complexity.py` (currently untracked) to `AUTH_PASSWORD_VALIDATORS` in `settings.py`
- Wire `validate_password()` to all password-setting endpoints (change, reset, registration) — missing from current WIP
- Configure `django-axes` for nginx reverse-proxy IP passthrough (`AXES_PROXY_COUNT` or `AXES_META_PRECEDENCE_ORDER`)
- Run and commit `python manage.py migrate axes` (and any other pending migrations)
- Write tests: lockout after 5 bad logins, complexity rejection, Argon2 hash verification
- Update `CHANGELOG.md` with security hardening entries
- Fix detached HEAD state to clean branch

### Out of scope
- New API endpoints
- Frontend changes
- ZK middleware (deferred to S5 per locked decision)
- TOTP/2FA (future gate)
- VPS deployment (gate: HitM pre-merge approval required; VPS sync follows separate deployment protocol)

## 3) Source Evidence

- `strategy/current_status.md` §8 — uncommitted WIP description + blockers list
- `governance/definition_of_done.md` §6 — completion checklist
- `plans/S1/S1.B/feat-infra-user-activity-logs/README.md` — prior API plan (structural reference)
- django-axes docs: `AXES_PROXY_COUNT`, `AXES_META_PRECEDENCE_ORDER` for nginx setups
- Django docs: `AUTH_PASSWORD_VALIDATORS`, `validate_password()` usage

## 4) Phase Plan / Task List

| Task | File | Slices | Surface |
|------|------|--------|---------|
| **T01** | `tasks/T01_branch_and_track.md` | T01.SL1–SL2 | Branch hygiene + validator file |
| **T02** | `tasks/T02_wire_policy_and_proxy.md` | T02.SL1–SL2 | Password endpoints + axes proxy config |
| **T03** | `tasks/T03_migrations_and_tests.md` | T03.SL1–SL2 | Axes migrations + test suite |
| **T04** | `tasks/T04_changelog_and_cleanup.md` | T04.SL1–SL2 | CHANGELOG + final checks |

## 5) Execution Order

1. `tasks/T01_branch_and_track.md` — establish branch, track validator; **must complete before any other task**
2. `tasks/T02_wire_policy_and_proxy.md` — T02.SL1 (endpoint wiring) → T02.SL2 (proxy config); sequential
3. `tasks/T03_migrations_and_tests.md` — T03.SL1 (migrations) → T03.SL2 (tests); sequential
4. `tasks/T04_changelog_and_cleanup.md` — T04.SL1–SL2; can only run after T03 passes

**Blocking rule:** Do not open a PR until T03.SL2 (tests) is green and T02.SL2 (proxy config) is confirmed correct.

## 6) Verification Gates

| Slice | Pass condition |
|-------|---------------|
| T01.SL1 | `git status` shows clean branch on `cur/s1b/feat/api-security-hardening`; no detached HEAD |
| T01.SL2 | `password_complexity.py` is tracked (`git status` shows it as new file or modified, not untracked) |
| T02.SL1 | `POST /finance/auth/change-password/` with a password < 12 chars or lacking uppercase/digit/special returns `400` with error field |
| T02.SL2 | `settings.py` includes `AXES_PROXY_COUNT` (or equivalent) matching nginx config; reviewed by HitM before merge |
| T03.SL1 | `python manage.py showmigrations axes` shows all migrations applied; migration file committed |
| T03.SL2 | `pytest` suite green; lockout test (5 bad logins → 429), complexity test, Argon2 test all pass |
| T04.SL1 | `CHANGELOG.md` entry added under `[Unreleased]` covering: axes lockout, Argon2, complexity validator, proxy config |
| T04.SL2 | `python manage.py check --deploy` passes with no critical warnings |

## 7) Documentation Sync Required

- `governance/plan_registry.md`: move row to In Progress on start, Completed on merge
- `strategy/current_status.md` §8: API WIP blockers resolved (admin update, not executor scope)

## 8) Strategic Phase Impact

When closing this plan, executor must:
- [ ] Update `governance/plan_registry.md` status to `completed`
- [ ] Post completion summary to IDE Chat (build log + test log as evidence)
- [ ] Do NOT update `validation_gates.md` — no S1.B exit gate is gated on this plan

## 9) Completion Criteria

- All V-tier gates in §6 met and evidence logged
- `pytest` suite green (T03.SL2)
- `python manage.py check --deploy` clean (T04.SL2)
- PR created via `gh pr create`; HitM pre-merge gate cleared
- `plan_registry.md` updated to `completed`

## 10) Risks and Rollback

| Risk | Trigger | Rollback action | Owner |
|---|---|---|---|
| Axes lockout locks out dev account on VPS | `AXES_PROXY_COUNT` misconfigured; real IP not passed | `python manage.py axes_reset` on VPS; revert `settings.py` proxy config | Cursor executor pre-deploy; HitM on VPS |
| Password complexity breaks existing users on login | `validate_password` wired to login (wrong endpoint) | Revert to prior `AUTH_PASSWORD_VALIDATORS`; complexity only applies to set/change, not auth | Cursor executor |
| Argon2 migration breaks admin login | Argon2 not installed or config error | `pip install argon2-cffi` verify; fallback to PBKDF2 in settings if critical | Cursor executor |
| Migrations conflict with F-013 (axes vs finance migrations) | Merge conflict in migration files | Reorder migrations manually; check `0009_merge_20260626` is predecessor | Cursor executor |
