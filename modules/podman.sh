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

run_as_user systemctl --user enable --now podman.socket

run_as_user add_env DOCKER_HOST "unix:///run/user/$(id -u)/podman/podman.sock"
