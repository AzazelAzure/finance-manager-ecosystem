import os

file_path = "/home/pproctor/Documents/python/finance_manager/finance_manager_reflex/finance_manager_reflex/features/agentdash/models.py"
with open(file_path, "r") as f:
    content = f.read()

new_content = """from __future__ import annotations

\"\"\"Typed presentation models for dashboard rendering.\"\"\"

from decimal import Decimal
from typing import Any

from pydantic import BaseModel, Field


class WidgetMetadata(BaseModel):
    id: str
    label: str
    icon: str


class DashboardKpi(BaseModel):
    key: str
    label: str
    value: str
    hint: str = ""


class DashboardChartPoint(BaseModel):
    label: str
    value: float


class DashboardFlowPoint(BaseModel):
    label: str
    incoming: float = 0.0
    outgoing: float = 0.0
    leaks: float = 0.0


class DashboardCategoryPoint(BaseModel):
    name: str
    value: float


class SourceBalance(BaseModel):
    source: str
    amount: str
    currency: str
    acc_type: str = ""


class RecentTransaction(BaseModel):
    date: str
    description: str
    category: str
    amount: str
    currency: str
    tx_type: str
    source: str = ""


class DashboardViewModel(BaseModel):
    \"\"\"View-ready dashboard data mapped from profile + snapshot payloads.\"\"\"

    kpis: list[DashboardKpi] = Field(default_factory=list)
    spend_series: list[DashboardChartPoint] = Field(default_factory=list)
    income_series: list[DashboardChartPoint] = Field(default_factory=list)
    flow_series: list[DashboardFlowPoint] = Field(default_factory=list)
    category_series: list[DashboardCategoryPoint] = Field(default_factory=list)
    spend_accounts: list[str] = Field(default_factory=list)
    spend_account_balances: list[SourceBalance] = Field(default_factory=list)
    transactions_for_month: list[RecentTransaction] = Field(default_factory=list)
    base_currency: str = "USD"
    source_payload: dict[str, Any] = Field(default_factory=dict)
"""

with open(file_path, "w") as f:
    f.write(new_content)

print("Reverted models to BaseModel and fixed __future__ import order.")
