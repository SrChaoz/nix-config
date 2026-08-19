# nix-config

Configuración reproducible de mi entorno de usuario en Fedora GNOME mediante
Nix y Home Manager en modo *standalone*. No convierte el equipo en NixOS ni
gestiona la configuración del sistema operativo.

Incluye aplicaciones de uso diario, dotfiles de Bash, Zsh, Git, Ghostty y VS
Code, el fondo de pantalla, los temas Colloid-Dark y la personalización de
GNOME. Las aplicaciones Flatpak y los servicios de sistema tienen pasos
adicionales documentados abajo.

## Instalación en Fedora limpia

1. Instala Git y Nix desde los repositorios oficiales de Fedora. Usar el
   paquete de Fedora evita el problema del instalador upstream con SELinux.

   ```bash
   sudo dnf install git nix nix-daemon
   sudo systemctl enable --now nix-daemon
   ```

2. Cierra y abre una terminal, clona el repositorio y valida el flake.

   ```bash
   git clone https://github.com/SrChaoz/nix-config.git
   cd nix-config
   ./bootstrap.sh
   ```

   `bootstrap.sh` genera/verifica las entradas del flake y ejecuta
   `nix flake check`. Deliberadamente **no** aplica la configuración.

3. Revisa el plan opcionalmente y aplica Home Manager.

   ```bash
   nix run github:nix-community/home-manager -- switch --flake .#srchaoz --dry-run
   nix run github:nix-community/home-manager -- switch --flake .#srchaoz
   ```

4. Cierra sesión y vuelve a entrar en GNOME. Esto permite que GNOME Shell
   redescubra las extensiones, el tema y los iconos de Nix/Home Manager.

## Después de Home Manager

### Flatpaks

Home Manager no administra Flatpak de forma nativa en esta configuración.
Instala las aplicaciones declaradas, sin incluir runtimes manualmente:

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.getpostman.Postman com.spotify.Client us.zoom.Zoom
```

### Extensiones de VS Code

Tras el `switch`, instala las extensiones versionadas en
`dotfiles/vscode/extensions.txt`:

```bash
xargs -r -n 1 code --install-extension < dotfiles/vscode/extensions.txt
```

El archivo contiene únicamente las extensiones aprobadas de uso permanente;
no incluye PowerShell, ChatGPT, SonarLint ni Ollama Copilot.

### Docker

El paquete Nix aporta el cliente de Docker y Compose, pero Home Manager no
puede instalar ni habilitar el daemon de Fedora. En una instalación limpia:

```bash
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
```

Después, cierra sesión y vuelve a entrar (o ejecuta `newgrp docker`) y prueba
con `docker run hello-world`. El grupo `docker` equivale prácticamente a
privilegios de root: añádete solo a tu propia cuenta.

### PostgreSQL

Nix proporciona el cliente y las herramientas, pero un servidor PostgreSQL
local es un servicio de sistema. Instálalo y actívalo con Fedora:

```bash
sudo dnf install postgresql-server postgresql-contrib
sudo postgresql-setup --initdb
sudo systemctl enable --now postgresql
```

Comprueba el estado con `systemctl status postgresql`. Para crear tu rol local
puedes usar `sudo -iu postgres createuser --interactive`; no guardes
contraseñas, dumps ni bases de datos dentro de este repositorio.

### GNOME

La configuración activa Colloid-Dark, cursor Adwaita, el fondo incluido y
estas extensiones:

- Blur my Shell
- AppIndicator Support
- Vitals
- Compact Top Bar
- User Themes
- Compiz alike Magic Lamp Effect
- Apps Menu
- Dash to Dock

Si una extensión no aparece después de reiniciar la sesión, abre la aplicación
Extensions y comprueba que GNOME Shell la detectó. La compatibilidad depende
de la versión de GNOME Shell instalada por Fedora.

## Actualizar

Para actualizar las entradas del flake y aplicar una nueva generación:

```bash
nix flake update
nix flake check
nix run github:nix-community/home-manager -- switch --flake .#srchaoz
```

Revisa y versiona `flake.lock` después de actualizarlo. Para volver a una
generación anterior, usa `home-manager generations` y activa la generación
anterior desde su ruta mostrada.

## Notas

- Los assets de Colloid y el fondo se guardan dentro del repositorio para no
  depender de una descarga no fijada. El repositorio contiene alrededor de
  80 MB de imágenes y tema.
- Las aplicaciones marcadas como no libres, como Chrome y VS Code, están
  permitidas explícitamente en `home.nix`.
- Antes de usar esta configuración en otra cuenta o máquina, ajusta
  `home.username` y `home.homeDirectory` en `home.nix` si difieren de
  `srchaoz` y `/home/srchaoz`.
