#!/usr/bin/env bash
# Модуль: tmux
# Установка и настройка tmux

log_step "Установка tmux"

PACKAGES=(
  kubectl
  k9s
)

install_packages "${PACKAGES[@]}"

link_config_dir "$HYDEENSE_DIR/configs/k9s" "$HOME/.config/k9s"
