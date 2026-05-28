#!/usr/bin/env bash
# Hydeense — smoke-тесты
# Запускать после установки для проверки что всё на месте

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

PASS=0
FAIL=0

check() {
    local description="$1"
    shift

    if "$@" &>/dev/null; then
        echo -e "${GREEN}[PASS]${NC} $description"
        ((PASS++))
    else
        echo -e "${RED}[FAIL]${NC} $description"
        ((FAIL++))
    fi
}

check_link() {
    local description="$1"
    local path="$2"

    if [[ -L "$path" ]]; then
        echo -e "${GREEN}[PASS]${NC} $description (-> $(readlink "$path"))"
        ((PASS++))
    else
        echo -e "${RED}[FAIL]${NC} $description (не symlink или не существует)"
        ((FAIL++))
    fi
}

echo "=============================="
echo " Hydeense smoke tests"
echo "=============================="
echo ""

# --- Базовые пакеты ---
echo "--- base ---"
check "git установлен"         command -v git
check "curl установлен"        command -v curl
check "ripgrep установлен"     command -v rg
check "fd установлен"          command -v fd
check "jq установлен"          command -v jq
check "yay установлен"         command -v yay
check "mise установлен"        command -v mise

# --- Shell ---
echo ""
echo "--- shell ---"
check "zsh установлен"         command -v zsh
check "starship установлен"    command -v starship
check_link ".zshrc слинкован"  "$HOME/.zshrc"
check_link "starship.toml слинкован" "$HOME/.config/starship.toml"

# --- Neovim ---
echo ""
echo "--- nvim ---"
check "neovim установлен"      command -v nvim

# --- Tmux ---
echo ""
echo "--- tmux ---"
check "tmux установлен"        command -v tmux

# --- Snapper ---
echo ""
echo "--- snapshots ---"
check "snapper установлен"     command -v snapper

# --- Итого ---
echo ""
echo "=============================="
echo -e " Результат: ${GREEN}$PASS passed${NC}, ${RED}$FAIL failed${NC}"
echo "=============================="

if [[ $FAIL -gt 0 ]]; then
    exit 1
fi
