# Hive Mission Plan: Reflex UI Fixes

This plan addresses the UI modernization bugs and backend schema warnings reported.

### Task T1: Resolve JWT Schema Warnings
- **Goal:** Fix drf_spectacular warnings about identical component names for TokenRefreshRequest by subclassing and renaming SimpleJWT serializers in the API URLs configuration.
- **Files to edit:** 
  - finance_manager_api/finance_api/urls.py
- **Implementation notes:** 
  - Import `extend_schema_serializer` from `drf_spectacular.utils`.
  - Create a `CustomTokenRefreshSerializer` that inherits from `TokenRefreshSerializer` and decorates it with `@extend_schema_serializer(component_name="SimpleJWTTokenRefresh")`.
  - Create a `CustomTokenRefreshView` that inherits from `TokenRefreshView` and sets `serializer_class = CustomTokenRefreshSerializer`.
  - Update `urlpatterns` to use `CustomTokenRefreshView.as_view()` for `api/token/refresh/` and `api/token/verify/` instead of `TokenRefreshView`.
- **Verification commands:** cd finance_manager_api && python manage.py spectacular --file schema.yml

### Task T2: Fix Reflex Recharts Series Population
- **Goal:** Ensure flow, spend, and category widgets populate by fixing data type serialization. Reflex Recharts silently fails when it receives Decimal objects instead of floats.
- **Files to edit:**
  - finance_manager_reflex/finance_manager_reflex/features/agentdash/models.py
  - finance_manager_reflex/finance_manager_reflex/features/agentdash/mappers.py
- **Implementation notes:**
  - In `models.py`, change `value` in `DashboardChartPoint` and `DashboardCategoryPoint` to `float`. Change `incoming`, `outgoing`, `leaks` in `DashboardFlowPoint` to `float`. Replace `Decimal("0")` defaults with `0.0`. Do NOT import Decimal if not needed, but keep it if other classes need it.
  - In `mappers.py`, whenever creating these points, wrap the Decimal values returned by `coerce_decimal` in `float()`. For example, `float(amount)` or `float(incoming or Decimal("0"))`. Do this for `build_spend_series`, `build_income_series`, `build_category_series`, and `build_flow_series`.
- **Verification commands:** 

### Task T3: Standardize Transaction Table and Enlarge Dashboard Widget
- **Goal:** Use standard_data_table primitive in the transactions feature to maintain consistent formatting. Enlarge the dashboard transaction widget.
- **Files to edit:**
  - finance_manager_reflex/finance_manager_reflex/features/transactions/view_components.py
  - finance_manager_reflex/finance_manager_reflex/features/agentdash/view_components.py
- **Implementation notes:**
  - In `finance_manager_reflex/finance_manager_reflex/features/transactions/view_components.py`, import `standard_data_table` from `finance_manager_reflex.ui`.
  - Refactor `transactions_table()` to use `standard_data_table` instead of `rx.table.root` and `rx.table.header` manually. Maintain the same table body and cell contents. Note that `standard_data_table` takes `headers` and `rows`.
  - In `finance_manager_reflex/finance_manager_reflex/features/agentdash/view_components.py`, in `recent_transactions()`, change `style={"height": "400px"}` to `style={"height": "600px"}` to fully display data.
- **Verification commands:** 
