#!/usr/bin/env bash
set -euo pipefail

if ! command -v nix >/dev/null 2>&1; then
  cat <<'EOF'
Nix no está instalado. No se instalará automáticamente.

En Fedora, instala Nix en modo multiusuario con:
  sh <(curl -L https://nixos.org/nix/install) --daemon

Después abre una nueva sesión y vuelve a ejecutar este script.
EOF
  exit 1
fi

nix flake check

cat <<'EOF'

La configuración pasó `nix flake check`.
No se ejecutó `home-manager switch` por diseño.

Revísala y, cuando quieras aplicarla, ejecuta:
  nix run github:nix-community/home-manager -- switch --flake .#srchaoz
EOF
