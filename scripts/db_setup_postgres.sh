#!/bin/bash

# Script to setup PostgreSQL credentials and prepare for migration
# Usage: ./scripts/db_setup_postgres.sh

set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
API_ENV="$REPO_ROOT/finance_manager_api/.env"
ROOT_ENV="$REPO_ROOT/.env"

echo "--- PostgreSQL Setup Utility ---"

# 1. Ensure API .env exists
if [ ! -f "$API_ENV" ]; then
    echo "Creating $API_ENV from template..."
    # If it doesn't exist, we create a basic one
    cat <<EOF > "$API_ENV"
SECRET_KEY=$(openssl rand -hex 32)
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
EOF
fi

# 2. Generate secure password if not set or if it's the default
CURRENT_PASS=$(grep "^DB_PASSWORD=" "$API_ENV" | cut -d'=' -f2)
if [[ -z "$CURRENT_PASS" || "$CURRENT_PASS" == "finance_password" || "$CURRENT_PASS" == "# finance_password" ]]; then
    NEW_PASS=$(openssl rand -base64 16 | tr -d '/+=')
    echo "Generating new secure database password..."
    
    # Remove existing commented or uncommented DB settings
    sed -i '/^#\? DB_/d' "$API_ENV"
    sed -i '/^# Database Settings/d' "$API_ENV"
    sed -i '/^# Default: sqlite/d' "$API_ENV"
    
    # Append new settings
    cat <<EOF >> "$API_ENV"

# Database Settings
DB_ENGINE=django.db.backends.postgresql
DB_NAME=finance_db
DB_USER=finance_user
DB_PASSWORD=$NEW_PASS
DB_HOST=127.0.0.1
DB_PORT=5432
EOF
    echo "Updated $API_ENV with new credentials."
else
    echo "Database password already exists in $API_ENV. Skipping generation."
fi

# 3. Synchronize to root .env for docker-compose
# We only copy the DB settings to the root .env
echo "Synchronizing credentials to root .env..."
grep "^DB_" "$API_ENV" > "$ROOT_ENV"

echo ""
echo "Setup complete!"
echo "1. Your new database password has been saved to $API_ENV and $ROOT_ENV"
echo "2. Please restart your containers to apply the new credentials:"
echo "   podman-compose down && podman-compose up -d"
echo "3. After they are up, run the migration script:"
echo "   ./scripts/db_migrate.sh"
echo "=========================================="
