---
task_id: T03
status: completed
owner: pproctor
phase: S1.B
intended_branch: agy/s1b/feat/infra-support-intake
last_verification: null
---

# T03 — Frontend Support Navigation & Page

## Objective
Add Lucide icons, add Support route/link to the sidebar, define routing, create the Support page with tabbed Bug Report and Feature Request forms, bind forms with React Hook Form & Axios, implement feature request gating, and include translations.

## Repo scope
- `finance_manager_web/`

## Decomposed Slices
- **T03.SL1: Sidebar Navigation and Route setup**
  - Add Lucide icon (e.g. `HelpCircle` or `LifeBuoy`) for the Support link.
  - Link the icon in the sidebar UI components.
  - Set up path `/support` in frontend router configuration (`src/routes.tsx` or similar).
- **T03.SL2: i18n Translation Keys**
  - Add translation keys for Support header, tabs, labels (subject, description, metadata), validation error messages, and success status to translations files (e.g. `src/locales/`).
- **T03.SL3: SupportPage React Component with Bug/Feature Tabs**
  - Create `SupportPage.tsx` with layout, header, and tab switcher ("Report Bug", "Request Feature").
- **T03.SL4: React Hook Form & Axios submission**
  - Integrate React Hook Form for inputs with fields validation (subject max 150 chars, description min 10 chars).
  - Use Axios client to POST form payloads to `/finance/support/tickets/`.
  - Capture and append metadata (browser, OS, viewport size) to the API payload.
  - Show success alerts and handle API error responses.
- **T03.SL5: Gated Feature Tab check**
  - Retrieve current user's profile context (`feature_requests_enabled` boolean).
  - Hide or disable the "Request Feature" tab if the user is not beta-enabled for feature requests.

## Definition of Done
- Navigation item present and routes to `/support`.
- Form validation behaves correctly on invalid/empty data.
- UI checks profile data to show/hide "Request Feature" tab.
- API submissions successfully trigger POST requests to the backend endpoint.
- All translation keys are fully configured.

## Verification Tiers
- **V1 (Local tests)**: Run client test suite (jest/vitest if configured).
- **V3 (Visual/Manual Check)**: Validate visually in local browser at http://localhost:5173/support (or equivalent local Vite port).

## Risks
- Route accessibility before login (must require authentication).
- Unhandled API errors for requests from unauthorized users.
