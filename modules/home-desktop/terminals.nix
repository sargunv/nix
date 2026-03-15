# Terminal emulators: kitty on Linux, ghostty on macOS.
{ pkgs, lib, ... }:

{
  stylix.opacity.terminal = 0.85;

  programs.kitty = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    package = pkgs.kitty;
    settings = {
      window_padding_width = 8;
      active_tab_font_style = "bold";
    };
  };

  programs.ghostty = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    package = pkgs.brewCasks.ghostty;
    settings.macos-window-shadow = false;
    settings.background-blur = "macos-glass-regular";
  };
}
