# Gemini Plan Template V2 (Collaboration & Living Design)

## 0) Metadata
- Plan ID: `PLAN_Reflex_Splash_Login_Flow_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P2`
- Target repos/areas: reflex

## 1) Objective
Refactor splash page login logic to check token and redirect only upon user pressing the Log In button, restoring the visibility of the Splash page on load.

## 2) Scope
### In scope
- Modifying Splash page lifecycle hooks or initial load state.
- Updating Login button `on_click` logic to verify cookies/token before redirecting.
### Out of scope
- Changing the authentication API itself.

## 3) Inputs / Source Docs
- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails (The 11 Golden Rules)
- **Readability:** Ensure state logic separates page load from user interaction cleanly.

## 5) Execution Breakdown

### Task T1: Refactor Login Button Logic
- **Goal:** Stop auto-redirecting to dashboard on load. Instead, wait for the Log In button press, check cookie/token status, and then proceed directly to the dashboard if valid.
- **Files to edit:** Splash page UI component, authentication state.
- **Design Fidelity:** Ensure the button provides immediate feedback (spinner or state change) while checking the token.

## 6) Subagent Request Protocol
- Subagent type: `generalPurpose`
- Purpose: Fix Splash page auto-redirect behavior.
- Mode: `write`
- Completion criteria: Splash page loads fully; login button handles the token check and redirect.
