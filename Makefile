PORT ?= 5176
SERVICE_NAME = SouWattSlides.service
SERVICE_PATH = ~/.config/systemd/user/$(SERVICE_NAME)
RUN_SCRIPT = run.sh
CREATE_SERVICE_SCRIPT = setup-slides-service.sh
REMOVE_SERVICE_SCRIPT = remove-service.sh
SHOW_ADDRESS_SCRIPT = show-slideshow-address.sh
.PHONY: all run create-service remove-service enable disable start stop restart status logs

all: install

install:
	chmod +x $(RUN_SCRIPT) $(CREATE_SERVICE_SCRIPT) $(REMOVE_SERVICE_SCRIPT)
	bash $(CREATE_SERVICE_SCRIPT)
	@bash $(SHOW_ADDRESS_SCRIPT)
run:
	PORT=$(PORT) bash $(RUN_SCRIPT)

create-service:
	@echo "🔧 Creating systemd service..."
	bash $(CREATE_SERVICE_SCRIPT)

remove-service:
	@echo "🗑️ Removing systemd service..."
	@bash $(REMOVE_SERVICE_SCRIPT)

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

clean:
	bash $(REMOVE_SERVICE_SCRIPT)

show-address:
	@bash $(SHOW_ADDRESS_SCRIPT)
