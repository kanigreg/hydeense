#!/usr/bin/env bash
# Модуль: btop
# Настройка btop для мониторинга

PACKAGES=(
  yazi
  7zip
)

install_packages "${PACKAGES[@]}"

link_config_dir "$HYDEENSE_DIR/configs/yazi" "$HOME/.config/yazi"
