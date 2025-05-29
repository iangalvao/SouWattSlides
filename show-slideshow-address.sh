#!/bin/bash

PORT=5176

# Try to extract an IP from the network that starts with 10.50.*
IP=$(ip -4 addr show | grep -oP '10\.50\.\d+\.\d+' | head -n1)

# Fallback to any local IP if 10.50.* is not found
if [ -z "$IP" ]; then
  IP=$(hostname -I | awk '{print $1}')
fi

if [ -z "$IP" ]; then
  echo "❌ Could not determine IP address."
  exit 1
fi

echo "🌐 Slideshow available at: http://$IP:$PORT"
