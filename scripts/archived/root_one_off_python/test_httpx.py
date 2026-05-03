import asyncio
import httpx

async def main():
    async with httpx.AsyncClient() as client:
        # First login to get tokens
        resp = await client.post('http://localhost:8000/finance/auth/login/', json={"username": "pproctor", "password": "Testuser1!"})
        if resp.status_code != 200:
            print("Login failed:", resp.status_code, resp.text)
            return
        
        token = resp.json().get("access")
        headers = {"Authorization": f"Bearer {token}"}
        
        resp = await client.get('http://localhost:8000/finance/transactions/?current_month=true', headers=headers)
        data = resp.json()
        txs = data.get('transactions', [])
        print(f"Transactions: {len(txs)}")
        
        # Test the mappers directly
        from finance_manager_reflex.features.agentdash.mappers import build_spend_series
        spend = build_spend_series({}, txs)
        print(f"Spend series points: {len(spend)}")

if __name__ == "__main__":
    asyncio.run(main())
