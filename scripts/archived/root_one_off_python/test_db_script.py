import asyncio
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'finance_manager_api.settings')
django.setup()
from finance.services.transaction_services import get_transactions
from finance.models import AppProfile

uid = AppProfile.objects.first().user_id
res = get_transactions(uid, current_month='true')
print(f"Transactions in DB for {uid}:", len(res['transactions']))

