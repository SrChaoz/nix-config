{ config, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Colloid-Dark";
      icon-theme = "Colloid-Dark";
      cursor-theme = "Adwaita";
    };

    "org/gnome/desktop/background" = {
      picture-uri = "file://${config.home.homeDirectory}/.local/share/backgrounds/current.png";
      picture-uri-dark = "file://${config.home.homeDirectory}/.local/share/backgrounds/current.png";
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "blur-my-shell@aunetx"
        "appindicatorsupport@rgcjonas.gmail.com"
        "Vitals@CoreCoding.com"
        "gnome-compact-top-bar@metehan-arslan.github.io"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "compiz-alike-magic-lamp-effect@hermes83.github.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "dash-to-dock@micxgx.gmail.com"
      ];
    };
  };
}
