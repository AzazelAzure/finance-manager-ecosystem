# T01 — API: ToS Acceptance Fields + Registration Update

## Context

AppProfile currently has no record of when or what ToS version a user accepted. This adds two fields and updates the registration endpoint to require them.

## End State

- `AppProfile` has `tos_version` (CharField) and `tos_accepted_at` (DateTimeField)
- Migration applied
- Registration endpoint requires and stores both fields
- Existing users: `tos_version` and `tos_accepted_at` can be null (for pre-clickwrap accounts); new accounts require both

## Slice Decomposition

| Slice | Title | V-Tier |
|---|---|---|
| T01.SL1 | Model fields | V1 |
| T01.SL2 | Migration | V1 |
| T01.SL3 | Registration endpoint | V1 |

## T01.SL1 — Model Fields

In `finance/models.py`, add to `AppProfile`:

```python
tos_version = models.CharField(max_length=20, blank=True, null=True)
tos_accepted_at = models.DateTimeField(null=True, blank=True)
```

Both nullable to allow existing accounts without re-consent. New signup flow enforces non-null via the serializer (not the model constraint).

Also update `AppProfileFactory` in `finance/factories.py`:
```python
tos_version = factory.LazyAttribute(lambda o: "1.0")
tos_accepted_at = factory.LazyAttribute(lambda o: django.utils.timezone.now())
```

**Acceptance criteria:**
- [V1] `AppProfile` model has both fields; Django check passes (`python manage.py check`)

## T01.SL2 — Migration

```bash
python manage.py makemigrations finance --name="tos_acceptance_fields"
python manage.py migrate
```

Verify the migration file looks clean (only adds two fields to `finance_appprofile`).

**Acceptance criteria:**
- [V1] Migration file created, migration applies without error
- [V1] `python manage.py makemigrations --check` shows no further changes after applying

## T01.SL3 — Registration Endpoint

Locate the user registration serializer/view (likely in `finance/api_tools/` or a registration endpoint). Update to:

1. Accept `tos_version` and `tos_accepted_at` in the request body
2. Validate: if either is missing → 400 with descriptive error
3. On success: store both on the created `AppProfile`

**Clarification required if:** the registration endpoint creates `AppProfile` via a signal (`post_save`) rather than directly in the view. In that case, pass `tos_version` and `tos_accepted_at` through a different mechanism (e.g., annotate the User instance before save, pick it up in the signal). Ask HitM before implementing if the flow is unclear.

Add a test: `POST /api/auth/register/` without `tos_accepted_at` → `400`.

**Acceptance criteria:**
- [V1] Registration endpoint returns 400 when `tos_accepted_at` is missing from payload
- [V1] Registration succeeds and stores `tos_version` + `tos_accepted_at` on `AppProfile` when provided
- [V1] New pytest test covers the 400 case

## Evidence

- `evidence/T01.SL2_migration_apply.txt` — migration output
- `evidence/T01.SL3_test_pass.txt` — pytest output for registration tests
