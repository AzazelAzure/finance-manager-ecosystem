#!/bin/bash

# Script to import data into PostgreSQL for Finance Manager API
# Usage: ./scripts/db_import.sh [input_file.json]

set -e

# Default input file
INPUT_FILE=${1:-"data_dump.json"}
API_DIR="$(dirname "$0")/../finance_manager_api"

# Load environment variables from root or API .env if they exist
if [ -f "$(dirname "$0")/../.env" ]; then
    export $(grep -v '^#' "$(dirname "$0")/../.env" | xargs)
elif [ -f "$(dirname "$0")/../finance_manager_api/.env" ]; then
    export $(grep -v '^#' "$(dirname "$0")/../finance_manager_api/.env" | xargs)
fi

# PostgreSQL Configuration (Matching docker-compose.yml defaults)
export DB_ENGINE=${DB_ENGINE:-"django.db.backends.postgresql"}
export DB_NAME=${DB_NAME:-"finance_db"}
export DB_USER=${DB_USER:-"finance_user"}
export DB_PASSWORD=${DB_PASSWORD:-"finance_password"}
export DB_HOST=${DB_HOST:-"127.0.0.1"}
export DB_PORT=${DB_PORT:-"5432"}

echo "--- Importing Data to PostgreSQL ---"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: $INPUT_FILE not found."
    exit 1
fi

echo "Connecting to $DB_NAME at $DB_HOST:$DB_PORT..."

(
    cd "$API_DIR"
    
    if [ -f ".venv/bin/python" ]; then
        PYTHON_CMD="uv run python"
    else
        PYTHON_CMD="python3"
    fi
    
    echo "Running migrations on PostgreSQL..."
    $PYTHON_CMD manage.py migrate
    
    echo "Loading data from $INPUT_FILE..."
    # We use loaddata to push the JSON dump into the new DB.
    $PYTHON_CMD manage.py loaddata "../$INPUT_FILE"
)

echo "Import completed successfully."
