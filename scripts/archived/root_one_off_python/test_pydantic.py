from pydantic import BaseModel
from decimal import Decimal

class DashboardChartPoint(BaseModel):
    label: str
    value: float

try:
    point = DashboardChartPoint(label="test", value=Decimal("15.50"))
    print(point)
except Exception as e:
    print(f"Error: {e}")
