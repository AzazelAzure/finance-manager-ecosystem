# PLAN_Stability_Patch_2026-04-26

- Plan ID: `PLAN_Stability_Patch_2026-04-26`
- Owner: Orchestrator (Antigravity)
- Status: `ready_for_execution`
- Target areas: (api / reflex)

## 1) Objective
Stabilize the API schema to remove `drf-spectacular` collisions and fix Reflex state type mismatch errors.

## 2) Execution Breakdown

### Task T1: API Global Schema Fix
- **Goal:** Resolve `TokenRefresh` component collision.
- **Files to edit:**
    - `finance_manager_api/finance_api/settings.py`
- **Implementation notes:** Add `SPECTACULAR_SETTINGS` with `COMPONENT_SPLIT_PATCH=True`, `COMPONENT_SPLIT_REQUEST=True`, and an override for the `TokenRefresh` collision if needed.
- **Verification commands:** `cd finance_manager_api && python manage.py spectacular --file schema.yml`

### Task T2: Reflex State Type Fidelity
- **Goal:** Fix `AgentDashState` receiving dicts instead of model instances.
- **Files to edit:**
    - `finance_manager_reflex/finance_manager_reflex/features/agentdash/state_load.py`
- **Implementation notes:** Remove `.model_dump()` from assignments to `self.kpis`, `self.spend_series`, etc.
- **Verification commands:** `reflex export` (smoke test for state compilation)

### Task T3: Transaction View Schema Stabilization
- **Goal:** Fix "unable to guess serializer" and "operationId collisions" for Transactions.
- **Files to edit:**
    - `finance_manager_api/finance/views/tx_views.py`
- **Implementation notes:** 
    - Add `serializer_class = TransactionSetSerializer` to `TransactionView`.
    - Add unique `operation_id` to each method in `@extend_schema`.
- **Verification commands:** `cd finance_manager_api && python manage.py spectacular --file schema.yml`

### Task T4: Resource Views Schema Stabilization
- **Goal:** Fix collisions for Categories, Sources, and Expenses.
- **Files to edit:**
    - `finance_manager_api/finance/views/cat_views.py`
    - `finance_manager_api/finance/views/src_views.py`
    - `finance_manager_api/finance/views/exp_views.py`
- **Implementation notes:** Add `serializer_class` and unique `operation_id`s to all views.
- **Verification commands:** `cd finance_manager_api && python manage.py spectacular --file schema.yml`

## 3) Completion Criteria
- No warnings from `spectacular` regarding collisions or guessed serializers.
- Reflex dashboard loads without "Expected field ... to receive type" errors in logs.
