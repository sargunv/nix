# Stylix: Tokyo Night Dark color scheme, wallpaper, and monospace font.
{
  pkgs,
  wallpaper,
  ...
}:

{
  stylix = {
    enable = true;
    image = wallpaper;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    fonts.monospace = {
      package = pkgs.nerd-fonts.monaspace;
      name = "MonaspiceAr Nerd Font Propo";
    };
  };
}
