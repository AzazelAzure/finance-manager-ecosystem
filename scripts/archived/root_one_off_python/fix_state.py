import os
import re

file_path = "/home/pproctor/Documents/python/finance_manager/finance_manager_reflex/finance_manager_reflex/features/agentdash/state.py"
with open(file_path, "r") as f:
    content = f.read()

# Make models inherit from rx.Base
models_path = "/home/pproctor/Documents/python/finance_manager/finance_manager_reflex/finance_manager_reflex/features/agentdash/models.py"
with open(models_path, "r") as f:
    models_content = f.read()

if "import reflex as rx" not in models_content:
    models_content = "import reflex as rx\n" + models_content
    
models_content = models_content.replace("class DashboardChartPoint(BaseModel):", "class DashboardChartPoint(rx.Base):")
models_content = models_content.replace("class DashboardFlowPoint(BaseModel):", "class DashboardFlowPoint(rx.Base):")
models_content = models_content.replace("class DashboardCategoryPoint(BaseModel):", "class DashboardCategoryPoint(rx.Base):")
models_content = models_content.replace("class DashboardKpi(BaseModel):", "class DashboardKpi(rx.Base):")
models_content = models_content.replace("class SourceBalance(BaseModel):", "class SourceBalance(rx.Base):")
models_content = models_content.replace("class RecentTransaction(BaseModel):", "class RecentTransaction(rx.Base):")

with open(models_path, "w") as f:
    f.write(models_content)

print("Updated models to use rx.Base")
