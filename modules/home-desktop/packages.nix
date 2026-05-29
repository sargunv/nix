# User GUI applications.
# Linux apps are from nixpkgs; macOS apps are managed via Homebrew casks.
{ pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isLinux isDarwin;

  update-orion = pkgs.writeShellApplication {
    name = "update-orion";
    runtimeInputs = with pkgs; [ curl flatpak coreutils ];
    text = ''
      url="https://orionbrowser.com/download/latest.flatpak"
      bundle=$(mktemp --suffix=.flatpak)
      trap 'rm -f "$bundle"' EXIT
      echo "downloading $url"
      curl -fsSL --retry 3 -o "$bundle" "$url"
      echo "installing..."
      flatpak install --user --reinstall -y "$bundle"
    '';
  };
in
{
  home.packages =
    lib.optionals isLinux (with pkgs; [
      # Browsers
      vivaldi
      update-orion # Orion is installed as a flatpak; this script reinstalls latest from Kagi

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
