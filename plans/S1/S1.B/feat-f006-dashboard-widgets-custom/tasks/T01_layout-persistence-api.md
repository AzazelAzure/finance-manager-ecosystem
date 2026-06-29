# T01 — Dashboard Layout Persistence Model + API

## End State

A per-user dashboard layout is persisted server-side (with a documented cache fallback for PWA
offline reads). The API returns a default layout for users who have never customized, and exposes
a reset path.

## Acceptance Criteria

1. [V1] `DashboardLayout` model: `uid` FK/index (one row per user, or per user+device — see T04), `layout` JSONField (ordered list of `{widget_id, size, visible}`), `updated_at`. Migration included.
2. [V1] CRUD endpoint at `finance/dashboard-layout/`: GET returns the user's layout (or the server default if none), PUT/PATCH upserts it, with validation that `widget_id`s are in the known catalog (T02) and `size` is an allowed tier.
3. [V1] Default layout constant defined server-side and returned when the user has no saved layout (so the dashboard is never empty).
4. [V1] Reset endpoint/action restores the default layout (rollback path per plan §10 risk).
5. [V1] Cross-user isolation test: user A cannot read/write user B's layout.
6. [V1] PWA offline read path documented: layout is server-backed; the client caches the last layout for offline render (read-only offline; edits are online-only and follow the offline guard).

## Scope Lock

### Files to modify / create
- `finance_manager_api/finance/models.py` — `DashboardLayout`
- `finance_manager_api/finance/serializers.py`, `views/...`, `urls`
- migration

### Files NOT to touch
- Web (T02–T04); widget components themselves

## Slices

### T01.SL1 — Model + migration
`DashboardLayout` keyed by user. Keep `layout` a validated JSON blob (bounded — plan §0 cost cap).

### T01.SL2 — Endpoint + default + reset
GET (with default fallback), PUT/PATCH upsert, reset action; catalog/size validation.

### T01.SL3 — Tests
Isolation, default fallback, reset, invalid widget_id rejection.

## Notes

- **Server-backed with cache fallback** is the locked approach (README deployment note). Don't make layout local-only — it must survive device changes.
- Keep the layout schema forward-compatible: unknown widget_ids on read are ignored gracefully (a removed widget shouldn't break the dashboard).
- Device-variant keying (mobile vs desktop) is **T04** — design the key so it can extend without a second migration if practical.
