# T01 — Management Command: create_ux_testuser

## Context

The command creates a single, realistic, rolling-date test user for UI/UX review. Data is relative to `date.today()` so it never ages out. The seeder is designed to show realistic PH financial patterns, not random garbage data.

## End State

`python manage.py create_ux_testuser` works on any env with the `finance` app installed.

## Slice Decomposition

| Slice | Title | V-Tier |
|---|---|---|
| T01.SL1 | Command scaffold + user creation | V1 |
| T01.SL2 | Category / source / tag seed | V1 |
| T01.SL3 | Transaction seed (12-month rolling) | V1, V3 |
| T01.SL4 | Upcoming expenses seed | V1, V3 |

---

## T01.SL1 — Command Scaffold + User Creation

File: `finance/management/commands/create_ux_testuser.py`

```python
class Command(BaseCommand):
    help = "Create or reset the ux_demo test user with realistic seeded data."

    def add_arguments(self, parser):
        parser.add_argument("--username", default="ux_demo")
        parser.add_argument("--email", default="ux_demo@internal.test")
        parser.add_argument("--password", default=os.getenv("UX_DEMO_PASSWORD", "UxDemo2026!"))
        parser.add_argument("--reset", action="store_true", help="Delete and reseed domain data if user exists")

    def handle(self, *args, **options):
        username = options["username"]
        # If user exists and --reset not set: warn and exit
        # If user exists and --reset: delete all related domain data (keep User account)
        # If user doesn't exist: create User + AppProfile via normal flow (trigger signals)
        # Set password via user.set_password(options["password"])
```

**User creation note:** Create the `User` via `User.objects.create_user(username, email, password)` to trigger the `post_save` signal that creates `AppProfile`. Do NOT use `User.objects.create()` (skips signal).

**Reset behavior:** On `--reset`, delete:
- `Transaction.objects.filter(uid=str(user.appprofile.user_id)).delete()`
- `UpcomingExpense.objects.filter(uid=...).delete()`
- `Category.objects.filter(uid=...).delete()`
- `Tag.objects.filter(uid=...).delete()`
- `PaymentSource.objects.filter(uid=...).delete()`
Do NOT delete the `User` or `AppProfile` (preserves login credentials).

**Safety check:** Print a warning: `"WARNING: This command creates test data. Do not run on production."` and if `settings.DEBUG` is False, require `--confirm-not-prod` flag or raise `CommandError`.

**Acceptance criteria:**
- [V1] `python manage.py create_ux_testuser` creates user without error
- [V1] `python manage.py create_ux_testuser` again (no `--reset`) prints warning and exits
- [V1] `python manage.py create_ux_testuser --reset` reseeds without error

---

## T01.SL2 — Category / Source / Tag Seed

After user is created/confirmed, seed these lookups using `get_or_create`:

**Payment Sources** (6 total):
| Source | acc_type | currency | amount (starting balance) |
|---|---|---|---|
| Cash | CASH | PHP | 5000.00 |
| GCash | EWALLET | PHP | 8500.00 |
| BDO Checking | CHECKING | PHP | 45000.00 |
| Maya | EWALLET | PHP | 2300.00 |
| Savings Account | SAVINGS | PHP | 120000.00 |
| Credit Card | CHECKING | PHP | 0.00 |

**Categories** (8 total):
`Food & Groceries`, `Transport`, `Utilities`, `Rent / Housing`, `Health`, `Entertainment`, `Savings Transfer`, `Income`

**Tags** (4 total):
`recurring`, `essential`, `discretionary`, `reimbursable`

**Acceptance criteria:**
- [V1] All 6 sources, 8 categories, 4 tags exist after command runs
- [V1] `--reset` + re-run produces same set (idempotent via `get_or_create`)

---

## T01.SL3 — Transaction Seed (12-Month Rolling)

Generate approximately 25-35 transactions per month for the last 12 months. All dates must be `<= date.today()`.

**Spending profile (monthly averages, PHP):**
| Category | Avg/month | Type | Source | Variance |
|---|---|---|---|---|
| Rent / Housing | ₱18,000 | EXPENSE | BDO Checking | ±0 (fixed) |
| Food & Groceries | ₱8,000 | EXPENSE | GCash / Cash | ±20% |
| Transport | ₱2,500 | EXPENSE | GCash / Cash | ±30% |
| Utilities (Electric) | ₱1,800 | EXPENSE | BDO Checking | ±15% |
| Utilities (Internet) | ₱1,200 | EXPENSE | BDO Checking | ±0 (fixed) |
| Health | ₱800 | EXPENSE | Cash / Maya | ±50% |
| Entertainment | ₱1,500 | EXPENSE | GCash | ±40% |
| Savings Transfer | ₱5,000 | EXPENSE (XFER_OUT) | BDO Checking | ±0 |
| Income (Salary) | ₱65,000 | INCOME | BDO Checking | ±0 (fixed, 1st of month) |
| Income (Freelance) | ₱8,000–₱20,000 | INCOME | Maya | ±60% (some months 0) |

**Implementation approach:**
- Use a fixed random seed (`random.seed(42)`) so the data is deterministic across resets
- Loop over the last 12 months (month 0 = current month partial, months 1-11 = full months)
- For each fixed expense (Rent, Utilities, Savings), create exactly one transaction on day 1-5 of the month
- For variable expenses (Food, Transport, etc.), create 4-8 transactions spread through the month with amounts drawn from a normal distribution around the average
- For Income (Salary), create on the 15th of each month
- For Freelance income, randomly present in 8 of 12 months

**Note on tx_type:** Savings Transfer should use `XFER_OUT` (or `EXPENSE` if `XFER_OUT` is not valid — check model choices in `Transaction` model). Use `EXPENSE` for all spending, `INCOME` for income, and use the correct type for transfers.

**Acceptance criteria:**
- [V1] ~300-420 transactions created (12 months × 25-35/month)
- [V1] All transaction dates are `<= date.today()` and within the last 12 months
- [V1] All amounts are positive; all currencies are PHP
- [V3] Browser: Dashboard shows recognizable spending patterns across months

---

## T01.SL4 — Upcoming Expenses Seed

Create 3 upcoming expenses with relative due dates:

| Description | Amount | Due date | Source |
|---|---|---|---|
| Rent — July | ₱18,000 | First day of next month | BDO Checking |
| Electric Bill | ₱1,800 | 10 days from today | BDO Checking |
| Internet | ₱1,200 | 15 days from today | BDO Checking |

Use `date.today() + timedelta(days=N)` for all due dates — never hardcoded dates.

**Acceptance criteria:**
- [V1] 3 upcoming expenses created with correct relative dates
- [V1] `--reset` + re-run replaces them (delete all, recreate)
- [V3] Browser: Upcoming Expenses page shows 3 items with expected names and amounts

## Evidence

- `evidence/T01.SL1_command_help.txt` — output of `python manage.py create_ux_testuser --help`
- `evidence/T01.SL3_transaction_count.txt` — output of command showing transaction count created
- `evidence/T01.SL3_dashboard.png` — screenshot of dashboard after seeding
- `evidence/T01.SL4_upcoming.png` — screenshot of upcoming expenses page
