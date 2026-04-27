# PLAN_Reflex_Cookie_Consent_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Cookie_Consent`
- Owner: Gemini (Agent)
- Status: `ready_for_execution`
- Target: `finance_manager_reflex` (UI/UX)

## 1) Objective
Implement a professional cookie consent banner to inform users about the use of essential cookies (for authentication) and state explicitly that no personal information (PII) is stored in them.

## 2) Scope
- Creating a reusable `cookie_banner` component.
- Managing the "consent accepted" state in the browser.

## 3) Execution Breakdown

### Task T1: Cookie Banner Component
- **Goal:** Create a non-intrusive, "Living Design" compliant banner.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/ui/primitives.py`.
- **Implementation notes:** 
    - Design: A glassmorphic banner (`glass_box`) at the bottom of the screen.
    - Text: "We use essential cookies to keep you logged in. No personal information is stored. [Accept]"
    - The "Accept" button should set a local state variable `State.cookie_consent_accepted` to `True`.

### Task T2: Global Visibility
- **Goal:** Show the banner only if consent hasn't been given.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/app/shell.py`.
- **Implementation notes:** 
    - Add the `cookie_banner()` to the bottom of the main layout.
    - Wrap it in `rx.cond(~State.cookie_consent_accepted, ...)` so it disappears once accepted.
    - Use `rx.LocalStorage` to persist the consent so it doesn't reappear on every refresh.

## 4) Verification
- Open the site in a new incognito window: Verify the banner appears.
- Click Accept: Verify the banner disappears and does not return on page refresh.
