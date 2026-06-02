#!/usr/bin/env bash
# Модуль: snapshots
# Настройка snapper для btrfs snapshot'ов (subvolumes @ и @home)

log_step "Настройка snapper (btrfs snapshots)"

install_packages snapper

# --- Конфигурация snapper для root (@) ---

if snapper -c root get-config &>/dev/null 2>&1; then
  log_info "Конфигурация snapper 'root' уже существует"
else
  log_step "Создание конфигурации snapper для / (subvolume @)"

  if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY-RUN] snapper -c root create-config /"
  else
    snapper -c root create-config /
    log_info "Конфигурация snapper 'root' создана"
  fi
fi

# --- Конфигурация snapper для home (@home) ---

if snapper -c home get-config &>/dev/null 2>&1; then
  log_info "Конфигурация snapper 'home' уже существует"
else
  log_step "Создание конфигурации snapper для /home (subvolume @home)"

  if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY-RUN] snapper -c home create-config /home"
    # else
    # snapper -c home create-config /home
    # log_info "Конфигурация snapper 'home' создана"
  fi
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

  if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY-RUN] snapper -c root create -d '$description'"
    log_info "[DRY-RUN] snapper -c home create -d '$description'"
  else
    snapper -c root create --description "$description" || log_warn "Не удалось создать snapshot для root"
    # snapper -c home create --description "$description" || log_warn "Не удалось создать snapshot для home"
    log_info "Snapshot'ы созданы: $description"
  fi
}

log_info "Модуль snapshots завершён"
