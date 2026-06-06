#!/usr/bin/env bash
# Модуль: btop
# Настройка btop для мониторинга

PACKAGES=(
  btop
)

install_packages "${PACKAGES[@]}"

link_config_dir "$HYDEENSE_DIR/configs/btop" "$HOME/.config/btop"
