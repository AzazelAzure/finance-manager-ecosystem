# PLAN_Reflex_Living_Primitives_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_Reflex_Living_Primitives_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P0`
- Target repos/areas: `finance_manager_reflex` (UI/Primitives)

## 1) Objective
Enhance the core UI primitives to transition from a "flat" professional look to a "Living and Human" design system. This focuses on depth (layering), motion (physics-based transitions), and tactile feedback (interactive states).

## 2) Scope
### In scope
- Updating design tokens for multi-layered shadows and brand-aware glows.
- Enhancing `surface_card` with lifting and glowing effects.
- Creating a `living_button` primitive with tactile press feedback.
- Updating `glass_box` with refined backdrop blurs and subtle borders.
- Standardizing transition easing across all primitives.

### Out of scope
- Implementation of full feature pages (handled in subsequent plans).
- API or data-fetching changes.

## 3) Inputs / Source Docs
- `finance_manager_reflex/finance_manager_reflex/ui/tokens.py`
- `finance_manager_reflex/finance_manager_reflex/ui/primitives.py`
- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails
- Adhere to Rule #3 (Keep `primitives.py` under 500 lines).
- Adhere to Rule #10 (Fix it forever - ensure transitions are standardized, not ad-hoc).
- Use Radix UI / Reflex best practices for motion.

## 5) Execution Breakdown

### Task T1: Shadow & Glow Tokens
- **Goal:** Add multi-layered shadows and brand glow tokens.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/ui/tokens.py`
- **Design Fidelity:** Provides the "material" for depth.
- **Implementation notes:** Add `SHADOW_TOKENS["glow"]` and `SHADOW_TOKENS["deep"]`.
- **Acceptance criteria:** New tokens available for use.

### Task T2: Tactile Button Primitives
- **Goal:** Update `primary_button` and `secondary_button` with press feedback and standard easing.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/ui/primitives.py`
- **Design Fidelity:** Makes the app feel "Human" and responsive to touch/clicks.
- **Implementation notes:** Add `_active={"transform": "scale(0.98)"}` and standardized `transition`.
- **Acceptance criteria:** Buttons scale slightly when clicked.

### Task T3: The "Lifting Glow" Card
- **Goal:** Enhance `surface_card` to lift and emit a subtle aura on hover.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/ui/primitives.py`
- **Design Fidelity:** Adds "living" character to dashboard modules.
- **Implementation notes:** Update `_hover` to include a brand-colored box-shadow (glow) and a more pronounced `translateY`.
- **Acceptance criteria:** Cards feel like they are floating up when hovered.

### Task T4: Refined Material Glass
- **Goal:** Update `glass_box` with multi-layered backdrop blurs.
- **Files to edit:** `finance_manager_reflex/finance_manager_reflex/ui/primitives.py`
- **Design Fidelity:** Increases "Premium" feel through sophisticated transparency.
- **Implementation notes:** Adjust `backdrop_filter` and border opacity.

## 6) Verification Plan
- **Design Audit:** Run the Reflex app and manually verify that buttons "press" and cards "glow/lift."
- **Lint Check:** Ensure no syntax errors in UI files.

## 7) Documentation & Feature Tracking
- [ ] Update `finance_manager_reflex/CHANGELOG.md` with "Living Primitives" implementation.
- [ ] Tag as "Phase 2: UI Modernization" in roadmap if applicable.
