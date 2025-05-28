#!/bin/sh

PROJECT="$1"

PORT=${REAPER_PORT:-2222}
CON_TIMEOUT=${REAPER_CON_TIMEOUT:-10}  # in seconds

if [ -z "$PROJECT" ]; then
    echo "Usage: compose-reaper COMPOSE_PROJECT_NAME"
    exit 1
fi

echo ":: Monitoring docker compose project: $PROJECT"
echo ":: Keep alive port: $PORT"
echo ":: Connection timeout: $CON_TIMEOUT sec"
echo

echo ":: Waiting for connection"

# Only busybox nc supports connection timeout
nc -l -p "$PORT" -w "$CON_TIMEOUT" -v

echo ":: Connect timeout or connection closed"
echo ":: Shutting down docker compose project"

docker compose -p "$PROJECT" down

echo ":: Done"

