from finance_manager_reflex.features.transactions.models import TransactionRecord
from decimal import Decimal
import json

tx = TransactionRecord(
    tx_id="1",
    entry_id="1",
    date="2026-04-26",
    description="Test",
    amount=Decimal("-50.00"),
    source="Test",
    currency="USD",
    tx_type="EXPENSE",
    category="Test",
    bill="Test"
)

d = tx.model_dump(mode="json")
print("tx_type:", d.get("tx_type"))
print("amount:", d.get("amount"))
