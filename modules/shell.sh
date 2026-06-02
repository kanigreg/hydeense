#!/usr/bin/env bash
# Модуль: shell
# Установка zsh, starship, конфигурация shell-окружения

log_step "Настройка shell (zsh + starship)"

SHELL_PACKAGES=(
    zsh
    zsh-completions
    zsh-autosuggestions
    zsh-syntax-highlighting
    starship
)

install_packages "${SHELL_PACKAGES[@]}"

# --- Установка zsh как login shell ---

local_user=$(get_real_user)
current_shell=$(getent passwd "$local_user" | cut -d: -f7)

if [[ "$current_shell" == */zsh ]]; then
    log_info "zsh уже является login shell для $local_user"
else
    log_step "Смена login shell на zsh для $local_user"
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY-RUN] chsh -s /usr/bin/zsh $local_user"
    else
        chsh -s /usr/bin/zsh "$local_user"
        log_info "Login shell изменён на zsh"
    fi
fi

# --- Линковка конфигов ---

local_home=$(get_real_home)

# .zshrc
link_config "$HYDEENSE_DIR/configs/shell/zshrc" "$local_home/.zshrc"

# starship.toml
link_config "$HYDEENSE_DIR/configs/shell/starship.toml" "$local_home/.config/starship.toml"

log_info "Модуль shell завершён"
