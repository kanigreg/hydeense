#!/usr/bin/env bash
# Модуль: git
# Настройка git и его обвязки

local_home=$(get_real_home)

link_config_dir "$HYDEENSE_DIR/configs/git" "$local_home/.config/git"
