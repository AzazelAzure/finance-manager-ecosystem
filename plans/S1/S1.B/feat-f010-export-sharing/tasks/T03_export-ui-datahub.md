# T03 — Export UI (DataHubPage)

## End State

The existing `/app/data` DataHubPage gains an "Export" section with controls to download a CSV (date-filtered) or a full JSON backup. Both buttons are disabled with an explanatory message when the app detects the user is offline.

## Acceptance Criteria

1. [V3] "Export" section renders in DataHubPage beneath the existing data-management sections
2. [V3] "Download CSV" button calls `GET /finance/export/transactions/csv/` and triggers a file download in browser
3. [V3] Date range inputs (optional) filter the CSV — empty = all time
4. [V3] "Download Full Backup (JSON)" button calls `GET /finance/export/full/` and triggers a file download
5. [V1] When offline (navigator.onLine === false or outbox is active): both buttons are disabled; label changes to "Export not available offline"
6. [V1] i18n keys exist in both `en-US` and `tl-PH` for all new UI strings
7. [V1] `npm run build` passes with zero errors
8. [V1] No new lint errors introduced

## Scope Lock

### Files to modify
- `src/pages/data/DataHubPage.tsx` — add Export section (new JSX block only; do not reorganize existing sections)
- `src/api/lookups.ts` (or equivalent API layer) — add `downloadCsvExport(dateFrom?, dateTo?)` and `downloadFullBackup()` functions
- `src/i18n/en-US.json` — add `data.export.*` keys
- `src/i18n/tl-PH.json` — add `data.export.*` keys

### Files NOT to touch
- DataHubPage business logic for categories/tags/sources — isolated to new JSX block
- PWA service worker or outbox logic — read offline state only, do not modify it

## Slices

### T03.SL1 — API client functions
In the API layer, add two functions:
- `downloadCsvExport(dateFrom?: string, dateTo?: string): Promise<void>` — calls the CSV endpoint, receives blob, triggers `URL.createObjectURL` download with filename `hfm_transactions_YYYYMMDD.csv`
- `downloadFullBackup(): Promise<void>` — calls the JSON endpoint, triggers download with filename `hfm_backup_YYYYMMDD.json`
Both functions use the existing axios instance (with JWT interceptor).

### T03.SL2 — Export section in DataHubPage
Add a new `ExportSection` component or inline block at the bottom of `DataHubPage`:
- Date range inputs: `date_from`, `date_to` (type=date inputs, both optional)
- "Download CSV" button — calls `downloadCsvExport(dateFrom, dateTo)` 
- "Download Full Backup" button — calls `downloadFullBackup()`
- Both buttons: `disabled` when `!navigator.onLine`; tooltip/label "Export not available offline" when disabled
- Loading state per button (spinning or disabled) while fetch is in progress

### T03.SL3 — i18n keys
Add to `en-US.json` under `data.export`:
```
data.export.heading: "Export Data"
data.export.dateFrom: "From"
data.export.dateTo: "To"
data.export.downloadCsv: "Download CSV"
data.export.downloadBackup: "Download Full Backup"
data.export.offlineDisabled: "Export not available offline"
data.export.csvDownloading: "Preparing CSV..."
data.export.backupDownloading: "Preparing backup..."
```
Mirror in `tl-PH.json` (Tagalog equivalents or English with `// TODO tl-PH` comment if unsure).

### T03.SL4 — Browser verification
Open `/app/data` in dev server. Confirm:
- Export section visible
- CSV download triggers a real file download with correct filename
- JSON backup triggers a real file download
- Simulate offline (DevTools → Network → Offline): both buttons disabled with offline label

## Notes

- Trigger download via `<a href={objectUrl} download={filename}>` click pattern — do not rely on `Content-Disposition` alone, as browser handling varies
- Revoke the object URL after click (`URL.revokeObjectURL`) to avoid memory leak
- Do not add `pwaReadBypass` to the export calls — export is an online-only action by design
