#!/usr/bin/env bash
# Hydeense — общие утилиты

set -euo pipefail

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
  echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_step() {
  echo -e "${BLUE}[>>>]${NC} $*"
}

# Проверка что скрипт НЕ запущен от root
deny_root() {
  if [[ $EUID -eq 0 ]]; then
    log_error "Не запускай скрипт от root. Запусти от обычного пользователя."
    log_error "Пароль sudo будет запрошен автоматически при старте."
    exit 1
  fi
}

# Запрос sudo-пароля один раз и поддержание сессии
init_sudo() {
  log_step "Запрос привилегий sudo (пароль будет запрошен один раз)"
  sudo -v

  # Фоновый процесс для продления sudo-сессии
  (
    while true; do
      sudo -n true
      sleep 50
      kill -0 "$$" 2>/dev/null || exit
    done
  ) &
  SUDO_KEEPALIVE_PID=$!
  export SUDO_KEEPALIVE_PID

  trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT
}

# Проверка что команда доступна
is_installed() {
  command -v "$1" &>/dev/null
}

# Бэкап файла/директории перед заменой
backup_file() {
  local target="$1"
  local backup_dir="${HYDEENSE_BACKUP_DIR:-$HOME/.local/share/hydeense/backups}"
  local timestamp
  timestamp=$(date +%Y%m%d_%H%M%S)

  if [[ -e "$target" && ! -L "$target" ]]; then
    mkdir -p "$backup_dir"
    local backup_path
    backup_path="$backup_dir/$(basename "$target").$timestamp"
    cp -r "$target" "$backup_path"
    log_info "Бэкап: $target -> $backup_path"
  fi
}

# Добавляет строку вида:
# export KEY="VALUE"
# в указанный файл, если переменная ещё не определена.
add_env() {
  local file="$HOME/.zshenv"
  local key="$1"
  local value="$2"

  touch "$file"

  if ! grep -qE "^(export[[:space:]]+)?${key}=" "$file"; then
    # Экранируем двойные кавычки в значении
    local escaped_value="${value//\"/\\\"}"
    printf '\nexport %s="%s"\n' "$key" "$escaped_value" >>"$file"
  fi
}
