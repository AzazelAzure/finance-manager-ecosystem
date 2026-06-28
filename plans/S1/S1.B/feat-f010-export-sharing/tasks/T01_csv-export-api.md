# T01 — CSV Export API

## End State

A new authenticated endpoint `GET /finance/export/transactions/csv/` returns a CSV file of the requesting user's transactions, scoped to date range params if provided. No other user's data is accessible. The export is logged via loguru.

## Acceptance Criteria

1. [V1] `GET /finance/export/transactions/csv/` with valid JWT returns `Content-Type: text/csv` and `Content-Disposition: attachment; filename=...`
2. [V1] Response includes all Transaction fields: date, amount, currency, source, category, tags (joined), notes, bill name (if linked)
3. [V1] Optional query params `?date_from=YYYY-MM-DD&date_to=YYYY-MM-DD` filter results
4. [V1] Security test: authenticated user A **cannot** receive user B's transactions (uid scoping enforced)
5. [V1] Unauthenticated request → 401
6. [V1] Empty result set → CSV with headers only, 200 (not 404)
7. [V1] loguru `info` line emitted on every successful export: `export_csv user={uid} rows={n} date_from={} date_to={}`
8. [V1] `python manage.py test` suite passes — no regressions

## Scope Lock

### Files to create
- `finance/views/export_views.py` — `TransactionCsvExportView`
- `finance/tests/test_f010_export.py` — tests for T01 (cross-user isolation + download smoke)

### Files to modify
- `finance_api/urls.py` — register `path("finance/export/transactions/csv/", TransactionCsvExportView.as_view(), name="export_tx_csv")`

### Files NOT to touch
- Any existing view or model
- Serializers outside of export_views.py

## Slices

### T01.SL1 — View scaffold
Create `finance/views/export_views.py`:
- `TransactionCsvExportView(APIView)` — `permission_classes = [IsAuthenticated]`
- Resolve `AppProfile` by `request.user` → filter `Transaction.objects.filter(uid=profile)`
- Apply date filters if `date_from` / `date_to` in query params (validate format; return 400 on invalid)
- Build CSV in-memory with `csv.writer` on `io.StringIO`; stream as `StreamingHttpResponse` (content type `text/csv`)
- Column order: `date, amount, currency, source, category, tags, notes, bill`
- Tags: join with `|` separator
- loguru audit line on success

### T01.SL2 — URL registration
Add to `finance_api/urls.py` imports + urlpatterns. Run `python manage.py check` — zero errors.

### T01.SL3 — Tests
`finance/tests/test_f010_export.py`:
- `test_csv_download_own_data` — auth'd GET returns 200, csv content-type, expected headers in row 0
- `test_csv_cross_user_isolation` — create user A and user B with transactions; authenticate as A; assert B's transactions not in response body
- `test_csv_date_filter` — transactions outside range not included
- `test_csv_unauthenticated` — 401
- `test_csv_empty` — 200, headers-only CSV

## Notes

- Use `StreamingHttpResponse` over `HttpResponse` so large accounts don't buffer the full dataset in memory
- Tag join delimiter `|` chosen to avoid CSV quoting issues with commas
- Column headers must be plain English (not model field names): "Date", "Amount", "Currency", "Source", "Category", "Tags", "Notes", "Linked Bill"
- Date filter params are inclusive on both ends
