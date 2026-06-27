# T04 — CHANGELOG and Final Cleanup

## End State
`CHANGELOG.md` has an `[Unreleased]` entry describing all security changes. `python manage.py check --deploy` passes. The branch is clean and ready for `gh pr create`.

## Acceptance Criteria
1. [V0] `CHANGELOG.md` `[Unreleased]` section contains entries for: axes lockout, Argon2 hasher, ComplexPasswordValidator, proxy IP config
2. [V1] `python manage.py check --deploy` exits 0 with no ERRORS (WARNINGS about HTTPS/ALLOWED_HOSTS are expected in local dev; note them but do not fail on them)
3. [V0] `git status` is clean (no untracked files relevant to this plan)

## Scope Lock

### Files to modify
- `CHANGELOG.md` — add under `[Unreleased]` → `### Security`

### CHANGELOG entry format (add exactly these items)
```markdown
### Security
- **Login lockout:** django-axes configured (5 failures → 1-hour cooloff); proxy-aware for nginx reverse proxy (`AXES_PROXY_COUNT = 1`)
- **Password hashing:** Argon2 is now the default password hasher (argon2-cffi); PBKDF2 retained as fallback for legacy hashes
- **Password complexity:** `ComplexPasswordValidator` enforces minimum 12 characters, at least one uppercase, one digit, one special character on all password-setting flows
- **Security headers:** HSTS 1-year, `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY` set in settings
```

### Files NOT to touch
- Any code files (all code changes complete by T03)

## Slice Decomposition
| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T04.SL1 | CHANGELOG update | V0 | Add `### Security` block to `[Unreleased]`; verify format matches existing CHANGELOG style |
| T04.SL2 | Final check | V1 | `python manage.py check --deploy`; `git status` clean; output logged as evidence |

## Evidence
- `evidence/T04.SL1_changelog_diff.txt` — diff of CHANGELOG.md
- `evidence/T04.SL2_deploy_check.txt` — output of `python manage.py check --deploy`

## PR Instructions
After T04.SL2 passes, open the PR:
```bash
gh pr create \
  --title "feat(api): security hardening — axes lockout, Argon2, password complexity" \
  --body "$(cat <<'EOF'
## Summary
- django-axes login lockout (5 failures → 1hr cooloff), nginx proxy-aware
- Argon2 default password hasher
- ComplexPasswordValidator (12 chars, uppercase, digit, special) wired to all password-setting endpoints
- HSTS, nosniff, X-Frame-Options headers

## Evidence
- pytest suite: see evidence/T03.SL2_pytest_output.txt
- manage.py check --deploy: see evidence/T04.SL2_deploy_check.txt

## Pre-merge gate
HitM must review AXES_PROXY_COUNT value against VPS nginx topology before merge.

🤖 Generated with Cursor Pro+
EOF
)"
```
