# Daily Engineering Digest — June 26, 2026

## Date Range Covered
2026-06-25 to 2026-06-26

## Key Changes

### 1. API Security Hardening & Test Coverage
* **Argon2 & django-axes Lockout:** Integrated `django-axes` login lockout (behind nginx proxy configuration) and Argon2 hashing. Enforced password complexity validations on public user signup and password change endpoints in [settings.py](file:///home/pproctor/Documents/python/finance_manager/finance_manager_api/finance_api/settings.py).
* **Migration Graph Convergence:** Resolved migration graph issues (parallel leaves 0004 & 0008) via merge migration [0009_merge_20260626.py](file:///home/pproctor/Documents/python/finance_manager/finance_manager_api/finance/migrations/0009_merge_20260626.py) and tracked missing 0002-0004 migrations so fresh databases can replay the existing merge dependency graph.
* **Test Suite Enhancements:** Closed security test gaps in [test_auth_security.py](file:///home/pproctor/Documents/python/finance_manager/finance_manager_api/finance/tests/user_tests/test_auth_security.py) to verify lockout states, weak password rejections, and Argon2 password hashing verification.

### 2. Web Guide Mode UX & CSP Cleanup
* **Help Mode UX Rework:** Redesigned F-007 Guide Mode, replacing hover-only HelpModeWrapper with click-activated contextual notes on shell nav toggle. Quick Add, Transactions, and Upcoming modals now share HelpModeWrapper (replacing fragile in-modal Joyride). Added guide coverage for Data Hub and Settings Profile. Onboarding Joyride is now reserved for explicit Replay Tour button clicks.
* **CSP Configuration:** Configured dev/prod `connect-src` hosts in [index.html](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/index.html) and consolidated duplicate dashboard actions.

### 3. Governance & Orchestration Overhaul
* **Three-Tool Agent Model:** Overhauled [AGENTS.md](file:///home/pproctor/Documents/python/finance_manager/AGENTS.md) and added [CLAUDE.md](file:///home/pproctor/Documents/python/finance_manager/CLAUDE.md) to define a clean boundary of tool ownership between Cursor Pro+ (sprint/code changes), Claude Code (admin/planning), and Antigravity Pro (recurring status/automation). Closed daily-status PR pattern in favor of updating [current_status.md](file:///home/pproctor/Documents/python/finance_manager/strategy/current_status.md) directly.
* **Archived Legacy Tooling:** Moved legacy orchestration, Slack, and PA scripts/docs to `governance/archived/` and `scripts/archived/`.

### 4. VPS Deploy & Standby Queue Closeout
* **Standby Queue Cleanup:** Closed stale/superseded PRs #57, #58, #59, #60. Merged PR #61 (F-013 user activity diagnostic logging), #62 (governance overhaul), and parent pointer bump #64.
* **Blue-Green Verification:** Rebuilt the inactive Blue color container on VPS with updated standby submodules (API `789b266`, Web `4ad032a`), applied migrations, and successfully ran smoke tests on both Blue and Green, as documented in [README.md](file:///home/pproctor/Documents/python/finance_manager/strategy/standby/README.md).

---

## Watchlist & Regressions

1. **VPS Blue Promotion Cutover Gate (High):** While the inactive Blue stack is built, migrations applied, and smoke tests passed, the active color remains Green. The promotion cutover switch to Blue is pending explicit approval from the Human-in-the-Loop manager (HitM).
2. **Local UI/UX Design System WIP:** Active development in `finance_manager_web` has local uncommitted modifications in [index.html](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/index.html), [ui.css](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/src/components/ui/ui.css), [index.css](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/src/index.css), and [tokens.css](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/src/styles/tokens.css) introducing OKLCH tokens and a theme-flash resolver. These local changes must be verified against TypeScript build checks and local dev servers.
3. **Submodule Pin Drift:** The local parent workspace contains checked-out submodule HEAD commits (API `f6a42d2` on `cur/s1b/fix/api-security-test-coverage`, Web `fdc6ce3` on `cur/s1b/feat/ui-ux-design-system`) that are ahead of the current VPS standby target pins (API `789b266`, Web `4ad032a`). Any deployment of these newer commits requires a new inactive-color build cycle.
