#!/usr/bin/env bash
# Модуль: podman
# Контейнеризация и оркестрация

PACKAGES=(
  podman
  podman-docker
  podman-compose
  buildah
)

install_packages "${PACKAGES[@]}"

systemctl --user enable --now podman.socket

add_env DOCKER_HOST "unix:///run/user/$(id -u)/podman/podman.sock"
