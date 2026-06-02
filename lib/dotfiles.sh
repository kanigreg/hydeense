#!/usr/bin/env bash
# Hydeense — управление конфигурационными файлами (dotfiles)

set -euo pipefail

source "$HYDEENSE_DIR/lib/utils.sh"

# Создание symlink'а для конфига
# Использование: link_config <source> <target>
#   source — путь к файлу/директории в репо (configs/...)
#   target — целевой путь (например ~/.config/nvim)
link_config() {
  local source="$1"
  local target="$2"

  if [[ ! -e "$source" ]]; then
    log_error "Источник не существует: $source"
    return 1
  fi

  # Если target уже symlink на наш source — ничего не делаем
  if [[ -L "$target" && "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
    log_info "Уже слинковано: $target -> $source"
    return 0
  fi

  # Создаём родительскую директорию если нет
  local parent_dir
  parent_dir=$(dirname "$target")
  if [[ ! -d "$parent_dir" ]]; then
    if [[ "$DRY_RUN" == "true" ]]; then
      log_info "[DRY-RUN] mkdir -p $parent_dir"
    else
      mkdir -p "$parent_dir"
    fi
  fi

  # Бэкапим существующий файл/директорию
  backup_file "$target"

  # Удаляем старый symlink если есть
  if [[ -L "$target" ]]; then
    if [[ "$DRY_RUN" == "true" ]]; then
      log_info "[DRY-RUN] Удаление старого symlink: $target"
    else
      rm "$target"
    fi
  fi

  if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY-RUN] Линковка: $target -> $source"
  else
    ln -sf "$source" "$target"
    log_info "Слинковано: $target -> $source"
  fi
}

# Линковка всех файлов из директории в целевую директорию
# Использование: link_config_dir <source_dir> <target_dir>
link_config_dir() {
  local source_dir="$1"
  local target_dir="$2"

  if [[ ! -d "$source_dir" ]]; then
    log_error "Директория не существует: $source_dir"
    return 1
  fi

  log_step "Линковка конфигов: $source_dir -> $target_dir"

  # Линкуем саму директорию целиком
  link_config "$source_dir" "$target_dir"
}
