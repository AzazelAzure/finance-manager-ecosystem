---
plan_id: PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29
status: ready
priority: P1
created: 2026-06-29
updated: 2026-06-29
owner: pproctor

plan_root: plans/S1/S1.B/local-security-audit-suite/
intended_branch: cur/s1b/chore/local-security-audit-suite
parent_plan: plans/S1/S1.B/

target_repos:
  - finance_manager_api
  - finance_manager_web
  - finance-manager-ecosystem (parent scripts only)

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with: []
conflicts_with: []

manual_gates:
  pre_execution: none
  pre_merge: required
  pre_close: none

deployment:
  required: false
  notes: Local tooling only. No VPS deployment. HitM sets up cron after T03.

standalone: true
standalone_notes: "All tools run locally. No cloud API, no third-party data upload. Private repo safe."
---

# Local Security Audit Suite

**Context:** Cursor API cloud credits are exhausted, removing automated cloud-based vulnerability screens. All repos are private. HitM prefers local tooling over cloud exposure. This plan replaces cloud security automations with a fully local, offline-capable audit suite.

## 0) Strategic Inheritance

- **Wedge respected:** yes — security hardening supports trust signal for beta users
- **Locked decisions touched:** none
- **Cost cap impact:** zero — all tools are free and open source
- **Validation gates affected:** none directly; findings feed the anomaly queue

## 1) Objective

A single script (`scripts/security/run_audit.sh`) runs five local security tools across all three repos and writes a structured report to `strategy/security/audit_YYYY-MM-DD.md`. Runs manually on demand and weekly via Antigravity cron. Findings above LOW severity are written to the anomaly queue for Cursor triage.

## 2) Tools

| Tool | Purpose | Scope |
|---|---|---|
| `bandit` | Python SAST — hardcoded secrets, unsafe functions, injection patterns | API |
| `pip-audit` | Python dependency CVEs (PyPI Advisory DB, no API key) | API |
| `npm audit` | Node dependency CVEs (built into npm) | Web |
| `gitleaks` | Secret/credential leaks in git history — full history, all 3 repos | All |
| `semgrep` (community) | OWASP Top 10 pattern matching via community rulesets | API + Web |

All tools: free, open source, run offline. No data leaves the machine.

## 3) Scope

### In scope
- `scripts/security/check_tools.sh` — verify/install prerequisites
- `scripts/security/run_audit.sh` — main audit runner
- `strategy/security/` — output directory for audit reports
- Weekly Antigravity cron prompt
- Anomaly queue integration for MEDIUM/HIGH findings

### Out of scope
- Active penetration testing / live attack simulation — future plan
- Container runtime scanning (trivy) — addable later, not in v1
- Auto-remediation — findings are reported only; Cursor fixes

## 4) Task List

| Task | Slug | Scope | Owner |
|---|---|---|---|
| T01 | tool-setup | Install + verify all 5 tools; `check_tools.sh` | Cursor |
| T02 | audit-script | `run_audit.sh` — runs all tools, writes report | Cursor |
| T03 | cron-and-prompt | Weekly Antigravity prompt + HitM crontab setup | Claude Code + HitM |
| T04 | anomaly-integration | Route MEDIUM/HIGH findings to anomaly queue | Cursor |

**Execution order:** T01 → T02 → T03 → T04. T01 must pass before T02 can be verified.

## 5) Verification Gates

- [V1] `./scripts/security/check_tools.sh` exits 0 on a clean machine
- [V1] `./scripts/security/run_audit.sh` completes without crashing; output file created
- [V1] Output file contains sections for all 5 tools
- [V3] HitM manually reviews first report — confirms findings are real, not noise

## 6) Completion Criteria

- Script runs end-to-end on local machine
- Weekly cron active
- First audit report in `strategy/security/`
- MEDIUM+ findings written to anomaly queue

## 7) Risks

| Risk | Trigger | Response |
|---|---|---|
| semgrep community rules too noisy | >50 findings on first run | Tune ruleset to `p/owasp-top-ten` only; suppress known FPs with `.semgrepignore` |
| gitleaks false positives on test fixtures | Token-shaped strings in test data | Add `.gitleaksignore` entries |
| pip-audit / npm audit network dependency | Offline machine | Note: both query public advisory DBs; require internet but no API key |
