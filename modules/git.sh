#!/usr/bin/env bash
# Модуль: git
# Настройка git и его обвязки

PACKAGES=(
  git
  git-delta
)

install_packages "${PACKAGES[@]}"

local_home=$(get_real_home)

link_config_dir "$HYDEENSE_DIR/configs/delta" "$local_home/.config/delta"
link_config_dir "$HYDEENSE_DIR/configs/git" "$local_home/.config/git"
