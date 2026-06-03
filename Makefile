VM_HOST ?= archlinux.local
VM_REPO_DIR ?= ~/hydeense

.PHONY: install module deploy-vm test-vm dry-run list help

help: ## Показать справку
	@echo "Hydeense — Makefile targets"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Установить все модули
	./install.sh --all

module: ## Установить конкретный модуль: make module M=base
ifndef M
	$(error Укажи модуль: make module M=<name>)
endif
	./install.sh --module $(M)

dry-run: ## Показать что будет сделано (без изменений)
	./install.sh --dry-run --all

list: ## Показать доступные модули
	@./install.sh --list

deploy: ## Деплой и установка на VM через SSH
	ssh arch@$(VM_HOST) "rm -fr hydeense"
	scp -r "$$(pwd)" arch@$(VM_HOST):~

lint: ## Проверка скриптов через shellcheck
	shellcheck install.sh lib/*.sh modules/*.sh
