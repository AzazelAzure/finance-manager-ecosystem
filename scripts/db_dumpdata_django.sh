#!/usr/bin/env bash
# Write a Django JSON fixture from the **currently configured** database
# (PostgreSQL in Docker/VPS or local SQLite). Use with scripts/db_import.sh to restore.
#
# Usage: from repo root, with API .env or env vars set for DB, e.g.:
#   DB_HOST=127.0.0.1 DB_NAME=... ./scripts/db_dumpdata_django.sh /path/to/backup.json
# Or inside the API container:
#   podman compose exec -T api /opt/scripts/db_dumpdata_django.sh  (if mounted)
# Typical local:
#   (cd finance_manager_api && set -a && source .env && set +a && ../scripts/db_dumpdata_django.sh dump.json)
#
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [[ -n "${1:-}" && "${1:0:1}" == / ]]; then
  OUT_FILE="$1"
else
  OUT_FILE="${REPO_ROOT}/${1:-data_dump_django.json}"
fi
API_DIR="${REPO_ROOT}/finance_manager_api"
cd "$API_DIR"
if [ -f ".venv/bin/python" ]; then
  PYTHON_CMD="uv run python"
else
  PYTHON_CMD="python3"
fi
mkdir -p "$(dirname "$OUT_FILE")"
echo "--- Django dumpdata -> ${OUT_FILE} ---"
$PYTHON_CMD manage.py dumpdata \
  --natural-foreign \
  --natural-primary \
  -e contenttypes \
  -e auth.Permission \
  --indent 2 \
  > "$OUT_FILE"
echo "Wrote: $OUT_FILE"
echo "Restore (on target with same migrations): (repo)/scripts/db_import.sh $OUT_FILE"
