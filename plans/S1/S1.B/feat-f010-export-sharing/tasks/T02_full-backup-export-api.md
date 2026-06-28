# T02 — Full Backup Export API (JSON)

## End State

A new authenticated endpoint `GET /finance/export/full/` returns a structured JSON backup of the requesting user's complete dataset: profile, sources, categories, tags, transactions, and upcoming expenses. The file is download-prompted (Content-Disposition attachment). Scoped strictly to the requesting user.

## Acceptance Criteria

1. [V1] `GET /finance/export/full/` with valid JWT returns `Content-Type: application/json` and `Content-Disposition: attachment; filename=hfm_backup_YYYYMMDD.json`
2. [V1] Response JSON structure:
   ```json
   {
     "export_version": "1",
     "exported_at": "<ISO timestamp>",
     "profile": { ... },
     "sources": [ ... ],
     "categories": [ ... ],
     "tags": [ ... ],
     "transactions": [ ... ],
     "upcoming_expenses": [ ... ]
   }
   ```
3. [V1] Security test: user A cannot receive any of user B's records across all collections
4. [V1] Unauthenticated → 401
5. [V1] loguru `info` line: `export_full_backup user={uid} tx_count={} src_count={} ue_count={}`
6. [V1] `python manage.py test` passes

## Scope Lock

### Files to modify
- `finance/views/export_views.py` — add `FullBackupExportView` to existing file from T01
- `finance_api/urls.py` — register `path("finance/export/full/", FullBackupExportView.as_view(), name="export_full_backup")`

### Files NOT to touch
- Existing models, serializers, or views outside export_views.py
- T01's `TransactionCsvExportView` — do not refactor it during T02

## Slices

### T02.SL1 — FullBackupExportView
Add `FullBackupExportView(APIView)` to `finance/views/export_views.py`:
- Resolve profile by `request.user`
- Query all 6 collections, all fields, scoped by `uid=profile`
- Serialize to plain dicts (use `.values()` or manual dict — no new DRF serializers required unless one already exists and fits)
- Return `HttpResponse(json.dumps(payload, default=str), content_type='application/json')` with `Content-Disposition` header
- `export_version: "1"` — increment this if the schema changes in a future plan

### T02.SL2 — URL registration
Add import + path to `finance_api/urls.py`. `python manage.py check` — zero errors.

### T02.SL3 — Tests
Add to `finance/tests/test_f010_export.py`:
- `test_full_backup_structure` — keys match spec; `export_version == "1"`
- `test_full_backup_cross_user_isolation` — user A's backup contains zero of user B's records in every collection
- `test_full_backup_unauthenticated` — 401

## Notes

- `default=str` on `json.dumps` handles Decimal, datetime, UUID without a custom encoder
- Do not include `password`, `email`, or any auth tokens in the profile block — include only finance-relevant profile fields (currency, pay_period, STS fields)
- `export_version` allows future import tooling to know the schema; start at `"1"` and treat it as a string not an int
