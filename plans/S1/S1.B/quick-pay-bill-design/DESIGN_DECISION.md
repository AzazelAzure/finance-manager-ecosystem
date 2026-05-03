# Quick pay bill — design decision (staged)

**Status:** `staged` — product semantics locked for a future implementation pass; **no code change required** in this commit beyond planning artifacts.

**Triage origin:** Post-beta huddle `KNOWN_ISSUES.md` **Issue 2** — dashboard `Quick add → +Bill` (`+Bill` label in UI) was disabled pending a decision among “create upcoming,” “record payment,” or hybrid.

**Locked decision (HitM, 2026-05-05):** Replace the disabled **+Bill** entry with a **Quick pay bill** action that opens a **minimal form**:

| Field | Behavior |
| ----- | -------- |
| Bill / expense | **Dropdown** populated from the user’s **upcoming expenses** (same universe as other bill pickers — unpaid / due list as product defines at build time). |
| Amount | **Prefilled** to the bill’s **listed full amount** from the selected upcoming expense; **user may edit** (partial payments, promos, fees). |
| Submit | Creates a **transaction** that includes the **`bill`** link (and any other fields the API requires for a valid expense transaction). |

**Explicit v1 omissions (can tighten later):**

- **Description:** leave blank (or server default empty string — match existing transaction-create contract).
- **Category:** leave blank for v1 unless API forbids; if API requires a value, use a single documented default or inherit from upcoming expense row if the model exposes it — **implementer must confirm serializer rules** before ship.
- **Tags:** none for v1.

**Autofill (non-omitted):** Map everything else the transaction model needs from **(a)** the selected upcoming expense row (e.g. source, currency, due date → transaction date policy, recurring metadata if relevant) and **(b)** the form (edited amount). Exact field matrix is an implementation checklist against `createTransactions` / OpenAPI or parity with full transaction editor.

**Out of scope for this decision:** Marking the upcoming expense paid, partial-bill state machine (F-004), and projection updates — record follow-ups when Quick pay ships if product wants linked lifecycle behavior.

---

## PWA sprint coordination

The **Advanced PWA** implementation sprint (`plans/S1/S1.B/pwa-implementation-branch/`) is active on **`finance_manager_web`** (dashboard quick paths, offline/outbox, mutating API contract).

| Constraint | Rationale |
| ---------- | --------- |
| **Do not land** Quick pay bill UI in the same PRs as core PWA infrastructure unless the branch owner agrees — **serialize or branch** after merge. | `QuickActions.tsx` and transaction mutation paths are high-touch during PWA (outbox, idempotency, `X-Client-Build`). |
| **Reuse** the same **transaction-create** code path the PWA work standardizes (headers, offline queue behavior, error handling). | Avoids a second, drift-prone “special” writer. |
| **Coordinate** with the PWA owner before adding new mutating flows that bypass the outbox. | D2 contract applies to allowlisted mutators; Quick pay must not introduce a shadow path. |

**Orchestration pointer:** [`../pwa-implementation-branch/README.md`](../pwa-implementation-branch/README.md) — see **Coordination — Quick pay bill** there for the live sprint handoff.

---

## Code surfaces (when implemented)

- Primary UI: `finance_manager_web/src/components/dashboard/QuickActions.tsx` (today: `BILL` action **disabled**; legacy `BILL` branch called `createUpcomingExpense` — **superseded** by this decision in favor of **transaction + bill**).
- Data: upcoming expenses list APIs already used by dashboard/transactions bill datalists; transaction create API + types.

---

## Changelog / CPPRD (when implemented)

- `finance_manager_web/CHANGELOG.md` — user-visible Quick pay bill.
- If API contract changes: `finance_manager_api/CHANGELOG.md` in the same workstream.
