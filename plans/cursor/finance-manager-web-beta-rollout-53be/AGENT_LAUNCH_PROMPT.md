# Agent launch prompt — finance_manager_web beta rollout

Copy everything inside the fence into a new agent task (no placeholders to fill).

```text
You are the JS frontend agent for plan:
  plans/cursor/finance-manager-web-beta-rollout-53be/

VPS SSH (same Linux user as the parallel Reflex plan agent — both may use this simultaneously for SSH/editing; coordinate container start/stop/rebuild/deploy via Runtime Signup Sheet):
  dev@159.198.75.194
  Typical repo path on VPS: /home/dev/finance_manager (confirm on host if different)

Read first (order matters):
1. plans/cursor/finance-manager-web-beta-rollout-53be/README.md
2. plans/cursor/finance-manager-web-beta-rollout-53be/validation_gates.md
3. plans/cursor/finance-manager-web-beta-rollout-53be/CROSS_AGENT_COORDINATION.md
4. design_docs/30_Releases/Runtime_Signup_Sheet.md — if you touch VPS or local mixed stacks
5. finance_manager_web/ — current Vite app (login, dashboard, React Query)
6. finance_manager_api/finance_api/settings.py — CORS_ALLOWED_ORIGINS, CSRF_TRUSTED_ORIGINS

Parallel work: vps-reflex-bluegreen-recovery-53be. Do not restart VPS containers without runtime owner coordination.

Submodule + remote (human may execute if URL access differs):
- Ecosystem parent: finance-manager workspace root
- Add submodule path finance_manager_web → git@github.com:AzazelAzure/finance-manager-web.git
- Branch: cursor/finance-manager-web-beta-rollout-53be (or agreed feature branch)
- Git hygiene: initial commit in web repo, .gitignore for node_modules/dist, README for env vars

Testing lanes (pick per README Phase 0 decision; default recommended: **Lane B VPS** for production DB truth):
- Lane A LOCAL: API `runserver` + SQLite via env (.env.example documenting JS_DEV_* or FM_*); VITE_API_BASE_URL=http://127.0.0.1:8000; ensure CORS includes actual Vite Origin (often http://localhost:5173 not only 4173)
- Lane B VPS: Hostname jsdevtesting.thehivemanager.com → new nginx server block → static or small container serving `npm run build` output; API stays existing api.thehivemanager.com; CORS must include https://jsdevtesting.thehivemanager.com; Cloudflare DNS + tunnel route

Login UX: surface Axios/network error body in dev to distinguish 401 vs CORS vs DNS (user saw generic failure).

Success criteria:
- Phase 0: Lane chosen; coordination file updated
- Submodule wired + pushed to github.com:AzazelAzure/finance-manager-web.git
- Login + dashboard against chosen API; CORS verified for that Origin
- Lane B: public URL works end-to-end; validation_gates updated
- CPPR: PRs per repo; API PR merged before relying on prod CORS; manual human sign-off logged

Start at README. Report blockers with request/response headers for failed login.
```
