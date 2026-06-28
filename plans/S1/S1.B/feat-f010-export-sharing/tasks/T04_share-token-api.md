# T04 — Share Token API

## End State

A new `ExportShareToken` model and two endpoints allow authenticated users to create a time-limited (7-day default, 30-day max) read-only share token. Hitting the public share endpoint with a valid token returns a JSON snapshot of that user's transactions — no JWT required. Expired or unknown tokens return 404 (not 401, to avoid leaking token existence). Tokens are revocable.

**Sharing v1 scope decision:** Time-limited JSON link (not PDF). PDF generation requires additional dependencies and renders slowly on large datasets; deferred to a future pass. A link is more useful for the "send to spouse" household use case.

## Acceptance Criteria

1. [V1] `POST /finance/export/share/` (authenticated) creates an `ExportShareToken` → returns `{ "token": "<uuid>", "expires_at": "<ISO>" }`
2. [V1] Optional body `{ "expires_in_days": N }` (1–30); defaults to 7 if absent or invalid
3. [V1] `GET /finance/export/share/{token}/` (public — no JWT) returns transaction JSON snapshot if token is valid and not expired
4. [V1] Expired or unknown token → 404 (not 401)
5. [V1] `DELETE /finance/export/share/{token}/` (authenticated, owner only) revokes token → 204
6. [V1] `GET /finance/export/share/{token}/` on revoked token → 404
7. [V1] Security test: user A's token cannot retrieve user B's data
8. [V1] Migration added — `ExportShareToken` table created cleanly
9. [V1] loguru audit: `share_token_created user={uid} token={uuid} expires_at={}` and `share_token_accessed token={uuid} tx_count={}`
10. [V1] `python manage.py test` passes

## Scope Lock

### Files to create
- `finance/views/export_views.py` — add `ShareTokenCreateView`, `ShareTokenAccessView`, `ShareTokenRevokeView` (extend existing file from T01/T02)

### Files to modify
- `finance/models.py` — add `ExportShareToken` model
- `finance_api/urls.py` — register share endpoints
- `finance/tests/test_f010_export.py` — add share token tests

### New migration
- Auto-generated via `python manage.py makemigrations finance`

### Files NOT to touch
- CSV and backup views from T01/T02 — no refactor during T04
- Any existing model

## Slices

### T04.SL1 — ExportShareToken model
Add to `finance/models.py`:
```python
class ExportShareToken(models.Model):
    uid = models.ForeignKey(AppProfile, on_delete=models.CASCADE, related_name="share_tokens")
    token = models.UUIDField(default=uuid.uuid4, unique=True, editable=False)
    created_at = models.DateTimeField(auto_now_add=True)
    expires_at = models.DateTimeField()
    revoked = models.BooleanField(default=False)

    class Meta:
        indexes = [models.Index(fields=["token"])]
```
Run `python manage.py makemigrations finance` — confirm migration file is generated and sane.

### T04.SL2 — Create + revoke views
`ShareTokenCreateView(APIView)` — `IsAuthenticated`:
- Parse `expires_in_days` (clamp to 1–30, default 7)
- Create `ExportShareToken(uid=profile, expires_at=now + timedelta(days=n))`
- Return `{"token": str(token.token), "expires_at": token.expires_at.isoformat()}`

`ShareTokenRevokeView(APIView)` — `IsAuthenticated`:
- GET token by UUID, verify `token.uid == profile` (else 404)
- Set `revoked = True`, save
- Return 204

### T04.SL3 — Public access view
`ShareTokenAccessView(APIView)` — `permission_classes = []` (public):
- Look up `ExportShareToken` by UUID
- If not found, expired (`expires_at < now`), or revoked → 404
- Resolve owning AppProfile → query transactions scoped to that profile
- Return JSON: `{"shared_by": null, "exported_at": ..., "transactions": [...]}`
- **Do not expose** the token owner's username or email in the response
- loguru audit line on every access

### T04.SL4 — URL registration
```python
path("finance/export/share/", ShareTokenCreateView.as_view(), name="share_token_create"),
path("finance/export/share/<uuid:token>/", ShareTokenAccessView.as_view(), name="share_token_access"),
path("finance/export/share/<uuid:token>/revoke/", ShareTokenRevokeView.as_view(), name="share_token_revoke"),
```

### T04.SL5 — Tests
Add to `test_f010_export.py`:
- `test_share_token_create` — POST returns token + expires_at
- `test_share_token_access_valid` — public GET with valid token returns transactions
- `test_share_token_access_expired` — 404
- `test_share_token_access_revoked` — 404 after DELETE
- `test_share_token_cross_user` — user A's token cannot return user B's data
- `test_share_token_revoke_wrong_owner` — user B cannot revoke user A's token (404)

## Notes

- Use `<uuid:token>` path converter — Django validates UUID format before the view runs, returning 404 on malformed tokens automatically
- Return 404 (not 403) on expired/revoked to avoid leaking whether a token ever existed
- No rate limiting on the public access endpoint for beta; note this as a follow-up if sharing sees heavy use
- `shared_by: null` in response is intentional — don't expose owner identity on a public endpoint
