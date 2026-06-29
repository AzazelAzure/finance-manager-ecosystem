---
logged: 2026-06-29
agent: cursor
plan_context: inactive-color-fixes-batch / Theme 1 share shutdown
status: final
severity: high
related_prs:
  api_land: AzazelAzure/finance-manager-api#59
  web_land: AzazelAzure/finance-manager-web#86
  api_disable: AzazelAzure/finance-manager-api#66
  web_disable: AzazelAzure/finance-manager-web#92
---

# Root-Cause Analysis: F-010 Share-Link Privacy Exposure

**Report date:** 2026-06-29  
**Reporter context:** HitM flagged share link on inactive blue during polish pass — link "does not work" and appears to leak user data.  
**Disposition:** Feature disabled same day (API PR #66, Web PR #92). This RCA traces how the exposure reached production.

---

## 1. Executive summary

The F-010 "Share Data" feature was **implemented and deployed exactly as specified**. A user-generated UUID bearer URL granted **any holder** unauthenticated read access to the **token owner's entire transaction history** as raw JSON from `api.thehivemanager.com`. This was not a cross-user IDOR bug (user A's token never returned user B's rows — tests enforced that). The failure mode is **privacy-by-design**: a capability URL in a shareable location exposes a full financial ledger without login, viewer UI, consent friction, field redaction, or rate limiting.

The feature was live on **active green** from approximately **2026-06-28 12:32 +08** until routes were removed **2026-06-29 ~12:54 +08** (~24 hours). Public marketing (F-011 landing, same day) advertised "export/sharing" before the shutdown.

---

## 2. What the exposure is (exact request flow)

### 2.1 Mint token (authenticated)

```
POST https://api.thehivemanager.com/finance/export/share/
Authorization: Bearer <user_jwt>
Content-Type: application/json
Body: { "expires_in_days": 7 }

→ 201 { "token": "<uuid-v4>", "expires_at": "<ISO8601>" }
```

Implemented in `ShareTokenCreateView` (`finance_manager_api/finance/views/export_views.py`, landed commit `3c20f3b`).

### 2.2 Access data (unauthenticated — the exposure)

```
GET https://api.thehivemanager.com/finance/export/share/<uuid>/
(no Authorization header)

→ 200 {
  "shared_by": null,
  "exported_at": "...",
  "transactions": [
    { "date", "description", "amount", "created_on", "category", "source",
      "currency", "tags", "tx_id", "bill", "tx_type" },
    ... ALL rows for token owner, no date filter ...
  ]
}
```

Implemented in `ShareTokenAccessView` with:

```python
permission_classes = [AllowAny]
authentication_classes = []
```

### 2.3 What is NOT exposed via share token

- Other users' data (scoped via `Transaction.objects.for_user(owner_uid)`)
- Profile settings, sources, categories, tags tables, upcoming expenses, savings goals (those require authenticated `/finance/export/full/`)

### 2.4 What reporters experienced as "broken"

- UI copied an **API URL** (`api.thehivemanager.com/...`), not a web viewer (`thehivemanager.com/share/...`)
- Browser shows raw JSON — no formatted share page (documented beta limitation in `T05_share-ui.md` Notes §75)
- Users expecting a "product link" may have concluded the feature failed while the API was working as designed

### 2.5 Severity classification

| Claim | Verdict |
|-------|---------|
| "Random link leaks everyone's database" | **False** — requires valid UUID for that user |
| "Link leaks holder's full transaction history" | **True** — by design |
| "Massive security breach / IDOR" | **Misclassified** — bearer-token disclosure, not multi-tenant bypass |

---

## 3. Where it lives (code map)

| Layer | Path | Notes |
|-------|------|-------|
| Plan | `plans/S1/S1.B/feat-f010-export-sharing/` | `PLAN_CROSS_EXPORT_SHARING_F010_2026-05-05`, status `completed` |
| API spec | `tasks/T04_share-token-api.md` | AC #3: public GET, no JWT |
| Web spec | `tasks/T05_share-ui.md` | "anyone can use to view your transactions (no login required)" |
| Model | `finance/models.py` → `ExportShareToken` | Migration `0015_export_share_token_f010.py` |
| API views | `finance/views/export_views.py` | `ShareTokenCreateView`, `ShareTokenAccessView`, `ShareTokenRevokeView` |
| Routes | `finance_api/urls.py` | `finance/export/share/` (3 paths) |
| Web UI | `finance_manager_web/src/pages/data/DataHubPage.tsx` | Share Data card (removed 2026-06-29) |
| Web client | `finance_manager_web/src/api/lookups.ts` | `createShareToken`, `buildShareTokenUrl`, `revokeShareToken` |
| Tests | `finance/tests/test_f010_export.py` | `ShareTokenExportTests` — cross-user isolation only |

---

## 4. Why it was built (plan intent)

F-010 scope (`README.md`): export CSV, full JSON backup, and **time-limited share links** for household "send to spouse" use cases. T04 explicitly chose JSON link over PDF (dependency/perf).

**Quoted spec requirements that created the exposure:**

From `T04_share-token-api.md`:

> Hitting the public share endpoint with a valid token returns a JSON snapshot of that user's transactions — **no JWT required**.

> AC #3: `GET /finance/export/share/{token}/` (**public — no JWT**) returns transaction JSON snapshot

> T04.SL3: `ShareTokenAccessView` — `permission_classes = []` (**public**)

From `T05_share-ui.md`:

> `data.share.description`: "Generate a link anyone can use to view your transactions (no login required)."

**Mitigations specified in plan:**

- UUID v4 token (not guessable)
- TTL default 7 days, max 30 (`expires_in_days` clamp)
- Revoke endpoint
- `shared_by: null` (don't expose owner email on public endpoint)
- 404 for expired/unknown (not 401)
- **Explicitly deferred:** rate limiting on public access (T04 Notes)
- **Explicitly deferred:** frontend viewer page (T05 Notes — API URL only for beta)

**Risk register gap (`README.md` §10):** only logged *"Token leak / share URL too guessable"* with rollback *"Short TTL + revoke; disable feature."* Did not gate on *"full ledger exposure to link holder."*

---

## 5. How it reached live services (timeline with evidence)

### 5.1 Implementation

| When (+08) | Repo | SHA | PR | Event |
|------------|------|-----|-----|-------|
| 2026-06-28 11:49 | API | `3c20f3b` | — | T04 share token API implemented |
| 2026-06-28 11:54 | Web | `006cb6b` | — | T05 share UI implemented |
| 2026-06-28 12:05 | API | `5b80458` | **#59** | T04 PR merged |
| 2026-06-28 12:05 | Web | `f505849` | **#86** | T05 PR merged |
| 2026-06-28 12:21 | API | `defd844` | — | F-010 landing merge to `main` |
| 2026-06-28 12:21 | Web | `ac341b6` | — | F-010 landing merge to `main` |

### 5.2 Production deploy and color flip

Evidence chain:

1. **Parent CHANGELOG** (`CHANGELOG.md`, §2026-06-28 — F-010 export and sharing closeout):
   - Plan completed; VPS rebuilt inactive **green**; migration `0015` applied; smoked green; **active color switched blue → green**.

2. **`plans/.../feat-f010-export-sharing/runtime_handoff.md`** (Closeout 2026-06-28):
   - Final active: **green**; post-switch smoke includes unknown share token → 404; residual check instructs generating a real share link and opening anonymously.

3. **`design_docs/30_Releases/Runtime_Signup_Sheet.md`** (F-010 deploy log):
   - VPS clones: API `defd844`, Web `ac341b6`
   - `switch --to green` executed
   - Transfer timestamp: `2026-06-28T12:32:00+08:00`
   - Runtime ownership released after active-green smoke

4. **Public marketing same day:** F-011 landing (parent CHANGELOG §2026-06-28) advertised June batch including "export/sharing" — sharing half retracted next day.

### 5.3 Discovery and shutdown

| When (+08) | Event |
|------------|-------|
| 2026-06-29 AM | HitM polish on inactive blue — share link reported broken + data leak |
| 2026-06-29 ~12:54 | API `8cc5fe4` / PR **#66** — routes removed; migration `0018` revokes outstanding tokens |
| 2026-06-29 ~12:55 | Web `b90eb92` / PR **#92** — Share UI removed |

### 5.4 Exposure window

**~24 hours** on active green production (`2026-06-28 12:32` → `2026-06-29 12:54 +08`). Any token minted in that window had a valid DB row until migration `0018` runs on deploy of PR #66.

---

## 6. Why controls missed it

### 6.1 Specification treated public full-history as acceptable

Agents and reviewers validated **cross-user isolation** (AC #7) and **404 semantics** — not whether unauthenticated full-ledger JSON is acceptable for a finance product. The plan's end state *required* the exposure.

### 6.2 Definition of Done gap

`governance/definition_of_done.md` has no **privacy gate** for features that:
- Use `AllowAny` / empty `authentication_classes`
- Return user financial data outside authenticated session
- Place secrets/capabilities in URLs (Referer, history, chat logs)

### 6.3 Agent review scope

Review checked IDOR and test coverage. Did not escalate:
- Missing viewer / consent UX
- Full-history scope (vs date-bounded share)
- Conflict with `strategy/legal/drafts/privacy_policy_v1.md` ("data not shared with third parties" vs user-initiated public dump)

### 6.4 Pre-merge gate

Plan README: `pre_merge: required`. F-010 merged and flipped within ~1 hour (12:05 PRs → 12:32 prod). No recorded HitM privacy signoff for public bearer URLs.

### 6.5 Verification blind spot

Smokes tested `unknown token → 404`. Residual checklist tested *valid token returns data anonymously* as **success**, not as a risk acceptance decision.

---

## 7. Remediation taken (2026-06-29)

| Action | Owner | PR |
|--------|-------|-----|
| Remove public share routes | API | #66 |
| Revoke all `ExportShareToken` rows (migration `0018`) | API | #66 |
| Remove Share Data UI | Web | #92 |
| This RCA | Parent | chore/share-link-rca |

CSV export and authenticated full JSON backup **unchanged**.

---

## 8. Control recommendations (durable)

1. **DoD privacy gate:** Any endpoint with `AllowAny` returning user financial data requires explicit HitM risk acceptance in plan + audit log entry before merge.
2. **Review checklist:** Flag `authentication_classes = []` on data-export paths; require scoped payload description and max retention.
3. **No capability URLs without viewer:** If sharing returns, use short-lived tokens + dedicated `/share/{token}` web viewer with consent modal — never raw API JSON URLs in clipboard.
4. **Scope shares:** Date range, field allowlist, row cap — never full ledger by default.
5. **Rate limit public export paths** even in beta.
6. **Marketing sync:** Landing page must not advertise features until post-privacy review.

---

## 9. Follow-up

- **Hardening plan stub:** `plans/S1/S1.B/feat-f010-export-sharing/HARDENING_FOLLOWUP_STUB.md` (if sharing is revived)
- **Deploy PR #66 + #92** to inactive blue, then production flip only after HitM signoff on full polish batch
- **DB audit:** After migration `0018` deploy, confirm `ExportShareToken.revoked = true` for all rows on production

---

## 10. References

- Disable API PR: https://github.com/AzazelAzure/finance-manager-api/pull/66
- Disable Web PR: https://github.com/AzazelAzure/finance-manager-web/pull/92
- Original API PR: https://github.com/AzazelAzure/finance-manager-api/pull/59
- Original Web PR: https://github.com/AzazelAzure/finance-manager-web/pull/86
- Plan: `plans/S1/S1.B/feat-f010-export-sharing/`
