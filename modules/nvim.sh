#!/usr/bin/env bash
# Модуль: nvim
# Установка и настройка Neovim

log_step "Установка Neovim"

install_packages neovim

# --- Линковка конфига ---

local_home=$(get_real_home)

if [[ -d "$HYDEENSE_DIR/configs/nvim" && -n "$(ls -A "$HYDEENSE_DIR/configs/nvim" 2>/dev/null)" ]]; then
    link_config_dir "$HYDEENSE_DIR/configs/nvim" "$local_home/.config/nvim"
else
    log_warn "Директория configs/nvim пуста — конфиг не слинкован"
    log_info "Добавь свой конфиг nvim в configs/nvim/ и перезапусти модуль"
fi

log_info "Модуль nvim завершён"
