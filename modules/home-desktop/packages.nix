# User GUI applications.
# Linux apps are from nixpkgs; macOS apps are managed via Homebrew casks.
{ pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isLinux;
in
{
  home.packages =
    lib.optionals isLinux (with pkgs; [
      # Browsers
      vivaldi

      # Communication
      beeper
      discord
      slack

      # Media
      obs-studio
      audacity

      # 3D Printing
      bambu-studio
      freecad-wayland
      openscad-unstable

      # Productivity
      anki
      obsidian
      android-studio
      gearlever
      localsend

      # Security
      proton-pass

      # Game Dev
      godot_4
      blender
      aseprite
      tiled

      # Gaming
      prismlauncher
    ])
;
}
