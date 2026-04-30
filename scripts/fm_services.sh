#!/usr/bin/env bash

# Finance Manager Service Management Script
# Handles local Django API process lifecycle.

# Base paths (portable across host/VM)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR_DEFAULT="$(cd "$SCRIPT_DIR/.." && pwd)"
BASE_DIR="${FM_BASE_DIR:-$BASE_DIR_DEFAULT}"
API_DIR="$BASE_DIR/finance_manager_api"

# PID management
PID_DIR="$HOME/.fm_services"
API_PID_FILE="$PID_DIR/api.pid"

mkdir -p "$PID_DIR"

# Ensure logs directory exists
mkdir -p "$API_DIR/logs"

if [[ ! -d "$API_DIR" ]]; then
    echo "Error: expected API directory not found under '$BASE_DIR'."
    echo "Hint: set FM_BASE_DIR to your finance_manager repo root."
    exit 1
fi

# Service Logs
API_LOG="$API_DIR/logs/service.log"

stop_services() {
    echo "Stopping Finance Manager services..."
    
    # Stop API
    if [ -f "$API_PID_FILE" ]; then
        PID=$(cat "$API_PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            # We try to kill the process group
            # Note: we use pkill -P to kill children first if possible, 
            # but since we started with setsid/nohup, we just kill the PID
            kill -TERM "$PID" 2>/dev/null
            echo "Sent SIGTERM to API (PID: $PID)"
            sleep 1
            if kill -0 "$PID" 2>/dev/null; then
                kill -KILL "$PID" 2>/dev/null
                echo "Sent SIGKILL to API (PID: $PID)"
            fi
        fi
        rm "$API_PID_FILE"
    fi
    
    # Fallback to pkill for lingering processes
    pkill -f "manage.py runserver" 2>/dev/null
    
    echo "Services stopped."
}

start_services() {
    HEADLESS=$1
    
    echo "Starting Finance Manager services..."
    
    # Check if already running
    if [ -f "$API_PID_FILE" ] && kill -0 "$(cat "$API_PID_FILE")" 2>/dev/null; then
        echo "API is already running (PID: $(cat "$API_PID_FILE"))"
    else
        echo "Starting API..."
        cd "$API_DIR" || exit 1
        nohup uv run python manage.py runserver 0.0.0.0:8000 > "$API_LOG" 2>&1 &
        echo $! > "$API_PID_FILE"
        echo "API started (PID: $(cat "$API_PID_FILE"))"
    fi
    
    echo "API service started."
    
    if [ "$HEADLESS" = false ]; then
        echo ""
        echo "--------------------------------------------------"
        echo "Tailing logs (Ctrl+C to stop tailing, services will keep running)"
        echo "--------------------------------------------------"
        tail -f "$API_LOG"
    fi
}

case "$1" in
    start)
        HEADLESS=true
        if [[ "$*" == *"--head"* ]]; then
            HEADLESS=false
        fi
        start_services "$HEADLESS"
        ;;
    stop)
        stop_services
        ;;
    restart)
        stop_services
        sleep 2
        HEADLESS=true
        if [[ "$*" == *"--head"* ]]; then
            HEADLESS=false
        fi
        start_services "$HEADLESS"
        ;;
    status)
        echo "Service Status:"
        if [ -f "$API_PID_FILE" ] && kill -0 "$(cat "$API_PID_FILE")" 2>/dev/null; then
            echo "  API: Running (PID: $(cat "$API_PID_FILE"))"
        else
            echo "  API: Stopped"
        fi
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status} [--head]"
        exit 1
        ;;
esac
