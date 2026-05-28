#!/usr/bin/env bash
# Модуль: tmux
# Установка и настройка tmux

log_step "Установка tmux"

install_packages tmux

# --- Линковка конфига ---

local_home=$(get_real_home)

if [[ -d "$HYDEENSE_DIR/configs/tmux" && -n "$(ls -A "$HYDEENSE_DIR/configs/tmux" 2>/dev/null)" ]]; then
    link_config_dir "$HYDEENSE_DIR/configs/tmux" "$local_home/.config/tmux"
else
    log_warn "Директория configs/tmux пуста — конфиг не слинкован"
    log_info "Добавь свой конфиг tmux в configs/tmux/ и перезапусти модуль"
fi

log_info "Модуль tmux завершён"
