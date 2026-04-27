# Gemini Plan Template V2 (Collaboration & Living Design)

## 0) Metadata
- Plan ID: `PLAN_Reflex_Transactions_Enhancements_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P1`
- Target repos/areas: reflex

## 1) Objective
Improve Transactions page UX/UI, resolve the Decimal serialization bug, and implement robust dual-field inputs for categories and tags.

## 2) Scope
### In scope
- Removing "Guide" button.
- Fixing Quick entry Decimal serialization error.
- Upgrading inputs (Currency ALL CAPS, TX type dropdown, Description, Tags fields).
- Dual-field Category input (custom entry vs dropdown).
- Multiple entry tag system.
- Case-insensitive dropdown filters.
- Adding field labels in Quick Entry.
### Out of scope
- Modifying backend category model beyond handling incoming strings/IDs.

## 3) Inputs / Source Docs
- `design_docs/00_Coding_Guidelines.md`
- `finance_manager_reflex/CHANGELOG.md`

## 4) Constraints & Guardrails (The 11 Golden Rules)
- **Root Cause Resolution:** Fully identify why the `Decimal` type is leaking into JSON serialization and fix the type handling permanently.
- **UX/UI Polish:** Create intuitive custom entry flows for tags and categories.

## 5) Execution Breakdown

### Task T1: UI Cleanup & Enhancements
- **Goal:** Remove Guide button, enforce ALL CAPS currency, add TX Type Dropdown ("Expense, Income, Transfer"), add labels above Quick Entry fields, and add Description/Tags fields.
- **Files to edit:** Transactions page components.

### Task T2: Quick Entry Serialization Fix
- **Goal:** Resolve "Decimal type is not JSON serializable" JS error when pushing transactions.
- **Files to edit:** Transactions state, API interaction layer.

### Task T3: Category Dual-Field & Tag System
- **Goal:** Implement custom category creation logic (secondary API add before transaction send). Implement multi-entry tag system (list with 'x' to delete, add field).
- **Files to edit:** Transactions UI, state.

### Task T4: Filter System Enhancements
- **Goal:** Convert search filters to case-insensitive dropdowns for existing data.
- **Files to edit:** Transactions filters, state.

## 6) Subagent Request Protocol
- Subagent type: `generalPurpose`
- Purpose: Overhaul transactions page inputs and fix bugs.
- Mode: `write`
- Completion criteria: Transactions push successfully; tags/categories work; filters are intuitive.
