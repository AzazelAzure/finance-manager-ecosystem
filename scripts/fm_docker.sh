#!/usr/bin/env bash

# Finance Manager Docker Management Script
# Handles docker-compose / podman-compose commands

# Base paths (portable across host/VM)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR_DEFAULT="$(cd "$SCRIPT_DIR/.." && pwd)"
BASE_DIR="${FM_BASE_DIR:-$BASE_DIR_DEFAULT}"
DOCKER_COMPOSE_FILE="$BASE_DIR/docker-compose.yml"
DEFAULT_ENV_FILE="$BASE_DIR/.secrets/server.env"
FALLBACK_ENV_FILE="$BASE_DIR/.env"
ENV_FILE="${FM_ENV_FILE:-}"
COMPOSE_ARGS=(-f "$DOCKER_COMPOSE_FILE")

# Detect compose command
if command -v podman-compose &> /dev/null; then
    DOCKER_COMPOSE_CMD="podman-compose"
    CONTAINER_RUNTIME="podman"
elif command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker-compose"
    CONTAINER_RUNTIME="docker"
elif docker compose version &> /dev/null; then
    DOCKER_COMPOSE_CMD="docker compose"
    CONTAINER_RUNTIME="docker"
else
    echo "Error: No compose provider found (podman-compose, docker-compose, or docker compose)."
    echo "Note: podman-compose was recently installed to ~/.local/bin. Ensure this is in your PATH."
    exit 1
fi

if [[ ! -f "$DOCKER_COMPOSE_FILE" ]]; then
    echo "Error: docker-compose file not found at '$DOCKER_COMPOSE_FILE'."
    echo "Hint: set FM_BASE_DIR to your finance_manager repo root."
    exit 1
fi

if [[ -z "$ENV_FILE" ]]; then
    if [[ -f "$DEFAULT_ENV_FILE" ]]; then
        ENV_FILE="$DEFAULT_ENV_FILE"
    elif [[ -f "$FALLBACK_ENV_FILE" ]]; then
        ENV_FILE="$FALLBACK_ENV_FILE"
    fi
fi

if [[ -n "$ENV_FILE" ]]; then
    COMPOSE_ARGS+=(--env-file "$ENV_FILE")
fi

cd "$BASE_DIR" || exit 1

stop_services() {
    echo "Stopping Finance Manager Docker services using $DOCKER_COMPOSE_CMD..."
    $DOCKER_COMPOSE_CMD "${COMPOSE_ARGS[@]}" down
}

build_services() {
    echo "Building Finance Manager Docker images using $DOCKER_COMPOSE_CMD..."
    $DOCKER_COMPOSE_CMD "${COMPOSE_ARGS[@]}" build
}

case "$1" in
    start)
        HEADLESS=true
        BUILD_FLAG=""
        if [[ "$*" == *"--head"* ]]; then
            HEADLESS=false
        fi
        if [[ "$*" == *"--build"* ]] || [[ "$*" == *"--rebuild"* ]]; then
            BUILD_FLAG="--build"
        fi
        
        echo "Starting Finance Manager Docker services using $DOCKER_COMPOSE_CMD..."
        if [ "$HEADLESS" = true ]; then
            $DOCKER_COMPOSE_CMD "${COMPOSE_ARGS[@]}" up $BUILD_FLAG -d
            echo "Services started in background."
        else
            $DOCKER_COMPOSE_CMD "${COMPOSE_ARGS[@]}" up $BUILD_FLAG -d
            echo "Services started. Tailing logs (Ctrl+C to stop tailing, services will keep running)..."
            $DOCKER_COMPOSE_CMD "${COMPOSE_ARGS[@]}" logs -f
        fi
        ;;
    stop)
        stop_services
        ;;
    build)
        build_services
        ;;
    rebuild)
        stop_services
        echo "Building Finance Manager Docker images (no-cache)..."
        $DOCKER_COMPOSE_CMD "${COMPOSE_ARGS[@]}" build --no-cache
        echo "Starting services with --force-recreate..."
        $DOCKER_COMPOSE_CMD "${COMPOSE_ARGS[@]}" up --force-recreate -d
        ;;
    restart)
        stop_services
        sleep 2
        
        HEADLESS=true
        BUILD_FLAG=""
        if [[ "$*" == *"--head"* ]]; then
            HEADLESS=false
        fi
        if [[ "$*" == *"--build"* ]] || [[ "$*" == *"--rebuild"* ]]; then
            BUILD_FLAG="--build"
        fi

        echo "Restarting Finance Manager Docker services using $DOCKER_COMPOSE_CMD..."
        if [ "$HEADLESS" = true ]; then
            $DOCKER_COMPOSE_CMD "${COMPOSE_ARGS[@]}" up $BUILD_FLAG -d
            echo "Services started in background."
        else
            $DOCKER_COMPOSE_CMD "${COMPOSE_ARGS[@]}" up $BUILD_FLAG -d
            echo "Services started. Tailing logs (Ctrl+C to stop tailing, services will keep running)..."
            $DOCKER_COMPOSE_CMD "${COMPOSE_ARGS[@]}" logs -f
        fi
        ;;
    status)
        $DOCKER_COMPOSE_CMD "${COMPOSE_ARGS[@]}" ps
        ;;
    clean)
        stop_services
        echo "Pruning container system and volumes using $CONTAINER_RUNTIME..."
        if [ "$CONTAINER_RUNTIME" = "podman" ]; then
            podman system prune -f
            podman volume prune -f
        else
            docker system prune -f
            docker volume prune -f
        fi
        echo "Clean complete."
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|rebuild|build|status|clean} [--head] [--build]"
        exit 1
        ;;
esac
