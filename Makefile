PORT ?= 5176
SERVICE_NAME = SouWattSlides.service
SERVICE_PATH = ~/.config/systemd/user/$(SERVICE_NAME)
RUN_SCRIPT = run.sh

.PHONY: all run create-service remove-service enable disable start stop restart status logs

all: create-service enable start

run:
	PORT=$(PORT) bash $(RUN_SCRIPT)

create-service:
	@echo "🔧 Creating systemd service..."
	bash setup_slides_service.sh

remove-service:
	@echo "🗑️ Removing systemd service..."
	@bash remove-service.sh

enable:
	systemctl --user enable $(SERVICE_NAME)

disable:
	systemctl --user disable $(SERVICE_NAME)

start:
	systemctl --user start $(SERVICE_NAME)

stop:
	systemctl --user stop $(SERVICE_NAME)

restart:
	systemctl --user restart $(SERVICE_NAME)

status:
	systemctl --user status $(SERVICE_NAME)

logs:
	journalctl --user -u $(SERVICE_NAME) -f
