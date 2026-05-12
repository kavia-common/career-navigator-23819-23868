#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/career-navigator-23819-23868/AWSInfrastructureServices"
cd "$WORKSPACE"
# Build to validate production build path (non-interactive)
npm run build --silent || { echo 'build failed' >&2; exit 2; }
# Source .env into this shell to obtain PORT and BROWSER
if [ -f "$WORKSPACE/.env" ]; then
  set -a; source "$WORKSPACE/.env"; set +a
fi
PORT=${PORT:-3000}
: "Ensure NODE_ENV and BROWSER are set for the spawned process"
export NODE_ENV=${NODE_ENV:-development}
export BROWSER=${BROWSER:-none}
# Start dev server in background capturing logs
LOG=/tmp/awsinfra_dev_server.log
PIDFILE=/tmp/awsinfra_dev_server.pid
nohup env NODE_ENV="$NODE_ENV" BROWSER="$BROWSER" PORT="$PORT" npm start --silent >"$LOG" 2>&1 &
PID=$!
echo "$PID" > "$PIDFILE"
# Wait for server to accept connections with retries (longer timeout)
TRIES=0; MAX=60
until curl -sS "http://127.0.0.1:${PORT}/" -o /tmp/awsinfra_index.html >/dev/null 2>&1 || [ $TRIES -ge $MAX ]; do sleep 1; TRIES=$((TRIES+1)); done
if [ $TRIES -ge $MAX ]; then echo 'dev server did not start in time' >&2; kill "$PID" 2>/dev/null || true; tail -n 50 "$LOG" || true; exit 3; fi
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:${PORT}/")
if [ "$HTTP_CODE" != "200" ] && [ "$HTTP_CODE" != "302" ]; then echo "unexpected HTTP code: $HTTP_CODE" >&2; kill "$PID" 2>/dev/null || true; tail -n 50 "$LOG" || true; exit 4; fi
# Stronger evidence: check for application title or root div
if ! grep -q "AWSInfrastructureServices" /tmp/awsinfra_index.html 2>/dev/null; then echo 'expected content not found in index HTML' >&2; kill "$PID" 2>/dev/null || true; tail -n 50 "$LOG" || true; exit 5; fi
# Clean stop
kill "$PID" || true
wait "$PID" 2>/dev/null || true
rm -f "$PIDFILE" || true
# Evidence: print tail of server log
tail -n 50 "$LOG" || true
exit 0
