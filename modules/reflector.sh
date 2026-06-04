#!/usr/bin/env bash
# Модуль: k8s
# Настройка зеркал для pacman репозиториев

log_step "Настройка зеркал"

install_packages reflector

backup_file /etc/pacman.d/mirrorlist
sudo reflector --latest 5
