#!/usr/bin/env bash
# Модуль: base
# Базовые пакеты, yay (AUR helper), mise (runtime manager)

BASE_PACKAGES=(
  git
  curl
  base-devel
  unzip
  ripgrep
  fd
  jq
  btop
  man-db
  openssh
  mise
  rsync
)

# Синхронизация баз pacman
sync_pacman

# Установка базовых пакетов
install_packages "${BASE_PACKAGES[@]}"

# --- Установка yay ---

if is_installed yay; then
  log_info "yay уже установлен"
else
  log_step "Установка yay (AUR helper)"

  if [[ "$DRY_RUN" == "true" ]]; then
    log_info "[DRY-RUN] Клонирование и сборка yay из AUR"
  else
    tmp_dir="$HOME/.cache/hydeense/yay-build"

    mkdir -p "$tmp_dir"

    if [[ -d "$tmp_dir/yay" ]]; then
      rm -rf "$tmp_dir/yay"
    fi

    git clone https://aur.archlinux.org/yay-bin.git "$tmp_dir/yay"
    cd "$tmp_dir/yay"
    makepkg -si --noconfirm
    cd "$HYDEENSE_DIR"

    log_info "yay установлен"
  fi
fi
