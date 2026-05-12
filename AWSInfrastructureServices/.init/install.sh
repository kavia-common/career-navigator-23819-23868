#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/career-navigator-23819-23868/AWSInfrastructureServices"
cd "$WORKSPACE"
# If react-scripts binary exists, assume deps present
if [ -x "$WORKSPACE/node_modules/.bin/react-scripts" ]; then exit 0; fi
# prefer npm ci if lockfile exists for deterministic results
if [ -f package-lock.json ]; then
  npm ci --no-audit --no-fund --silent --no-progress
else
  # install core deps with exact versions derived from published latest at install time
  npm i --no-audit --no-fund --silent --no-progress react react-dom react-scripts jest --save --save-exact
fi
# validate key binaries
if [ ! -x "$WORKSPACE/node_modules/.bin/react-scripts" ]; then echo 'react-scripts missing after install' >&2; exit 4; fi
if ! npm --silent --prefix "$WORKSPACE" ls jest >/dev/null 2>&1; then echo 'jest missing after install' >&2; exit 5; fi
exit 0
