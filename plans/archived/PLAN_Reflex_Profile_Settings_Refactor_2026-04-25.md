# Gemini Plan Template V2 (Collaboration & Living Design)

## 0) Metadata
- Plan ID: `PLAN_Reflex_Profile_Settings_Refactor_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P2`
- Target repos/areas: reflex

## 1) Objective
Streamline the Profile Settings page to act strictly as a user preference and security configuration hub, removing all data rollups.

## 2) Scope
### In scope
- Removing Snapshot rollup and monthly transactions views from Profile Settings.
- Retaining: spend accounts, base currency, timezone, start of week, password change, account deletion.
### Out of scope
- Dashboard implementations of the removed widgets (handled in Dashboard plan).

## 3) Inputs / Source Docs
- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails
- **Separation of Concerns:** Ensure the page remains purely for settings, migrating logic cleanly to the Dashboard.

## 5) Execution Breakdown

### Task T1: UI Cleanup & Migration Prep
- **Goal:** Strip out Snapshot rollups and monthly transaction displays from the Profile page. Ensure the remaining UI is clean, focused, and centered around account/preference editing.
- **Files to edit:** Profile Settings UI, state.

## 6) Subagent Request Protocol
- Subagent type: `generalPurpose`
- Purpose: Clean up Profile Settings page.
- Mode: `write`
- Completion criteria: Page only displays settings/account management fields.
