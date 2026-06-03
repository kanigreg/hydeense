#!/usr/bin/env bash
# Модуль: tmux
# Установка и настройка tmux

log_step "Установка tmux"

PACKAGES=(
  tmux
)

AUR_PACKAGES=(
  sesh-bin
)

install_packages "${PACKAGES[@]}"
install_aur "${AUR_PACKAGES[@]}"

# --- Линковка конфига ---

local_home=$(get_real_home)

if [[ -d "$HYDEENSE_DIR/configs/tmux" && -n "$(ls -A "$HYDEENSE_DIR/configs/tmux" 2>/dev/null)" ]]; then
  mkdir -p "$local_home/.config/tmux"
  link_config "$HYDEENSE_DIR/configs/tmux/tmux.conf" "$local_home/.config/tmux/tmux.conf"
else
  log_warn "Директория configs/tmux пуста — конфиг не слинкован"
  log_info "Добавь свой конфиг tmux в configs/tmux/ и перезапусти модуль"
fi

mkdir -p /usr/local/share/zsh/site-functions
sesh complation zsh > /usr/local/share/zsh/site-functions/_sesh

log_info "Модуль tmux завершён"
