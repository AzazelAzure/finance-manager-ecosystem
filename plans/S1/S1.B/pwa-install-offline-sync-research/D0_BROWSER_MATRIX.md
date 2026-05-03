# D0 — Browser / install matrix (research)

**Gate:** define the v1 **certified** vs **best-effort** browser/install matrix for PWA exit smoke (parent `[README.md](./README.md)` §6). **Answer (locked):** **Chrome desktop + Chrome Android** certified only (**Option B**); see §0.

**Lock:** **Option B** — 2026-05-01 (HitM). Appendix + §1.3 in `[README.md](./README.md)`.

---

## 0) Locked decision (HitM — 2026-05-01)


| Field                                             | Value                                                                                                                                                                                                                                                          |
| ------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Chosen option**                                 | **B**                                                                                                                                                                                                                                                          |
| **Certified** (exit smoke + fix priority)         | Google **Chrome** (desktop), Google **Chrome** (Android)                                                                                                                                                                                                       |
| **Secondary QA** (not release blockers)           | Microsoft **Edge**, **Samsung Internet** (Chromium-class; PH-relevant but not named in certified checklist)                                                                                                                                                    |
| **Best-effort** (documented; no parity guarantee) | Safari (iOS, macOS), Firefox (Android, desktop)                                                                                                                                                                                                                |
| **Rationale**                                     | **PH mobile-first**, **Android-primary**; Chrome is the default path for most PH users; **PC secondary**. iOS can trail Android share; **full iPhone PWA parity not required for v1** — if insufficient, users wait for **native iOS app** (acceptable trade). |
| **Owner**                                         | HitM                                                                                                                                                                                                                                                           |


---

## 1) What you need to know (facts)

### 1.1 What “certified” means for this project

For **S1.B exit / smoke**, “certified” = **we commit QA + bugfix priority** to these clients: install flow, standalone window, service worker lifecycle, offline/outbox behavior (Advanced tier), and **forced upgrade** UX are **expected to work** on each certified browser.

**Best-effort** = we do **not** block release on parity; known gaps are **documented**; users may see “use Chrome for full offline install” style guidance where needed.

### 1.2 Chromium family (strong PWA / install story)


| Client                         | Notes                                                                                                               |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------- |
| **Google Chrome (desktop)**    | Reference implementation for `beforeinstallprompt`, install, standalone, SW, Background Sync.                       |
| **Microsoft Edge (desktop)**   | Chromium; same engine class as Chrome for PWA — small QA cost to include if you already test Chrome.                |
| **Google Chrome (Android)**    | Primary for **PH** and most **US** Android users; install from menu / “Add to Home screen” when criteria met.       |
| **Samsung Internet (Android)** | Chromium-based; large share on Samsung devices in PH — typically **track with Chrome Android** (same engine class). |


**Edge case:** in-app embedded WebViews (Facebook, LINE, etc.) are **not** browsers for install certification — treat as **unsupported for install**; deep links to system Chrome are a product choice, not D0.

### 1.3 Safari (iOS and macOS)

- **Install:** “Add to Home Screen” exists; **not** identical to Chromium’s install pipeline (no `beforeinstallprompt` in the same way).
- **Service worker:** supported but **stricter lifecycle / storage eviction** than Chromium; **Background Sync** essentially **not** a reliance for v1.
- **Practical stance:** document **best-effort** for Safari; do **not** make Safari a **certified** gate for Advanced offline **unless** you explicitly expand D0 (large test matrix).

### 1.4 Firefox (desktop and Android)

- **Desktop:** no first-party “install PWA as system app” like Chromium; community tools exist — **not** suitable as a commercial **certified** target for a small team.
- **Android:** “Add to home screen” behavior is **inconsistent** vs Chromium (shortcut vs standalone); **not** recommended as **certified** for v1 if you want predictable Advanced behavior.

### 1.5 What D0 does *not* decide

- **D1** tier (already **Advanced**).
- **Which app routes** are offline-capable (route scope — separate note).
- **API** idempotency (**D2**) or **auth** offline (**D3**).

---

## 2) Options to lock (pick one primary; hybrid allowed)

### Option A — **Recommended default** (Chromium certified, Safari + Firefox best-effort)


| Tier                         | Browsers                                                                          |
| ---------------------------- | --------------------------------------------------------------------------------- |
| **Certified**                | Chrome desktop, Edge desktop, **Chrome Android**, **Samsung Internet** (Android). |
| **Best-effort (documented)** | Safari iOS, Safari macOS, Firefox Android/desktop.                                |


**Pros:** Matches PH reality + lowest QA surface for a first Advanced ship. **Cons:** Safari/Firefox users may hit limitations; messaging must be honest.

---

### Option B — **Chromium-only certified** (narrower than A)


| Tier             | Browsers                                                                       |
| ---------------- | ------------------------------------------------------------------------------ |
| **Certified**    | Chrome desktop, Chrome Android only.                                           |
| **Secondary QA** | Edge + Samsung Internet — “should work” but not named in exit smoke checklist. |
| **Best-effort**  | Same as A for Safari/Firefox.                                                  |


**Pros:** Absolute minimum matrix. **Cons:** Edge/Samsung regressions could slip; not ideal for PH Samsung users if you skip Samsung in certified.

---

### Option C — **Expanded certified** (Chromium + Safari iOS)


| Tier            | Browsers                                                                                                     |
| --------------- | ------------------------------------------------------------------------------------------------------------ |
| **Certified**   | Option **A** **plus** Safari **iOS** (specific major iOS versions you name, e.g. “latest + previous major”). |
| **Best-effort** | Safari macOS, Firefox.                                                                                       |


**Pros:** Strong story for iPhone testers. **Cons:** **Material HitM QA time** (devices, OS versions, WebKit quirks); Background Sync / storage limits still weaker — engineering cost rises.

---

## 3) Superseded recommendation

Earlier draft recommended **Option A** (Edge + Samsung in certified). **Superseded** by HitM **Option B** lock (§0).

---

## 4) Documentation trail

1. `[README.md](./README.md)` — §1.3, decision gate table **D0** row, appendix **D0**.
2. Optional later: one paragraph in `design_docs` web PWA note (parent plan §7) when implementation nears.

