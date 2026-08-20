{ config, pkgs, ... }:

{
  imports = [ ./modules/gnome.nix ];

  home.username = "srchaoz";
  home.homeDirectory = "/home/srchaoz";
  home.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    google-chrome
    ghostty
    vscode
    postgresql
    pgadmin4
    docker
    docker-compose
    nodejs_22
    gh
    discord
    gnome-tweaks
    git
    zsh
    oh-my-zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-powerlevel10k
    nerd-fonts.meslo-lg

    # GNOME Shell extensions detected as active on the source system.
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.vitals
    gnomeExtensions.compact-top-bar
    gnomeExtensions.user-themes
    gnomeExtensions.compiz-alike-magic-lamp-effect
    gnomeExtensions.dash-to-dock
  ];

  home.file = {
    ".bashrc".source = ./dotfiles/bashrc;
    ".local/bin/env" = {
      source = ./dotfiles/local-bin-env;
      executable = true;
    };
    ".gitconfig".source = ./dotfiles/gitconfig;
    ".p10k.zsh".source = ./dotfiles/p10k.zsh;
    ".zshrc".source = pkgs.replaceVars ./dotfiles/zshrc {
      oh_my_zsh = pkgs.oh-my-zsh;
      powerlevel10k = pkgs.zsh-powerlevel10k;
      zsh_autosuggestions = pkgs.zsh-autosuggestions;
      zsh_syntax_highlighting = pkgs.zsh-syntax-highlighting;
    };
    ".local/share/backgrounds/current.png".source = ./wallpapers/current.png;
    ".local/share/icons/Colloid-Dark" = {
      source = ./themes/Colloid-Dark-icons;
      recursive = true;
    };
    ".themes/Colloid-Dark" = {
      source = ./themes/Colloid-Dark-gtk;
      recursive = true;
    };
  };

  xdg.configFile = {
    "ghostty/config".source = ./dotfiles/ghostty/config;
    "Code/User/settings.json".source = ./dotfiles/vscode/User/settings.json;
  };

  programs.home-manager.enable = true;
}
