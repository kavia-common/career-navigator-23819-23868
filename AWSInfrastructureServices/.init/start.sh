#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/career-navigator-23819-23868/AWSInfrastructureServices"
cd "$WORKSPACE"
# Load .env into environment for this process if present
if [ -f "$WORKSPACE/.env" ]; then
  set -a; source "$WORKSPACE/.env"; set +a
fi
PORT=${PORT:-3000}
export NODE_ENV=${NODE_ENV:-development}
export BROWSER=${BROWSER:-none}
LOG=/tmp/awsinfra_dev_server.log
PIDFILE=/tmp/awsinfra_dev_server.pid
# Start CRA dev server in background, capture logs and PID
nohup env NODE_ENV="$NODE_ENV" BROWSER="$BROWSER" PORT="$PORT" npm start --silent >"$LOG" 2>&1 &
PID=$!
# persist PID
echo "$PID" > "$PIDFILE"
# Give immediate feedback
echo "started pid=$PID port=$PORT log=$LOG pidfile=$PIDFILE"
