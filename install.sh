#!/usr/bin/env bash
# Hydeense — главный установочный скрипт
#
# Использование:
#   ./install.sh                    # Интерактивный выбор модулей (gum)
#   ./install.sh --all              # Установить все модули
#   ./install.sh --module base      # Установить конкретный модуль
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
SELECTED_MODULES=()

# --- Проверка что запущено НЕ от root ---

deny_root

# --- Запрос sudo (пароль один раз) ---

init_sudo

# --- Установка gum если нужен интерактив ---

if ! is_installed gum; then
  log_step "Установка gum для интерактивного меню"
  sudo pacman -S --needed --noconfirm gum
fi

clear
gum style \
  --foreground 4 --border-foreground 4 --border rounded \
  --align center --width 40 --margin "0 1" --padding "1 2" \
  "Hydeense installer" "Выбери модули для установки"

mapfile -t SELECTED_MODULES < <(
  gum choose --no-limit --height 10 \
    --header "Пробел — выбрать, Enter — подтвердить" \
    --selected.foreground 2 \
    "${AVAILABLE_MODULES[@]}"
)

if [[ ${#SELECTED_MODULES[@]} -eq 0 ]]; then
  log_warn "Ничего не выбрано, выход"
  exit 0
fi

echo ""
log_info "Выбранные модули: ${SELECTED_MODULES[*]}"

gum confirm "Начать установку?" || {
  log_warn "Установка отменена"
  exit 0
}

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

# --- Запуск модулей ---

echo ""
log_info "=============================="
log_info " Hydeense installer"
log_info "=============================="
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
