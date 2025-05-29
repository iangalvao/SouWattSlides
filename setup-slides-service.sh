#!/bin/bash
set -e

# Detect user info and working dir
USER_NAME="$(whoami)"
USER_HOME="$HOME"
APP_DIR="$(pwd)"
USER_SYSTEMD_DIR="$USER_HOME/.config/systemd/user"
SERVICE_NAME="SouWattSlides.service"
PORT=5176

echo "🔧 Iniciando setup de serviço systemd para o slideshow..."

echo "📁 Criando diretório $USER_SYSTEMD_DIR (se necessário)..."
mkdir -p "$USER_SYSTEMD_DIR"

write_service() {
  local target="$1"
  local content="$2"

  if [ -f "$target" ]; then
    if ! diff -q <(echo "$content") "$target" > /dev/null; then
      cp "$target" "$target.bak"
      echo "$content" > "$target"
      echo "🔁 Atualizado $target (backup em .bak)"
    else
      echo "✅ $target já está atualizado"
    fi
  else
    echo "$content" > "$target"
    echo "➕ Criado $target"
  fi
}

write_service "$USER_SYSTEMD_DIR/$SERVICE_NAME" "
[Unit]
Description=SouWattSlides Local HTTP Server
After=default.target

[Service]
Type=simple
WorkingDirectory=$APP_DIR
ExecStart=/usr/bin/make run PORT=$PORT
Restart=on-failure
RestartSec=2

[Install]
WantedBy=default.target
"

echo "🔄 Habilitando lingering para $USER_NAME..."
sudo loginctl enable-linger "$USER_NAME"

if [ "$(whoami)" = "$USER_NAME" ]; then
  echo "🔁 Recarregando systemd do usuário..."
  systemctl --user daemon-reload
  echo "🟢 Habilitando e iniciando o serviço..."
  systemctl --user enable $SERVICE_NAME
  systemctl --user start $SERVICE_NAME
  echo "✅ Serviço configurado com sucesso!"
else
  echo "⚠️ Você não está logado como $USER_NAME, portanto o serviço do usuário não foi ativado agora."
  echo "👉 Para finalizar, entre como $USER_NAME e rode:"
  echo "   systemctl --user daemon-reload"
  echo "   systemctl --user enable $SERVICE_NAME"
  echo "   systemctl --user start $SERVICE_NAME"
  echo " Ou então rode na pasta SouWattSlides:"
  echo "   make enable-service"
  echo "   make start"
fi
