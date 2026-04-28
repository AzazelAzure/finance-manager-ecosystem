#!/usr/bin/env bash

# Finance Manager Docker Management Script
# Handles docker-compose / podman-compose commands

# Base paths
BASE_DIR="/home/pproctor/Documents/python/finance_manager"
DOCKER_COMPOSE_FILE="$BASE_DIR/docker-compose.yml"

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

cd "$BASE_DIR" || exit 1

stop_services() {
    echo "Stopping Finance Manager Docker services using $DOCKER_COMPOSE_CMD..."
    $DOCKER_COMPOSE_CMD -f "$DOCKER_COMPOSE_FILE" down
}

build_services() {
    echo "Building Finance Manager Docker images using $DOCKER_COMPOSE_CMD..."
    $DOCKER_COMPOSE_CMD -f "$DOCKER_COMPOSE_FILE" build
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
            $DOCKER_COMPOSE_CMD -f "$DOCKER_COMPOSE_FILE" up $BUILD_FLAG -d
            echo "Services started in background."
        else
            $DOCKER_COMPOSE_CMD -f "$DOCKER_COMPOSE_FILE" up $BUILD_FLAG -d
            echo "Services started. Tailing logs (Ctrl+C to stop tailing, services will keep running)..."
            $DOCKER_COMPOSE_CMD -f "$DOCKER_COMPOSE_FILE" logs -f
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
        $DOCKER_COMPOSE_CMD -f "$DOCKER_COMPOSE_FILE" build --no-cache
        echo "Starting services with --force-recreate..."
        $DOCKER_COMPOSE_CMD -f "$DOCKER_COMPOSE_FILE" up --force-recreate -d
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
            $DOCKER_COMPOSE_CMD -f "$DOCKER_COMPOSE_FILE" up $BUILD_FLAG -d
            echo "Services started in background."
        else
            $DOCKER_COMPOSE_CMD -f "$DOCKER_COMPOSE_FILE" up $BUILD_FLAG -d
            echo "Services started. Tailing logs (Ctrl+C to stop tailing, services will keep running)..."
            $DOCKER_COMPOSE_CMD -f "$DOCKER_COMPOSE_FILE" logs -f
        fi
        ;;
    status)
        $DOCKER_COMPOSE_CMD -f "$DOCKER_COMPOSE_FILE" ps
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
