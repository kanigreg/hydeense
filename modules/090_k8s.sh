#!/usr/bin/env bash
# Модуль: k8s
# Установка и настройка k8s инструменотов

log_step "Установка инструменотов k8s"

PACKAGES=(
  kubectl
  k9s
)

install_packages "${PACKAGES[@]}"

link_config_dir "$HYDEENSE_DIR/configs/k9s" "$HOME/.config/k9s"
