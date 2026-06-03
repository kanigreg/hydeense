#!/usr/bin/env bash
# Модуль: nvim
# Установка и настройка Neovim

PACKAGES=(
  nvim
  git
  curl
  ripgrep
  fd
  jq
  fzf
  mise
  tree-sitter-cli
)

install_packages "${PACKAGES[@]}"

mise use --global lua@5.1
mise use --global node@latest

# --- Линковка конфига ---

if [[ -d "$HYDEENSE_DIR/configs/nvim" && -n "$(ls -A "$HYDEENSE_DIR/configs/nvim" 2>/dev/null)" ]]; then
  link_config_dir "$HYDEENSE_DIR/configs/nvim" "$HOME/.config/nvim"
else
  log_warn "Директория configs/nvim пуста — конфиг не слинкован"
  log_info "Добавь свой конфиг nvim в configs/nvim/ и перезапусти модуль"
fi

log_info "Модуль nvim завершён"
