#!/usr/bin/env bash
# Модуль: snapshots
# Настройка snapper для btrfs snapshot'ов (subvolumes @ и @home)

install_packages snapper

# --- Конфигурация snapper для root (@) ---

if sudo snapper -c root get-config &>/dev/null 2>&1; then
  log_info "Конфигурация snapper 'root' уже существует"
else
  log_step "Создание конфигурации snapper для / (subvolume @)"
  sudo snapper -c root create-config /
  log_info "Конфигурация snapper 'root' создана"
fi

# --- Конфигурация snapper для home (@home) ---

if sudo snapper -c home get-config &>/dev/null 2>&1; then
  log_info "Конфигурация snapper 'home' уже существует"
else
  log_step "Создание конфигурации snapper для /home (subvolume @home)"
  # sudo snapper -c home create-config /home
  # log_info "Конфигурация snapper 'home' создана"
fi

# --- Хелпер: создание snapshot'а перед установкой ---
# Эту функцию можно вызывать вручную: source modules/snapshots.sh && hydeense_snapshot "описание"

hydeense_snapshot() {
  local description="${1:-hydeense auto-snapshot}"

  if ! is_installed snapper; then
    log_warn "snapper не установлен, пропускаю snapshot"
    return 0
  fi

  log_step "Создание snapshot: $description"

  sudo snapper -c root create --description "$description" || log_warn "Не удалось создать snapshot для root"
  # sudo snapper -c home create --description "$description" || log_warn "Не удалось создать snapshot для home"
  log_info "Snapshot'ы созданы: $description"
}

log_info "Модуль snapshots завершён"
