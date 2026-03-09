# Stylix: system-wide Gruvbox Dark Hard color scheme and fonts.
{
  config,
  lib,
  pkgs,
  gruvbox-wallpapers,
  ...
}:

lib.mkIf (!config.local.headless) {
  stylix = {
    image = "${
      gruvbox-wallpapers.packages.${pkgs.stdenv.hostPlatform.system}.default
    }/cosy-retreat-sunset.png";
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
    icons = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      dark = "Adwaita";
      light = "Adwaita";
    };
    fonts.monospace = {
      package = pkgs.nerd-fonts.monaspace;
      name = "MonaspiceAr Nerd Font";
    };
  };
}
