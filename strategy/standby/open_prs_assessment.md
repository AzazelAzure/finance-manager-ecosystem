# Open PRs Assessment — Standby Review

**Generated:** 2026-06-26 (reconciled against `origin/main`)  
**Baseline:** Parent `origin/main` @ `dc04179` — F-012 already landed (API `277228a`, Web `9b2ecbe`).  
**Purpose:** Pre-VPS-sync standby — merge/close/defer decisions only. No merges performed.

---

## Summary Table

| PR | Branch | Mergeable | CI / state | Recommendation |
|----|--------|-----------|------------|----------------|
| #61 | `agy/s1b/feat/infra-user-activity-logs` | MERGEABLE (CLEAN) | Cursor reviewer assign only (NEUTRAL) | **MERGE** — F-013 + F-012 polish; only net-new infra PR |
| #60 | `agy/s1b/feat/infra-support-intake` | MERGEABLE (CLEAN) | Same | **CLOSE** — superseded by `dc04179` on `main` |
| #59 | `agy/s1b/docs/daily-status-report-2026-06-16` | MERGEABLE (CLEAN) | Docs only | **CLOSE** — relic; superseded by `current_status.md` |
| #58 | `agy/s1b/chore/sync-api-submodule` | **CONFLICTING (DIRTY)** | Submodule bump only | **CLOSE** — stale; would regress F-012 |
| #57 | `agy/s1b/docs/daily-status-report-2026-06-15` | MERGEABLE (CLEAN) | Docs only | **CLOSE** — relic; HitM decision to discard |

---

## Per-PR Detail

### #61 — F-013 user activity logs

- **Created/updated:** 2026-06-16
- **Changes:** Submodule bumps (api → `7b6f564`, web → `e66c2bb`), plan registry update (F-013 → completed), new task files `T01_loguru_user_sinks.md`, `T02_bug_incident_dump.md`.
- **Feature substance:** API commit `7b6f564` implements F-013 Loguru per-user diagnostic log backend. Web pointer matches F-012 frontend branch (`e66c2bb`), not current `main` web.
- **vs `main`:** API `7b6f564` is **not** an ancestor of `49dd0ff`; history diverged after older F-007 merge (`113fc05`). Includes F-012 commits (`277228a`, `2e27df9`) plus F-013. Web `e66c2bb` is **not** an ancestor of `c855791` — parallel F-012 frontend branch vs merged F-007/PWA on `main`.
- **Risk if merged as-is:** Parent would pin **older/divergent** web SHA, **dropping** F-007 polish, PWA fixes, and landing merge on `main` web unless rebased.
- **Recommendation:** **NEEDS-WORK** — rebase `agy/s1b/feat/infra-user-activity-logs` onto current `main`, merge F-012 + F-013 API/web commits onto latest submodule heads, re-run smoke, then merge.

### #60 — F-012 support intake (submodule pointers)

- **Created/updated:** 2026-06-16
- **Changes:** api → `2e27df9`, web → `e66c2bb` only.
- **Feature substance:** Real F-012 work — API `277228a` support intake backend + fixes; web `9b2ecbe`/`e66c2bb` support intake UI. Changelog-only tip commits at branch heads.
- **vs `main`:** Same divergence as #61 for both submodules.
- **Recommendation:** **NEEDS-WORK** — treat as F-012 delivery PR; rebase onto `main`, verify web includes F-007 + PWA + F-012 together. **Merge before #61** (F-013 depends on F-012).

### #59 — Daily status June 16

- **Changes:** Adds `strategy/daily-status-report-2026-06-16.md` (+71 lines).
- **Stale?** Partially — `strategy/current_status.md` (2026-06-26) is more complete and SSH-verified.
- **Recommendation:** **CLOSE** — relic; superseded by `strategy/current_status.md`.

### #58 — Sync API submodule to main head

- **Changes:** api `49dd0ff` → `113fc05`.
- **Stale?** **Yes.** `main` already pins `49dd0ff`, which is **newer** than `113fc05` (older F-007 merge). PR is **CONFLICTING (DIRTY)**.
- **Recommendation:** **CLOSE** — superseded and wrong direction.

### #57 — Daily status June 15

- **Changes:** Adds `strategy/daily-status-report-2026-06-15.md` (+89 lines).
- **Recommendation:** **CLOSE** — relic; HitM decision to discard.

---

## Standby Merge Order (before VPS sync)

1. **CLOSE #57, #58, #59, #60**
2. **Rebase + merge F-013 (#61)** after F-012 confirmed on `main`; run API/web smoke locally or on inactive color.

### Cross-PR dependencies

- F-012 is already on `origin/main` @ `dc04179`; **#60 is superseded**.
- **#61** is the only net-new parent work (F-013 + F-012 polish commits).
- **#58** must not merge — would regress F-012.
- **#57/#59** are daily-status relics — close without merge.

---

*Sources: `gh pr list/view/diff`, local `git log` lineage checks on submodule SHAs.*
