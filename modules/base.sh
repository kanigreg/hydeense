#!/usr/bin/env bash
# Модуль: base
# Базовые пакеты, yay (AUR helper), mise (runtime manager)

log_step "Установка базовых пакетов"

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
    # local_user=$(get_real_user)
    local_home=$(get_real_home)
    tmp_dir="$local_home/.cache/hydeense/yay-build"

    run_as_user mkdir -p "$tmp_dir"

    if [[ -d "$tmp_dir/yay" ]]; then
      rm -rf "$tmp_dir/yay"
    fi

    run_as_user git clone https://aur.archlinux.org/yay-bin.git "$tmp_dir/yay"
    cd "$tmp_dir/yay"
    run_as_user makepkg -si --noconfirm
    cd "$HYDEENSE_DIR"

    log_info "yay установлен"
  fi
fi
