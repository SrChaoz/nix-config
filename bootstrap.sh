#!/usr/bin/env bash
set -euo pipefail

if ! command -v nix >/dev/null 2>&1; then
  cat <<'EOF'
Nix no está instalado. No se instalará automáticamente.

En Fedora, instala Nix en modo multiusuario compatible con SELinux con:
  sudo dnf install git nix nix-daemon
  sudo systemctl enable --now nix-daemon

Después abre una nueva sesión y vuelve a ejecutar este script.
EOF
  exit 1
fi

profile="full"
if [[ -t 0 ]]; then
  echo "Selecciona el perfil a instalar:"
  echo "  1) full    — escritorio y todas las aplicaciones declaradas (predeterminado)"
  echo "  2) minimal — GNOME, tema, extensiones, Git y configuración de shells"
  read -r -p "Perfil [1/2]: " profile_choice
  case "${profile_choice:-1}" in
    1) profile="full" ;;
    2) profile="minimal" ;;
    *) echo "Selección inválida." >&2; exit 2 ;;
  esac
fi

if [[ -t 0 ]]; then
  git_user_file="$HOME/.config/git/user.conf"
  if [[ ! -f "$git_user_file" ]]; then
    echo
    echo "La identidad Git se guarda localmente y nunca se sube al repositorio."
    read -r -p "Nombre para Git (dejar vacío para omitir): " git_user_name
    read -r -p "Correo para Git (dejar vacío para omitir): " git_user_email
    if [[ -n "$git_user_name" && -n "$git_user_email" ]]; then
      mkdir -p "$(dirname "$git_user_file")"
      umask 077
      printf '[user]\n\tname = %s\n\temail = %s\n' "$git_user_name" "$git_user_email" > "$git_user_file"
      echo "Identidad Git guardada en $git_user_file"
    else
      echo "Identidad Git omitida; puedes configurarla más tarde con git config --global."
    fi
  fi
fi

nix flake check

if [[ -t 0 ]]; then
  read -r -p "¿Aplicar ahora el perfil '$profile'? [Y/n]: " apply_choice
  if [[ ! "${apply_choice:-Y}" =~ ^[Yy]$ ]]; then
    echo "Validación completada. Para aplicar después:"
    echo "  nix run github:nix-community/home-manager -- switch -b pre-nix-config --flake .#srchaoz-$profile"
    exit 0
  fi
fi

nix run github:nix-community/home-manager -- switch -b pre-nix-config --flake ".#srchaoz-$profile"

cat <<EOF

Perfil '$profile' aplicado.

Consulta README.md para instalar Flatpaks, Apps Menu, Docker o PostgreSQL y
para cerrar sesión y volver a entrar en GNOME.
EOF
