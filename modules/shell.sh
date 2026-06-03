#!/usr/bin/env bash
# Модуль: shell
# Установка zsh, starship, конфигурация shell-окружения

SHELL_PACKAGES=(
  zsh
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
  starship
  eza
  bat
  zoxide
  fzf
)

install_packages "${SHELL_PACKAGES[@]}"

# --- Установка zsh как login shell ---

current_shell=$(getent passwd "$USER" | cut -d: -f7)

if [[ "$current_shell" == */zsh ]]; then
  log_info "zsh уже является login shell для $USER"
else
  log_step "Смена login shell на zsh для $USER"
  if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY-RUN] sudo chsh -s /usr/bin/zsh $USER"
  else
    sudo chsh -s /usr/bin/zsh "$USER"
    log_info "Login shell изменён на zsh"
  fi
fi

# --- Линковка конфигов ---

# .zshrc
link_config "$HYDEENSE_DIR/configs/shell/zshrc" "$HOME/.zshrc"

# starship.toml
link_config "$HYDEENSE_DIR/configs/shell/starship.toml" "$HOME/.config/starship.toml"

link_config_dir "$HYDEENSE_DIR/configs/bat" "$HOME/.config/bat"

log_info "Модуль shell завершён"
