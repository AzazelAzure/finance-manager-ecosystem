# Runtime Handoff — F-010 Export & Sharing

## Closeout — 2026-06-28

- Runtime owner: `Cursor (F-010 export-sharing closeout)`
- Runtime mode: `containerized` (VPS blue-green, `fm-beta`)
- Final active color: `green`
- Previous active color retained for rollback: `blue`

## What Shipped

- API `main`: CSV export, full JSON backup, share token model/API, migration `0015_export_share_token_f010`.
- Web `main`: Data Hub export controls and share link panel with PWA/offline guards.
- Share-token audit logs redact bearer tokens to a short prefix instead of logging the full reusable token.

## Validation

- API landing PR: `API CI / test` passed.
- Web landing PR: `Web CI / ci` passed.
- Local API: `uv run python manage.py check`; `uv run python manage.py test finance.tests.test_f010_export`.
- Local Web: `npm run build`.
- VPS inactive green:
  - Rebuilt API/Web/celery with `scripts/sprint_verify.sh --color green --branch main --repos api,web --smoke --smoke-color inactive --no-cache`.
  - Evidence: `plans/S1/S1.B/feat-f010-export-sharing/evidence/sprint_verify_20260628T042241Z.log`.
  - `0015_export_share_token_f010` verified applied.
- Post-switch public origin smokes:
  - `GET /api/health/` -> `200`
  - `GET /finance/export/transactions/csv/` unauthenticated -> `401`
  - `GET /finance/export/full/` unauthenticated -> `401`
  - `GET /finance/export/share/00000000-0000-0000-0000-000000000000/` -> `404`
  - `GET /app/data` -> `200`

## Rollback

- Use `./scripts/fm_server_beta.sh rollback` on the VPS to switch active color back to blue.
- Migration `0015` is additive (`ExportShareToken` table). Rolling back traffic to blue is safe; the table can remain until a deliberate DB rollback plan exists.

## Residual Manual Checks

- Optional: sign in through the UI, download CSV/JSON, and open the files in LibreOffice/Sheets.
- Optional: generate a share link, open it anonymously, revoke it, and confirm subsequent `404`.
