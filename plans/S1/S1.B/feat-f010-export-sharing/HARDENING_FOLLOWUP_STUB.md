# F-010 Share Hardening — Follow-up Stub (NOT STARTED)

**Status:** `draft` — do not implement until HitM explicitly re-authorizes sharing.  
**Trigger:** Product decision to restore share-after-export with privacy controls.  
**Predecessor:** `strategy/audits/2026-06-29_share-link-exposure_rca.md`

## Minimum bar if revived

1. **No raw API URLs in clipboard** — web viewer at `/share/{token}` (public route, read-only).
2. **Scoped payload** — date range + optional field mask; default ≠ full history.
3. **Short TTL** — default 24h; max 7d; one-time view option.
4. **Explicit consent** — modal: "Anyone with this link can see [scope] until [time]."
5. **Rate limiting** on public access endpoint.
6. **Access notification** — log + optional email on first fetch.
7. **DoD privacy gate** + security review before merge.

## Out of scope for stub

- PDF export
- Cross-household multi-user accounts
