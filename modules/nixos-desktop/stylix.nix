# Stylix: Linux-only cursor and icon overrides.
{ pkgs, ... }:

{
  stylix = {
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
  };
}
