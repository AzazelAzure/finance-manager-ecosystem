#!/usr/bin/env bash

# Finance Manager Service Management Script
# Handles the Django API and Reflex Frontend

# Base paths
BASE_DIR="/home/pproctor/Documents/python/finance_manager"
API_DIR="$BASE_DIR/finance_manager_api"
REFLEX_DIR="$BASE_DIR/finance_manager_reflex"

# PID management
PID_DIR="$HOME/.fm_services"
API_PID_FILE="$PID_DIR/api.pid"
REFLEX_PID_FILE="$PID_DIR/reflex.pid"

mkdir -p "$PID_DIR"

# Ensure logs directories exist
mkdir -p "$API_DIR/logs"
mkdir -p "$REFLEX_DIR/logs"

# Service Logs
API_LOG="$API_DIR/logs/service.log"
REFLEX_LOG="$REFLEX_DIR/logs/service.log"

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
    
    # Stop Reflex
    if [ -f "$REFLEX_PID_FILE" ]; then
        PID=$(cat "$REFLEX_PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            kill -TERM "$PID" 2>/dev/null
            echo "Sent SIGTERM to Reflex (PID: $PID)"
            sleep 1
            if kill -0 "$PID" 2>/dev/null; then
                kill -KILL "$PID" 2>/dev/null
                echo "Sent SIGKILL to Reflex (PID: $PID)"
            fi
        fi
        rm "$REFLEX_PID_FILE"
    fi
    
    # Fallback to pkill for lingering processes
    pkill -f "manage.py runserver" 2>/dev/null
    pkill -f "reflex run" 2>/dev/null
    
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
    
    if [ -f "$REFLEX_PID_FILE" ] && kill -0 "$(cat "$REFLEX_PID_FILE")" 2>/dev/null; then
        echo "Reflex is already running (PID: $(cat "$REFLEX_PID_FILE"))"
    else
        echo "Starting Reflex..."
        cd "$REFLEX_DIR" || exit 1
        # Reflex default is 8000 for backend, but Django is there.
        # Running Reflex backend on 8001.
        # Ensure frontend websocket/event traffic targets Reflex backend (8001),
        # not Django API on 8000, to avoid repeated /_event 404 loops.
        nohup env REFLEX_DIR=.reflex REFLEX_API_URL=http://127.0.0.1:8001 uv run reflex run --env dev --backend-port 8001 > "$REFLEX_LOG" 2>&1 &
        echo $! > "$REFLEX_PID_FILE"
        echo "Reflex started (PID: $(cat "$REFLEX_PID_FILE"))"
    fi
    
    echo "Services started."
    
    if [ "$HEADLESS" = false ]; then
        echo ""
        echo "--------------------------------------------------"
        echo "Tailing logs (Ctrl+C to stop tailing, services will keep running)"
        echo "--------------------------------------------------"
        tail -f "$API_LOG" "$REFLEX_LOG"
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
        if [ -f "$REFLEX_PID_FILE" ] && kill -0 "$(cat "$REFLEX_PID_FILE")" 2>/dev/null; then
            echo "  Reflex: Running (PID: $(cat "$REFLEX_PID_FILE"))"
        else
            echo "  Reflex: Stopped"
        fi
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status} [--head]"
        exit 1
        ;;
esac
