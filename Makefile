VM_HOST ?= archlinux.local
VM_REPO_DIR ?= ~/hydeense

.PHONY: install eploy lint

install:
	./install.sh

deploy: ## Деплой и установка на VM через SSH
	ssh arch@$(VM_HOST) "rm -fr hydeense"
	scp -r "$$(pwd)" arch@$(VM_HOST):~

lint: ## Проверка скриптов через shellcheck
	shellcheck install.sh lib/*.sh modules/*.sh
