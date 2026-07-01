#!/bin/bash

# Comprehensive migration script: SQLite -> PostgreSQL
# Usage: ./scripts/db_migrate.sh

set -e

SCRIPT_DIR="$(dirname "$0")"
DUMP_FILE="migration_dump_$(date +%Y%m%d_%H%M%S).json"

# Load environment variables from root or API .env if they exist
if [ -f "$SCRIPT_DIR/../../.env" ]; then
    export $(grep -v '^#' "$SCRIPT_DIR/../../.env" | xargs)
elif [ -f "$SCRIPT_DIR/../../finance_manager_api/.env" ]; then
    export $(grep -v '^#' "$SCRIPT_DIR/../../finance_manager_api/.env" | xargs)
fi

echo "=========================================="
echo "   Finance Manager DB Migration Utility   "
echo "=========================================="

# 1. Export Data
bash "$SCRIPT_DIR/db_export.sh" "$DUMP_FILE"

echo ""
echo "Step 1/2 complete: Data exported to $DUMP_FILE"
echo ""

# 2. Check if Postgres is reachable
echo "Checking PostgreSQL connection (ensure 'db' container is up)..."
# We try to run a simple check, if it fails we warn the user.
if [ -f "$SCRIPT_DIR/../../finance_manager_api/.venv/bin/python" ]; then
    (
        cd "$SCRIPT_DIR/../../finance_manager_api"
        uv run python -c "
import os, psycopg
try:
    psycopg.connect(
        dbname=os.getenv('DB_NAME', 'finance_db'),
        user=os.getenv('DB_USER', 'finance_user'),
        password=os.getenv('DB_PASSWORD', 'finance_password'),
        host=os.getenv('DB_HOST', '127.0.0.1'),
        port=os.getenv('DB_PORT', '5432'),
        connect_timeout=3
    )
    print('Connection successful.')
except Exception as e:
    print(f'Connection failed: {e}')
    exit(1)
"
    )
else
    python3 -c "
import os, psycopg
try:
    psycopg.connect(
        dbname=os.getenv('DB_NAME', 'finance_db'),
        user=os.getenv('DB_USER', 'finance_user'),
        password=os.getenv('DB_PASSWORD', 'finance_password'),
        host=os.getenv('DB_HOST', '127.0.0.1'),
        port=os.getenv('DB_PORT', '5432'),
        connect_timeout=3
    )
    print('Connection successful.')
except Exception as e:
    print(f'Connection failed: {e}')
    exit(1)
"
fi || {
    echo "Error: Cannot connect to PostgreSQL."
    echo "Make sure the database is running (e.g., 'docker-compose up -d db')."
    echo "You can run the import later using: ./scripts/db_import.sh $DUMP_FILE"
    exit 1
}

# 3. Import Data
bash "$SCRIPT_DIR/db_import.sh" "$DUMP_FILE"

echo ""
echo "=========================================="
echo "Migration finished successfully!"
echo "Temporary dump file: $DUMP_FILE"
echo "=========================================="
