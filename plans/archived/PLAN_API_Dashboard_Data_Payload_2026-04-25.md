# PLAN_API_Dashboard_Data_Payload_2026-04-25

## 0) Metadata
- Plan ID: `PLAN_API_Dashboard_Data_Payload_2026-04-25`
- Owner: Gemini (Agent)
- Requested by: User
- Status: `ready_for_execution`
- Priority: `P1`
- Target repos/areas: `finance_manager_api` (Services/Serializers)

## 1) Objective
Augment the existing API dashboard payload (returned via `AppProfileView.get(snapshot=True)`) to include precise `source_balances` and ensure `flow_series` and `expense_by_category` data structures align perfectly with frontend charting requirements.

## 2) Scope
### In scope
- Updating `user_services.user_get_totals` to fetch and calculate live balances for all `PaymentSource` records associated with the user.
- Adding `source_balances` to the `SnapshotSerializer`.
- Validating that `flow_series` returns data in a format immediately consumable by Recharts/Reflex charts.

### Out of scope
- Frontend UI modifications (handled in Reflex plan).
- Creating new API views.

## 3) Inputs / Source Docs
- `finance_manager_api/finance/services/user_services.py`
- `finance_manager_api/finance/api_tools/serializers/profile_serializers.py`
- `design_docs/00_Coding_Guidelines.md`

## 4) Constraints & Guardrails
- **Rule #6 (DB Hits):** Fetching source balances should be optimized (e.g., aggregating transactions by source in a single query if possible) rather than querying each source individually in a loop.
- **Rule #10 (Fix it Forever):** Expose all necessary aggregated data via this single payload to prevent the frontend from having to do complex low-level math or make repeated API calls.

## 5) Execution Breakdown

### Task T1: Source Balances Calculation
- **Goal:** Calculate current balance for each payment source.
- **Files to edit:** `finance_manager_api/finance/services/user_services.py`.
- **Implementation notes:** 
    - In `user_get_totals`, query the user's `PaymentSource`s and their associated transactions.
    - Calculate the net balance per source.
    - Add a `source_balances` dictionary or list of dictionaries (e.g., `[{"source": "Checking", "balance": 1500.00}, ...]`) to the return dict.

### Task T2: Serializer Update
- **Goal:** Expose the new data through the API schema.
- **Files to edit:** `finance_manager_api/finance/api_tools/serializers/profile_serializers.py`.
- **Implementation notes:** 
    - Add `source_balances = serializers.ListField(child=serializers.DictField(), required=False)` to `SnapshotSerializer`.

## 6) Verification Plan
- Unit tests: Verify `user_get_totals` returns accurate `source_balances`.
- API verification: Access `/api/profile/?snapshot=true` via Swagger or cURL and verify the payload contains populated arrays for `flow_series`, `expense_by_category`, and `source_balances`.

## 7) Documentation & Feature Tracking
- [ ] Update `CHANGELOG.md` for API.
- [ ] Move plan to `plans/archived/` upon completion.
