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
  git clone https://github.com/tmux-plugins/tpm "$local_home/.config/tmux/plugins/tpm"
else
  log_warn "Директория configs/tmux пуста — конфиг не слинкован"
fi

mkdir -p /usr/local/share/zsh/site-functions
sesh complation zsh >/usr/local/share/zsh/site-functions/_sesh
link_config_dir "$HYDEENSE_DIR/configs/sesh" "$local_home/.config/sesh"

log_info "Модуль tmux завершён"
