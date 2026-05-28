#!/usr/bin/env bash
# Hydeense — общие утилиты

set -euo pipefail

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Режим dry-run (устанавливается из install.sh)
DRY_RUN="${DRY_RUN:-false}"

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

# Проверка что скрипт запущен от root
require_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Этот скрипт должен быть запущен от root (используй sudo)"
        exit 1
    fi
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
        local backup_path="$backup_dir/$(basename "$target").$timestamp"
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "[DRY-RUN] Бэкап: $target -> $backup_path"
        else
            cp -r "$target" "$backup_path"
            log_info "Бэкап: $target -> $backup_path"
        fi
    fi
}

# Определение пользователя (при запуске через sudo)
get_real_user() {
    echo "${SUDO_USER:-$USER}"
}

get_real_home() {
    local user
    user=$(get_real_user)
    eval echo "~$user"
}

# Выполнение команды от имени реального пользователя (не root)
run_as_user() {
    local user
    user=$(get_real_user)
    if [[ $EUID -eq 0 ]]; then
        sudo -u "$user" "$@"
    else
        "$@"
    fi
}
