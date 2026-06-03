#!/usr/bin/env bash
# Hydeense — главный установочный скрипт
#
# Использование:
#   ./install.sh --all              # Установить все модули
#   ./install.sh --module base      # Установить конкретный модуль
#   ./install.sh --dry-run --all    # Показать что будет сделано
#   ./install.sh --list             # Показать доступные модули

set -euo pipefail

HYDEENSE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export HYDEENSE_DIR

# Загружаем утилиты
source "$HYDEENSE_DIR/lib/utils.sh"
source "$HYDEENSE_DIR/lib/packages.sh"
source "$HYDEENSE_DIR/lib/dotfiles.sh"

# Доступные модули (порядок важен — зависимости идут первыми)
AVAILABLE_MODULES=(
  base
  git
  shell
  nvim
  tmux
  podman
)

# --- Парсинг аргументов ---

DRY_RUN="false"
SELECTED_MODULES=()
SHOW_LIST=false

usage() {
  echo "Hydeense — сборка рабочего окружения Arch Linux"
  echo ""
  echo "Использование:"
  echo "  ./install.sh [опции]"
  echo ""
  echo "Опции:"
  echo "  --all              Установить все модули"
  echo "  --module <name>    Установить конкретный модуль (можно указать несколько раз)"
  echo "  --dry-run          Показать что будет сделано, без реальных изменений"
  echo "  --list             Показать доступные модули"
  echo "  --help             Показать эту справку"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  --all)
    SELECTED_MODULES=("${AVAILABLE_MODULES[@]}")
    shift
    ;;
  --module)
    if [[ -z "${2:-}" ]]; then
      log_error "Не указано имя модуля после --module"
      exit 1
    fi
    SELECTED_MODULES+=("$2")
    shift 2
    ;;
  --dry-run)
    DRY_RUN="true"
    shift
    ;;
  --list)
    SHOW_LIST=true
    shift
    ;;
  --help | -h)
    usage
    exit 0
    ;;
  *)
    log_error "Неизвестный аргумент: $1"
    usage
    exit 1
    ;;
  esac
done

export DRY_RUN

# --- Показать список модулей ---

if [[ "$SHOW_LIST" == "true" ]]; then
  echo "Доступные модули:"
  for mod in "${AVAILABLE_MODULES[@]}"; do
    echo "  - $mod"
  done
  exit 0
fi

# --- Валидация ---

if [[ ${#SELECTED_MODULES[@]} -eq 0 ]]; then
  log_error "Не указаны модули. Используй --all или --module <name>"
  usage
  exit 1
fi

# Проверяем что все модули существуют
for mod in "${SELECTED_MODULES[@]}"; do
  if [[ ! -f "$HYDEENSE_DIR/modules/$mod.sh" ]]; then
    log_error "Модуль не найден: $mod"
    log_error "Используй --list чтобы увидеть доступные модули"
    exit 1
  fi
done

# --- Проверка что запущено НЕ от root ---

deny_root

# --- Запрос sudo (пароль один раз) ---

init_sudo

# --- Запуск модулей ---

echo ""
log_info "=============================="
log_info " Hydeense installer"
log_info "=============================="
if [[ "$DRY_RUN" == "true" ]]; then
  log_warn "Режим DRY-RUN: изменения не будут применены"
fi
echo ""

for mod in "${SELECTED_MODULES[@]}"; do
  echo ""
  log_info "--- Модуль: $mod ---"
  source "$HYDEENSE_DIR/modules/$mod.sh"
  echo ""
done

log_info "=============================="
log_info " Готово!"
log_info "=============================="
