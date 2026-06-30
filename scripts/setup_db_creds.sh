#!/usr/bin/env bash

# Database Credential Setup Script
# Generates a random password and updates root and API .env files

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
API_ENV="$BASE_DIR/finance_manager_api/.env"
ROOT_ENV="$BASE_DIR/.env"

# Configuration
DB_NAME="finance_db"
DB_USER="finance_user"

# Generate a random 16-character hexadecimal password
DB_PASSWORD=$(openssl rand -hex 8)

echo "Generated new database password."

# Update or create root .env (for Docker)
echo "Updating root .env..."
cat > "$ROOT_ENV" << EOF
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASSWORD=$DB_PASSWORD
EOF

# Update API .env (for local dev)
if [ -f "$API_ENV" ]; then
    echo "Updating API .env..."
    # We use sed to uncomment and update the values
    # First, handle the lines if they are already there but commented
    sed -i "s/^# DB_ENGINE=.*/DB_ENGINE=django.db.backends.postgresql/" "$API_ENV"
    sed -i "s/^# DB_NAME=.*/DB_NAME=$DB_NAME/" "$API_ENV"
    sed -i "s/^# DB_USER=.*/DB_USER=$DB_USER/" "$API_ENV"
    sed -i "s/^# DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/" "$API_ENV"
    sed -i "s/^# DB_HOST=.*/DB_HOST=127.0.0.1/" "$API_ENV"
    sed -i "s/^# DB_PORT=.*/DB_PORT=5432/" "$API_ENV"
    
    # Also handle if they were already uncommented but need updating
    sed -i "s/^DB_NAME=.*/DB_NAME=$DB_NAME/" "$API_ENV"
    sed -i "s/^DB_USER=.*/DB_USER=$DB_USER/" "$API_ENV"
    sed -i "s/^DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/" "$API_ENV"
else
    echo "Warning: API .env not found at $API_ENV"
fi

echo "Database credentials set successfully."
echo "DB_NAME: $DB_NAME"
echo "DB_USER: $DB_USER"
echo "DB_PASSWORD: $DB_PASSWORD"
echo ""
echo "Note: If using Docker, you may need to restart your services for changes to take effect."
