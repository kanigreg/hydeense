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

if [[ -d "$HYDEENSE_DIR/configs/tmux" && -n "$(ls -A "$HYDEENSE_DIR/configs/tmux" 2>/dev/null)" ]]; then
  mkdir -p "$HOME/.config/tmux"
  link_config "$HYDEENSE_DIR/configs/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
  clone_repo https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm" master
else
  log_warn "Директория configs/tmux пуста — конфиг не слинкован"
fi

sudo mkdir -p /usr/local/share/zsh/site-functions
sesh complation zsh | sudo tee /usr/local/share/zsh/site-functions/_sesh >/dev/null
link_config_dir "$HYDEENSE_DIR/configs/sesh" "$HOME/.config/sesh"

log_info "Модуль tmux завершён"
