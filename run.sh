#!/bin/bash
set -e

PORT=5176
cd "$(dirname "$0")/slides"

echo "🚀 Starting HTTP server on port $PORT..."
python3 -m http.server "$PORT"
