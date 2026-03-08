# Stylix: system-wide Gruvbox Dark Hard color scheme and fonts.
{ pkgs, ... }:

{
  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    fonts.monospace = {
      package = pkgs.nerd-fonts.monaspace;
      name = "MonaspiceAr Nerd Font";
    };
  };
}
