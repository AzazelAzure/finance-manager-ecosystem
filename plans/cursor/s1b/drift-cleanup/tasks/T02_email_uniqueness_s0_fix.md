# T02 — Email Uniqueness S0 Fix (Distribution-Blocker)

## Objective

Fix the **S0 critical distribution-blocker** from huddle Topic 1: DB enforces username uniqueness only, not email uniqueness. Two accounts can be created with the same email address. This blocks any meaningful new-user invitation cycle until fixed.

## Scope Boundary

- Repo: `finance_manager_api/` (primary)
- Repo: `finance_manager_web/` (secondary — UI handling of duplicate-email signup response)
- Branch: `cursor/s1b/drift-cleanup/t02-email-uniqueness-s0-fix`
- Multi-repo coordination per `_governance/branching_guidelines.md` §8.2 (API ships first, web ships second).

## Current Evidence

Per huddle Topic 1 / `KNOWN_ISSUES.md`:

- DB User model enforces `username` uniqueness only.
- HitM discovered during onboarding testing.
- Password-reset flow keyed on email becomes ambiguous (auth-collision risk).
- Account-deletion flow may behave incorrectly with duplicate emails.

## Pre-Implementation Audit (CRITICAL — do first)

Per huddle Topic 1 operational consequence, audit existing data before any new constraint is applied:

```sql
SELECT email, COUNT(*) FROM auth_user GROUP BY email HAVING COUNT(*) > 1;
```

- If non-empty: STOP. Manual dedup work needed before migration. Engage HitM.
- If empty: proceed with migration confidence.

## Implementation Notes

### 1. DB-level constraint (migration)

- Add `UNIQUE` constraint on `auth_user.email` field.
- Migration must be idempotent / safe-to-rerun.
- Migration uses Django's standard pattern.

### 2. Validation layer

- Signup serializer: validate email uniqueness BEFORE attempting insert (return clear 400 with field-level error).
- Same for any user-update path that allows email change.

### 3. Auth path consistency

- Confirm whether email-based login is enabled. If yes, ensure unambiguous resolution post-uniqueness.
- Password reset flow: now safe (email is unique → reset goes to one account).

### 4. Case sensitivity decision

- Decide: case-insensitive uniqueness (`Foo@example.com` = `foo@example.com`) or case-sensitive?
- Recommendation: case-insensitive; normalize to lowercase on insert. Most email providers ignore case in local-part, and case-sensitive uniqueness leaves attackers an easy collision vector.

### 5. UI handling (web)

- Signup form: handle 400 response gracefully ("This email is already registered. Sign in instead.").
- No information disclosure beyond standard "this email is taken."

### 6. Testing

- New unit tests: signup with duplicate email returns 400, not 500.
- Migration test on a copy of production data (audit step above provides this).
- Auth flow test: password reset with valid email reaches the correct account.

## Acceptance Criteria

- Pre-implementation audit completed; result documented in PR description.
- DB-level UNIQUE constraint on `auth_user.email` (case-insensitive normalized).
- Signup serializer validates uniqueness before insert.
- 400 response on duplicate-email signup with clear UI message.
- Password reset flow tested and verified unambiguous.
- All existing tests still pass.
- Migration runs cleanly on production (after audit).

## Verification Commands

```bash
# Pre-migration audit (run via VPS SSH)
ssh dev@159.198.75.194 'cd ~/finance_manager/finance_manager_api && \
  podman exec finance-manager-db psql -U finance_user -d finance_db \
  -c "SELECT email, COUNT(*) FROM auth_user GROUP BY email HAVING COUNT(*) > 1;"'

# Local API tests
cd finance_manager_api && uv run pytest finance/tests/user_tests/ -v -k "email"

# Migration dry-run
uv run python manage.py migrate --plan
```

## Risks / Rollback

| Risk | Trigger | Rollback |
|---|---|---|
| Migration runs against existing duplicate emails and fails | `IntegrityError` on migration | Revert migration; do dedup work; re-attempt |
| Existing users locked out due to case-sensitivity normalization | User had `Foo@x.com`, post-migration their email is `foo@x.com` and login fails on case mismatch | Apply case-insensitive comparison in login serializer |
| UI doesn't handle new 400 cleanly | Error message says `[object Object]` or 500 | Web fix before deploy or as immediate hotfix |
| Honorary US Founder accounts have edge cases | Duplicate detected in audit | Coordinate with HitM; may need manual cleanup before migration |

## Slack Gates

- `pre_execution`: required.
- `pre_deploy`: **required + with audit result documented**.
- `pre_cutover`: required.
- `pre_close`: required (this is the distribution-blocker; closure must verify production state).

## Estimated Effort

3–5 hours (audit + migration + serializer + UI handling + testing).

## Operational consequence reminder

**Until this task ships: NO ADDITIONAL INVITEES.** Tight Beta cohort stays at current state.
