#!/bin/bash

# Script to export SQLite data from Finance Manager API
# Usage: ./scripts/db_export.sh [output_file.json]

set -e

# Default output file
OUTPUT_FILE=${1:-"data_dump.json"}
API_DIR="$(dirname "$0")/../finance_manager_api"

echo "--- Exporting SQLite Data ---"

if [ ! -f "$API_DIR/db.sqlite3" ]; then
    echo "Error: $API_DIR/db.sqlite3 not found."
    exit 1
fi

# Ensure we are using SQLite by clearing DB environment variables for this command
# Natural foreign/primary keys are used to ensure data integrity across different DB backends.
# We exclude contenttypes and auth.Permission as they are auto-generated during migrations.
echo "Dumping data to $OUTPUT_FILE..."
(
    cd "$API_DIR"
    export DB_ENGINE=""
    if [ -f ".venv/bin/python" ]; then
        PYTHON_CMD="uv run python"
    else
        PYTHON_CMD="python3"
    fi
    $PYTHON_CMD manage.py dumpdata \
        --natural-foreign \
        --natural-primary \
        -e contenttypes \
        -e auth.Permission \
        --indent 4 \
        > "../$OUTPUT_FILE"
)

echo "Export completed: $OUTPUT_FILE"
