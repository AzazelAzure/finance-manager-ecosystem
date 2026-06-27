# Strategy Automations

Prompt documents for recurring Antigravity (agy) automation runs.

## Prompts

| File | Schedule | Output |
|---|---|---|
| `prompts/daily_summary_prompt.md` | Daily (end of workday) | `strategy/daily_summaries/daily_summary_YYYY-MM-DD.md` + updates `strategy/current_status.md` |
| `prompts/legal_compliance_monthly_prompt.md` | Monthly (1st–3rd of month) | `strategy/legal/compliance_reports/YYYY-MM.md` |

## How to run

```bash
# Daily summary
agy < strategy/automations/prompts/daily_summary_prompt.md

# Monthly legal compliance
agy < strategy/automations/prompts/legal_compliance_monthly_prompt.md
```

Or paste the prompt content directly into an Antigravity chat session from the repo root.

## Reference documents

- `strategy/legal/compliance_checklist.md` — the concrete check list used by the monthly automation
- `strategy/legal/compliance_reports/` — historical monthly reports
- `strategy/daily_summaries/` — historical daily summaries
