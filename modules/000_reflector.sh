#!/usr/bin/env bash
# Модуль: reflector
# Настройка зеркал для pacman репозиториев

log_step "Настройка зеркал"

install_packages reflector

backup_file /etc/pacman.d/mirrorlist
sudo reflector --latest 5 --save /etc/pacman.d/mirrorlist

sudo pacman -Syy
