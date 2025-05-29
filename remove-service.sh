#!/bin/bash
set -e

USER_NAME="$(whoami)"
USER_HOME="/home/$USER_NAME"
USER_SYSTEMD_DIR="$USER_HOME/.config/systemd/user"
SERVICE_NAME="SouWattSlides.service"
TARGET="$USER_SYSTEMD_DIR/$SERVICE_NAME"

echo "🛑 Stopping and disabling $SERVICE_NAME..."
systemctl --user stop "$SERVICE_NAME" || true
systemctl --user disable "$SERVICE_NAME" || true
echo "🔧 Disabling lingering for $USER_NAME..."
sudo loginctl disable-linger "$USER_NAME" || true

if [ -f "$TARGET" ]; then
  echo "🧹 Removing $TARGET..."
  rm "$TARGET"
  echo "🔁 Reloading systemd..."
  systemctl --user daemon-reload
  echo "✅ Service removed"
else
  echo "⚠️ Service file $TARGET not found"
fi
