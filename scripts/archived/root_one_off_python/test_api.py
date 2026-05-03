import asyncio
import httpx
from pydantic import BaseModel
import sys

async def main():
    async with httpx.AsyncClient(verify=False) as client:
        # 1. Login
        resp = await client.post("https://api.financemanager.local:8443/api/auth/login/", json={
            "username": "admin",
            "email": "admin@example.com",
            "password": "admin"
        })
        if resp.status_code != 200:
            print("Login failed:", resp.status_code, resp.text)
            sys.exit(1)
        
        access = resp.json()["access_token"]
        
        # 2. Get txs
        resp = await client.get("https://api.financemanager.local:8443/finance/transactions/", headers={
            "Authorization": f"Bearer {access}"
        }, params={"current_month": "True"})
        
        if resp.status_code != 200:
            print("Txs failed:", resp.status_code, resp.text)
            sys.exit(1)
            
        data = resp.json()
        txs = data.get("transactions", [])
        print(f"Got {len(txs)} transactions")
        if txs:
            print(txs[0])
            
        # 3. Get snapshot
        resp = await client.get("https://api.financemanager.local:8443/finance/dashboard/snapshot/", headers={
            "Authorization": f"Bearer {access}"
        }, params={"current_month": "True"})
        
        if resp.status_code != 200:
            print("Snapshot failed:", resp.status_code, resp.text)
            sys.exit(1)
            
        snap = resp.json()
        print(f"Snapshot transactions_for_month count: {len(snap.get('transactions_for_month', []))}")

asyncio.run(main())
