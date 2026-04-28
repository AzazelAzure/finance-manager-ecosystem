from finance_manager_reflex.features.agentdash.mappers import map_to_view_model
import json

profile_payload = {"base_currency": "USD", "spend_accounts": []}
snapshot_payload = {}
transactions_payload = [
    {
        "tx_id": "1",
        "entry_id": "",
        "date": "2026-04-25",
        "description": "test",
        "amount": "-50.00",
        "source": "Chase",
        "currency": "USD",
        "tags": [],
        "tx_type": "EXPENSE",
        "category": "Food",
        "bill": ""
    },
    {
        "tx_id": "2",
        "entry_id": "",
        "date": "2026-04-25",
        "description": "test 2",
        "amount": "2000.00",
        "source": "Chase",
        "currency": "USD",
        "tags": [],
        "tx_type": "INCOME",
        "category": "Salary",
        "bill": ""
    }
]

vm = map_to_view_model(
    profile_payload=profile_payload,
    snapshot_payload=snapshot_payload,
    transactions_payload=transactions_payload,
)

print(f"Spend points: {len(vm.spend_series)}")
print(f"Flow points: {len(vm.flow_series)}")
print(f"Category points: {len(vm.category_series)}")
