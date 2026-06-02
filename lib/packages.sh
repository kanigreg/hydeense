#!/usr/bin/env bash
# Hydeense — управление пакетами

set -euo pipefail

source "$HYDEENSE_DIR/lib/utils.sh"

# Установка пакетов через pacman (идемпотентно через --needed)
install_packages() {
  local packages=("$@")

  if [[ ${#packages[@]} -eq 0 ]]; then
    log_warn "Список пакетов пуст, пропускаю"
    return 0
  fi

  log_step "Установка пакетов: ${packages[*]}"

  if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY-RUN] pacman -S --needed --noconfirm ${packages[*]}"
    return 0
  fi

  pacman -S --needed --noconfirm "${packages[@]}"
}

# Установка пакетов из AUR через yay
install_aur() {
  local packages=("$@")

  if [[ ${#packages[@]} -eq 0 ]]; then
    log_warn "Список AUR-пакетов пуст, пропускаю"
    return 0
  fi

  if ! is_installed yay; then
    log_error "yay не установлен. Сначала запусти модуль base"
    return 1
  fi

  log_step "Установка AUR-пакетов: ${packages[*]}"

  if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY-RUN] yay -S --needed --noconfirm ${packages[*]}"
    return 0
  fi

  # AUR-пакеты ставим от обычного пользователя
  run_as_user yay -S --needed --noconfirm "${packages[@]}"
}

# Синхронизация баз данных pacman
sync_pacman() {
  log_step "Синхронизация баз pacman"

  if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY-RUN] pacman -Sy"
    return 0
  fi

  pacman -Sy
}
