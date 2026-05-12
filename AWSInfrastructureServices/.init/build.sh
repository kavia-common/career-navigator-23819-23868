#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/career-navigator-23819-23868/AWSInfrastructureServices"
cd "$WORKSPACE"
# Build production artifacts non-interactively
npm run build --silent || { echo 'build failed' >&2; exit 2; }
