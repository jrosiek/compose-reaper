#!/bin/sh

# Docker compose project name
PROJECT="$1"

# Keep alive port
PORT=${REAPER_PORT:-2222}

# How long should we wait for keep alive connection before entering reap mode
CON_TIMEOUT=${REAPER_CON_TIMEOUT:-30}  # in seconds

# How long should we wait after entering reap mode before actual reaping
# This is useful in debugging when we want to attach to the reaper process or see its logREAP_TIMEOUT=${REAPER_REAP_TIMEOUT:-60}  # in seconds
REAP_DELAY=${REAPER_REAP_DELAY:-60}  # in seconds

if [ -z "$PROJECT" ]; then
    echo "Usage: compose-reaper COMPOSE_PROJECT_NAME"
    exit 1
fi

echo ":: Monitoring docker compose project: $PROJECT"
echo ":: Keep alive port: $PORT"
echo ":: Connection timeout: $CON_TIMEOUT sec"
echo ":: Reap delay: $REAP_DELAY sec"
echo

echo ":: Waiting for connection"

# Only busybox nc supports connection timeout
nc -l -p "$PORT" -w "$CON_TIMEOUT" -v

echo ":: Connect timeout or connection closed"

echo ":: Delaying shutdown"
sleep "$REAP_DELAY"

echo ":: Shutting down docker compose project"

docker compose -p "$PROJECT" down

echo ":: Done"

