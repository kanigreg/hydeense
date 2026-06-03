#!/usr/bin/env bash
# Модуль: git
# Настройка git и его обвязки

PACKAGES=(
  git
  git-delta
  lazygit
  libsecret
)

install_packages "${PACKAGES[@]}"

link_config_dir "$HYDEENSE_DIR/configs/delta" "$HOME/.config/delta"
link_config_dir "$HYDEENSE_DIR/configs/git" "$HOME/.config/git"
link_config_dir "$HYDEENSE_DIR/configs/lazygit" "$HOME/.config/lazygit"
