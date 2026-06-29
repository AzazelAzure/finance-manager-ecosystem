# T04 — Optional Mobile / Desktop Layout Variants

## End State

Users can have separate layouts per device class (mobile vs desktop), persisted independently, so
the STS-first mobile persona gets a layout tuned for small screens without disturbing desktop.

## Acceptance Criteria

1. [V1] Layout persistence is keyed by device class (e.g. `mobile` | `desktop`), extending the T01 model without breaking existing single-layout rows (migration-safe; existing layout becomes the desktop/default variant).
2. [V1] The dashboard loads the variant matching the current breakpoint; editing one variant does not change the other.
3. [V1] A user who never customizes mobile gets a sensible mobile default (STS-first ordering per plan §0), not the raw desktop order squeezed.
4. [V1] Switching device class (resize across breakpoint, or open on a phone) loads the right variant without a full reload.
5. [V1] Tests/Acceptance: variant isolation (editing mobile leaves desktop intact) and the migration-safe upgrade of pre-existing single layouts.

## Scope Lock

### Files to modify
- `finance_manager_api/finance/models.py` + migration (device-class key)
- layout serializer/endpoint (variant param)
- `DashboardPage.tsx` / layout loader (breakpoint → variant)

### Files NOT to touch
- Widget internals; catalog (consume T02)

## Slices

### T04.SL1 — API device-variant keying
Extend the layout key to include device class; migrate existing rows to `desktop`. Endpoint accepts/returns the variant.

### T04.SL2 — Breakpoint-aware load + mobile default
Client loads the variant for the active breakpoint; define the STS-first mobile default layout.

### T04.SL3 — Tests
Variant isolation; migration-safety for pre-existing single layouts.

## Notes

- This task is **optional polish** (plan §1 "optional separate layouts") — if credit/time is tight it can ship after T01–T03 as a follow-up. Flag to HitM if descoping.
- Mobile default should reflect the wedge: STS / upcoming-survival surfaces first (plan §0 "STS-first layout for mobile persona").
- Keep variants to two classes (mobile/desktop) for v1 — no per-device-pixel layouts.
