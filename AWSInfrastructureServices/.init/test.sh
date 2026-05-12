#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/career-navigator-23819-23868/AWSInfrastructureServices"
cd "$WORKSPACE"
# Run tests once (non-watch). If project uses react-scripts, it accepts --watchAll=false
# Use npm test with CI-friendly flags where supported
npm test -- --watchAll=false --silent || { echo 'tests failed' >&2; exit 2; }
