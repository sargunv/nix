# Terminal emulators: kitty and ghostty config (packages installed via cask on macOS).
{ pkgs, ... }:

let
  # Dummy package for macOS where GUI apps are installed via Homebrew casks.
  caskPackage = name: pkgs.emptyDirectory // {
    pname = name;
    version = "0";
    meta = { mainProgram = name; };
  };
in
{
  stylix.opacity.terminal = 0.85;

  programs.kitty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then caskPackage "kitty" else pkgs.kitty;
    settings = {
      window_padding_width = 8;
      active_tab_font_style = "bold";
    };
  };

  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then caskPackage "ghostty" else pkgs.ghostty;
  };
}
