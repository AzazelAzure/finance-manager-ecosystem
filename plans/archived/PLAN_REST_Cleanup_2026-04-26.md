# PLAN_REST_Cleanup_2026-04-26

- Plan ID: `PLAN_REST_Cleanup_2026-04-26`
- Owner: Orchestrator (Antigravity)
- Status: `ready_for_execution`
- Target areas: (api)

## 1) Objective
Split combined API views into standard List/Detail views to resolve operationId collisions and fix the `bill` validation error.

## 2) Execution Breakdown

### Task T1: Fix `bill` Validation
- **Goal:** Allow blank/null for the `bill` field in serializers.
- **Files to edit:**
    - `finance_manager_api/finance/api_tools/serializers/tx_serializers.py`
- **Implementation notes:** Add `allow_blank=True, allow_null=True` to `bill` in `TransactionSetSerializer` and `TransactionGetSerializer`.
- **Verification commands:** `cd finance_manager_api && . .venv/bin/activate && python manage.py spectacular --file schema.yml`

### Task T2: Split Transaction Views
- **Goal:** Split `TransactionView` into `TransactionListCreateView` and `TransactionDetailView`.
- **Files to edit:**
    - `finance_manager_api/finance/views/tx_views.py`
- **Implementation notes:** 
    - Create two classes.
    - Move `@extend_schema_view` logic to individual methods or split decorators.
    - Ensure unique `operation_id` for each method.
- **Verification commands:** `cd finance_manager_api && . .venv/bin/activate && python manage.py spectacular --file schema.yml`

### Task T3: Split Profile Views
- **Goal:** Split `AppProfileView` into `AppProfileView` and `AppProfileSnapshotView`.
- **Files to edit:**
    - `finance_manager_api/finance/views/profile_views.py`
- **Implementation notes:** Similar to T2.
- **Verification commands:** `cd finance_manager_api && . .venv/bin/activate && python manage.py spectacular --file schema.yml`

### Task T4: Update URL Mapping
- **Goal:** Update `urls.py` to use the new split views.
- **Files to edit:**
    - `finance_manager_api/finance_api/urls.py`
- **Implementation notes:** Point paths to the correct new view classes.
- **Verification commands:** `cd finance_manager_api && . .venv/bin/activate && python manage.py spectacular --file schema.yml`

## 3) Completion Criteria
- Zero `operationId` collisions in `drf-spectacular` output.
- `bill` field accepts empty strings.
- API remains operational.
