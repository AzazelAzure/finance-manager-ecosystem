import reflex as rx
from finance_manager_reflex.features.agentdash.models import DashboardChartPoint

class TestState(rx.State):
    spend_series: list[DashboardChartPoint] = []

    def load(self):
        self.spend_series = [DashboardChartPoint(label="test", value=15.5)]
        print(self.spend_series)

t = TestState()
t.load()
