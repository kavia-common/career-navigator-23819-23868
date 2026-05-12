#!/usr/bin/env bash
set -euo pipefail
WORKSPACE="/home/kavia/workspace/code-generation/career-navigator-23819-23868/AWSInfrastructureServices"
mkdir -p "$WORKSPACE" && cd "$WORKSPACE"
# Create minimal package.json only if missing
if [ ! -f package.json ]; then
  cat > package.json <<'JSON'
{
  "name": "awsinfrastructureservices",
  "version": "0.1.0",
  "private": true,
  "engines": { "node": ">=18" },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "jest --runInBand --watchAll=false"
  }
}
JSON
fi
mkdir -p public src
cat > public/index.html <<'HTML'
<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>AWSInfrastructureServices</title></head><body><div id="root"></div></body></html>
HTML
cat > src/index.js <<'JS'
import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';
const root = createRoot(document.getElementById('root'));
root.render(<App />);
JS
cat > src/App.js <<'JS'
import React from 'react';
export default function App(){return React.createElement('div',null,'AWSInfrastructureServices - dev server');}
JS
# .env for headless runtime (idempotent)
if [ ! -f .env ]; then
  cat > .env <<'ENV'
PORT=3000
BROWSER=none
ENV
fi
exit 0
