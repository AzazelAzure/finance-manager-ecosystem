# Incident Response Plan

**Last updated:** 2026-06-27
**Owner:** HitM (Patrick Proctor)
**Scope:** Security incidents, data breaches, unauthorized access — Finance Manager ecosystem
**Legal basis:** RA 10173 (PH Data Privacy Act) — 72-hour NPC breach notification requirement

> **Solo founder note:** All roles (Incident Commander, Technical Lead, Communications) are performed by HitM. This document is a checklist, not an org chart.

---

## §1 Severity Classification

| Level | Description | Examples | Response time |
|---|---|---|---|
| P0 | Active breach, credentials confirmed compromised, data confirmed exfiltrated | DB accessed by unknown party, SECRET_KEY rotated by attacker, admin account taken over | Immediate — stop everything |
| P1 | Suspected breach or confirmed unauthorized access with unknown scope | Unusual login patterns, failed brute-force succeeded, suspicious API traffic | Within 1 hour |
| P2 | Security misconfiguration discovered, no evidence of exploitation | Open S3 bucket, exposed env var in logs, weak permission on endpoint | Within 24 hours |
| P3 | Low-risk finding, no user data at risk | Outdated dependency with no known exploits, informational audit finding | Within 1 week |

---

## §2 How Incidents Are Detected

During beta, detection is currently manual. Known detection paths:

| Source | What it catches |
|---|---|
| Antigravity vulnerability scan automation | Known CVEs in dependencies |
| `django-axes` lockout logs | Brute-force login attempts |
| F-013 diagnostic logs (`finance_manager_api/logs/`) | API error spikes, unusual patterns |
| Cloudflare analytics | Traffic anomalies, unusual origin requests |
| Health check cron (CI/CD plan T03, once live) | Service availability |
| HitM manual review | Everything else |

**Gap:** No automated alerting on login anomalies or data access patterns. Until F-014 (usage monitoring) ships, detection is reactive.

---

## §3 Immediate Containment (P0/P1)

Run these steps in order. Do not skip ahead.

### 3.1 Take the service offline

```bash
ssh dev@dev@<VPS_HOST>
sudo /opt/fm/fm_server_beta.sh status
# Route to inactive color (buys time; does not stop the DB being accessible)
sudo /opt/fm/fm_server_beta.sh switch
# If P0 and both colors potentially compromised — stop everything:
sudo docker stop $(sudo docker ps -q)
```

### 3.2 Preserve evidence

```bash
# Save current logs BEFORE rotating or restarting anything
sudo docker logs fm-api-blue > /tmp/incident-api-blue-$(date +%Y%m%d-%H%M).log
sudo docker logs fm-api-green > /tmp/incident-api-green-$(date +%Y%m%d-%H%M).log
sudo docker logs fm-celery-blue >> /tmp/incident-celery-$(date +%Y%m%d-%H%M).log
# Copy off VPS immediately
scp dev@dev@<VPS_HOST>:/tmp/incident-*.log ./incident-logs/
```

### 3.3 Revoke active sessions

All JWT refresh tokens are stored in `HttpOnly` cookies (post-T05). To invalidate all sessions, rotate the `SECRET_KEY` — this invalidates all tokens signed with the old key.

```bash
# Generate a new SECRET_KEY:
python -c "import secrets; print(secrets.token_urlsafe(50))"
# Update .env on VPS and in .secrets/ local backup
# Rebuild containers to pick up new key
```

### 3.4 Change database password

```bash
# On VPS, connect to Postgres:
sudo docker exec -it fm-postgres-blue psql -U postgres
ALTER USER fm_user WITH PASSWORD 'new-password-here';
\q
# Update DB_PASSWORD in .env
# Rebuild containers
```

### 3.5 Rotate all other secrets

| Secret | Where to rotate |
|---|---|
| `SECRET_KEY` | Django settings → `.env` on VPS |
| `DB_PASSWORD` | Postgres `ALTER USER` + `.env` |
| `DEXIE_KEY_SECRET` | Django settings → `.env` (invalidates all client-side Dexie encryption keys; users will need to re-sync) |
| SMTP credentials | Proton Mail account settings → update `smtp.secret` |
| Cloudflare API token | Cloudflare dashboard → API Tokens |
| VPS SSH keys | `~/.ssh/authorized_keys` on VPS — remove compromised key, add new one |

---

## §4 Scope Assessment

After containment, determine what was accessed:

- [ ] Which endpoints were hit? (Check F-013 logs, Cloudflare logs)
- [ ] Were any user records accessed? (Check Postgres query logs if enabled)
- [ ] Was the database accessed directly (not via API)?
- [ ] How long was the attacker present? (Earliest suspicious log timestamp)
- [ ] Were any writes made? (New users created, data deleted/modified?)
- [ ] Was source code or secrets accessed? (Check git push history, GitHub access logs)

**Minimum data accessed in any API breach:** username, email, hashed password (Argon2id — computationally expensive to crack), transaction data for affected users.

**What attackers cannot get from a DB dump alone:**
- Plaintext passwords (Argon2id — would need to crack)
- Active JWT tokens (in-memory only, post-T05)
- Dexie encryption keys (API-derived, in-memory only, post-T06)

---

## §5 NPC Notification (RA 10173 — PH Data Privacy Act)

**Trigger:** Any breach involving personal data of PH residents must be reported to the National Privacy Commission (NPC) within **72 hours** of becoming aware of the breach.

**What counts as a notifiable breach:**
- Unauthorized access to user records (name, email, financial data)
- Data exfiltration (even if encrypted)
- Accidental public exposure of user data

**NPC notification channels:**
- Online: [https://www.privacy.gov.ph/](https://www.privacy.gov.ph/) → Breach Notification
- Email: info@privacy.gov.ph
- The NPC has a Personal Data Breach Notification form

**What the NPC notification must include:**
1. Nature of the breach (what happened)
2. Personal data involved (categories and approximate number of affected individuals)
3. Likely consequences of the breach
4. Measures taken or proposed to address the breach
5. Contact details of the Data Protection Officer (HitM is currently acting DPO)

**Timeline:**
- T+0h: Breach detected / confirmed
- T+72h: NPC notification deadline (do not miss this)
- T+72h: Individual notification to affected users (simultaneous or as soon as practicable)
- T+30d: Follow-up report to NPC if investigation is still ongoing

> **Attorney note:** NPC notification templates and the exact form requirements should be confirmed with PH counsel before this plan needs to be used. This section reflects current understanding of RA 10173; the law may have updated guidance.

---

## §6 User Notification

**Trigger:** Any P0/P1 incident where user data was or may have been accessed.

Send to all affected users (or all users if scope is unknown) via email from Proton.

**Template:**

> **Subject:** Important security notice — The Hive Financial Manager
>
> Dear [username],
>
> I'm writing to inform you of a security incident affecting The Hive Financial Manager that I became aware of on [date].
>
> **What happened:** [Brief description — e.g., "an unauthorized party gained access to our database."]
>
> **What information was involved:** [e.g., "your username, email address, and transaction records may have been accessed. Passwords are stored as one-way hashes and were not exposed in a usable form."]
>
> **What I've done:** [e.g., "I have immediately taken the service offline, rotated all credentials, and am investigating the full scope of the incident."]
>
> **What you should do:**
> - Change your password when the service is restored, even though passwords were not exposed in plaintext
> - Watch for phishing emails using your email address
>
> I take your data security seriously. I am sorry this happened and will provide updates as the investigation continues.
>
> — Patrick Proctor, The Hive Financial Manager

---

## §7 Post-Incident Review (Required)

After every P0/P1 incident, within 7 days:

1. Write a post-mortem (1–2 pages) answering:
   - What happened, and when?
   - How was it detected?
   - What was the timeline of response actions?
   - What data was accessed, and how many users were affected?
   - What was the root cause?
   - What changes prevent recurrence?

2. Append a summary to §9 Incident Log below.

3. Implement at least one concrete prevention measure before re-opening the service.

---

## §8 Response Checklist

- [ ] **Classify severity** (§1) — P0/P1/P2/P3
- [ ] **Containment** (§3): take offline → preserve logs → revoke sessions → rotate credentials
- [ ] **Scope assessment** (§4): what was accessed, how long, how many users
- [ ] **NPC notification** (§5): file within 72 hours if PH user data involved — **do not miss this deadline**
- [ ] **User notification** (§6): email affected users (simultaneous with NPC or as soon as practicable)
- [ ] **Service restoration**: only after credentials rotated and root cause understood
- [ ] **Post-mortem** (§7): within 7 days
- [ ] **Prevention measure**: implemented before re-opening

---

## §9 Incident Log

*(Append below. Do not modify entries above.)*

| Date | Severity | Summary | NPC filed? | Users notified? | Root cause | Prevention added |
|---|---|---|---|---|---|---|
| *(none yet)* | | | | | | |
