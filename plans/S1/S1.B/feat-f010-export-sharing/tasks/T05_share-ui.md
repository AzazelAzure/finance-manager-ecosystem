# T05 — Share Link UI

## End State

The DataHubPage gains a "Share" panel (below the Export section from T03) where users can generate a time-limited shareable link to their transaction data, copy it to clipboard, see when it expires, and revoke it. The UI degrades gracefully offline (share generation disabled, existing tokens still listed from a cached state if available).

## Acceptance Criteria

1. [V3] "Share Data" section visible in DataHubPage
2. [V3] "Generate share link" button calls `POST /finance/export/share/` and displays the resulting URL
3. [V3] "Copy link" button copies URL to clipboard; shows "Copied!" confirmation
4. [V3] Expiry displayed: "Expires in 7 days" or "Expires Jan 5, 2027"
5. [V3] "Revoke" button calls `DELETE /finance/export/share/{token}/revoke/` and removes the token from UI
6. [V1] When offline: "Generate share link" disabled with "Not available offline" label
7. [V1] i18n keys in `en-US` and `tl-PH` for all new strings
8. [V1] `npm run build` passes with zero errors

## Scope Lock

### Files to modify
- `src/pages/data/DataHubPage.tsx` — add Share section (new isolated block)
- `src/api/lookups.ts` (or equivalent) — add `createShareToken(expiresInDays?)`, `revokeShareToken(token)` functions
- `src/i18n/en-US.json` — add `data.share.*` keys
- `src/i18n/tl-PH.json` — add `data.share.*` keys

### Files NOT to touch
- Export section from T03
- PWA/outbox/service worker
- Any API view

## Slices

### T05.SL1 — API client functions
Add to API layer:
- `createShareToken(expiresInDays?: number): Promise<{ token: string; expires_at: string }>` — POST to `/finance/export/share/`
- `revokeShareToken(token: string): Promise<void>` — DELETE to `/finance/export/share/{token}/revoke/`

### T05.SL2 — Share section component
Add `ShareSection` (inline or extracted component) to `DataHubPage`:
- Local state: `generatedToken: { token: string; expires_at: string } | null`
- "Generate share link" button:
  - Disabled when `!navigator.onLine`
  - On click: call `createShareToken(7)`, set `generatedToken`
  - Loading state while pending
- When `generatedToken` is set:
  - Display full URL: `https://thehivemanager.com/share/{token}` (note: this is a *future* public route — for now display the API URL `https://api.thehivemanager.com/finance/export/share/{token}/`; see Notes)
  - "Copy" button: `navigator.clipboard.writeText(url)`, show "Copied!" for 2s
  - Expiry: format `expires_at` as "Expires [date]" using existing date formatting util
  - "Revoke" button: call `revokeShareToken(token)`, clear `generatedToken`

### T05.SL3 — i18n keys
Add under `data.share` in `en-US.json`:
```
data.share.heading: "Share Data"
data.share.description: "Generate a link anyone can use to view your transactions (no login required)."
data.share.generate: "Generate share link"
data.share.generating: "Generating..."
data.share.copy: "Copy link"
data.share.copied: "Copied!"
data.share.expires: "Expires"
data.share.revoke: "Revoke"
data.share.revoking: "Revoking..."
data.share.offlineDisabled: "Not available offline"
```
Mirror in `tl-PH.json`.

### T05.SL4 — Browser verification
Open `/app/data` in dev:
- Generate link → copy → open in incognito tab → confirm transaction JSON loads (no login)
- Revoke → re-open incognito tab → confirm 404
- Simulate offline → confirm "Generate" button is disabled

## Notes

- For beta, the public share URL points directly to the API endpoint (`/finance/export/share/{token}/`). A proper frontend share viewer page (`/share/{token}`) is a future UI task — noted here but out of scope for this plan.
- Single active token per session (state is local, not persisted across page reloads) is acceptable for beta. A "manage active tokens" list is a future enhancement.
- Do not auto-refresh the token list on page load — the share feature is intentionally ephemeral for v1
