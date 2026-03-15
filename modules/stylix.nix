# Stylix: Gruvbox Dark Hard color scheme, wallpaper, and monospace font.
{
  pkgs,
  gruvbox-wallpaper,
  ...
}:

{
  stylix = {
    enable = true;
    image = gruvbox-wallpaper;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    fonts.monospace = {
      package = pkgs.nerd-fonts.monaspace;
      name = "MonaspiceAr Nerd Font Propo";
    };
  };
}
