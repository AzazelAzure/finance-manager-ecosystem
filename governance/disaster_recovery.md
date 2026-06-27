# Disaster Recovery Plan

**Last updated:** 2026-06-27
**Owner:** HitM (Patrick Proctor)
**Scope:** Finance Manager ecosystem — VPS, database, blue/green Docker, DNS/Cloudflare
**Exclusions:** Client device data loss (Dexie is local; recovery requires user action)

---

## §1 Severity Levels

| Level | Description | Example | Target recovery |
|---|---|---|---|
| S1 | Single container crashed; VPS otherwise healthy | Nginx died; API OOM-killed | < 15 minutes via `fm_server_beta.sh` |
| S2 | Active color fully down; inactive color is healthy | Blue deployment broken after a bad push | < 30 minutes via color switch |
| S3 | Both colors down; VPS running | Migration gone wrong; all containers dead | < 2 hours via rebuild |
| S4 | VPS unrecoverable | Provider failure, billing lapse, catastrophic disk failure | < 8 hours via new VPS provision |
| S5 | Data corruption or loss | Bad migration, accidental `DROP TABLE` | < 12 hours via backup restore |

---

## §2 S1 — Single Container Recovery

Use `fm_server_beta.sh` on the VPS:

```bash
ssh dev@159.198.75.194
sudo /opt/fm/fm_server_beta.sh status          # identify which container is down
sudo /opt/fm/fm_server_beta.sh rebuild-color blue   # or green
sudo /opt/fm/fm_server_beta.sh smoke blue      # verify before re-routing
```

If a container keeps crashing, check logs before rebuilding:

```bash
sudo docker logs fm-api-blue --tail 50
sudo docker logs fm-web-blue --tail 50
sudo docker logs fm-celery-blue --tail 50
```

---

## §3 S2 — Color Switch (Active Color Broken, Inactive Healthy)

If the active color is broken and the inactive color has the prior stable version:

```bash
ssh dev@159.198.75.194
sudo /opt/fm/fm_server_beta.sh status              # confirm inactive color is healthy
sudo /opt/fm/fm_server_beta.sh switch              # routes traffic to inactive color
sudo /opt/fm/fm_server_beta.sh smoke <new_active>  # verify
```

Traffic is restored within minutes. Then diagnose and fix the broken color offline.

---

## §4 S3 — Full Rebuild (Both Colors Down)

```bash
ssh dev@159.198.75.194
sudo /opt/fm/fm_server_beta.sh rebuild-color blue
sudo /opt/fm/fm_server_beta.sh smoke blue
# If smoke passes:
sudo /opt/fm/fm_server_beta.sh switch   # route to blue
sudo /opt/fm/fm_server_beta.sh rebuild-color green
```

If rebuild itself fails, check:
1. Docker image pull access (is the registry reachable?)
2. `.env` / secrets present in the expected location
3. Port conflicts (`netstat -tlnp | grep 8443`)
4. Disk space (`df -h`)

---

## §5 S4 — VPS Unrecoverable (New Server Provision)

This is the multi-hour scenario. Work through it in order.

### 5.1 Provision replacement VPS

- Provider: Namecheap VPS (phoenixNAP datacenter, Phoenix AZ)
- Spec: match current plan (check last invoice for tier)
- OS: match current (check server install guide in `docs/server_install_guide.md` or equivalent)
- New IP: note it — DNS update required

### 5.2 Restore from backup

- Retrieve the most recent backup from wherever `backup_db.sh` stores it (verify this location — see §9 Open Questions)
- Copy to new VPS: `scp backup.sql.gz dev@NEW_IP:/tmp/`
- On new VPS: `gunzip -c /tmp/backup.sql.gz | psql -U fm_user fm_db`

### 5.3 Run server bootstrap

```bash
ssh dev@NEW_IP
# Follow docs/server_install_guide.md:
# 1. Install Docker, Docker Compose, Nginx, Certbot
# 2. Copy .env / secrets from local .secrets/ backup
# 3. Clone parent repo + submodules
# 4. Run fm_server_beta.sh rebuild-color blue
# 5. Run smoke
```

### 5.4 Update DNS

- Log into Namecheap DNS (or Cloudflare, depending on where the A record lives)
- Update the A record pointing to the old IP to the new IP
- TTL propagation: if TTL was 300s, recovery is fast; if 3600s, plan for up to 1 hour of DNS lag
- Cloudflare caches the origin IP — update Cloudflare DNS records if Cloudflare is the authoritative DNS

### 5.5 Re-issue SSL certificate

```bash
# On new VPS after DNS propagates:
sudo certbot certonly --webroot -w /var/www/certbot -d yourdomain.com
# Or use the certbot_renew.sh script if it handles initial issuance
```

### 5.6 Verify

```bash
sudo /opt/fm/fm_server_beta.sh smoke blue
curl -I https://yourdomain.com:8443
```

---

## §6 S5 — Database Recovery (Corruption or Data Loss)

> **Before restoring:** Identify the scope. If only some rows are affected, a point-in-time restore may be possible. If the database is fully corrupted, full restore is required.

### 6.1 Stop all writes

```bash
# Take the active color offline temporarily to prevent further writes:
sudo /opt/fm/fm_server_beta.sh switch   # route to inactive (or take both offline)
```

### 6.2 Restore from backup

```bash
# On VPS:
dropdb -U fm_user fm_db                          # drop the corrupted DB
createdb -U fm_user fm_db                        # create fresh
gunzip -c /backups/fm_db_YYYY-MM-DD.sql.gz | psql -U fm_user fm_db
```

### 6.3 Run migrations to catch up (if backup predates recent migrations)

```bash
sudo docker exec -it fm-api-blue python manage.py migrate --no-input
```

### 6.4 Restore service

```bash
sudo /opt/fm/fm_server_beta.sh smoke blue
sudo /opt/fm/fm_server_beta.sh switch   # re-route to active
```

### 6.5 User notification

If any user data was permanently lost (rows not in the backup), this is a data breach / data loss event. Follow the incident response plan (`governance/incident_response.md`).

---

## §7 Beta Tester Communication

For S4/S5 (multi-hour outages) during beta:

- Channel: direct email to beta tester list (Proton)
- Template:

> **Subject:** The Hive — temporary service interruption
>
> The Hive Financial Manager is temporarily offline due to [infrastructure issue / maintenance]. I'm working on restoring it and expect it to be back by [time estimate].
>
> Your data is safe. [If data loss occurred: some transactions from [date range] may need to be re-entered — I'll follow up with specifics.]
>
> — Patrick

---

## §8 Recovery Checklist (print and follow in order)

- [ ] Identify severity level (§1)
- [ ] S1: restart containers via `fm_server_beta.sh`
- [ ] S2: switch colors via `fm_server_beta.sh switch`
- [ ] S3: rebuild both colors
- [ ] S4: provision new VPS → restore backup → bootstrap → update DNS → re-issue SSL
- [ ] S5: stop writes → restore DB → run migrations → restore service
- [ ] Run smoke test (`fm_server_beta.sh smoke <color>`)
- [ ] If S4/S5: send beta tester communication
- [ ] If data loss: file incident response (`governance/incident_response.md`)
- [ ] Post-recovery: document what happened and how it was fixed (append to §10 below)
- [ ] Post-recovery: identify root cause; add prevention step or monitoring

---

## §9 Open Questions (verify and fill in)

| Question | Answer |
|---|---|
| Where does `backup_db.sh` store backups? | *Verify on VPS: check the script header or `crontab -l`* |
| Is `backup_db.sh` running on a schedule? | *Check `systemctl list-timers` and `crontab -l` on VPS* |
| Are backups stored offsite (not just local VPS disk)? | **Decided 2026-06-27:** Local cron on HitM's dev machine pulls compressed pg_dump over SSH daily. Script lives at `scripts/server/pull_backup.sh`. VPS backup manager service not used (out of budget). |
| What is the Namecheap DNS TTL for the main domain A record? | *Check Namecheap DNS panel* |
| Where is the local `.secrets/` backup kept? | *Should be in `.secrets/` on HitM's machine — verify before needed* |

> **Backup approach (decided 2026-06-27):** Daily cron on HitM's local machine: `ssh dev@VPS_IP "pg_dump ... | gzip" > ~/fm_backups/fm_db_DATE.sql.gz`. Offsite relative to VPS — survives S4. Gap: backup only as current as last run while dev machine was on. Acceptable for beta. Script generation queued for next session.

---

## §10 Incident Log

*(Append recovery events below. Do not modify entries above.)*

| Date | Severity | What happened | Resolution | Downtime |
|---|---|---|---|---|
| *(none yet)* | | | | |
