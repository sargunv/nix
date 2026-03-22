# User GUI applications.
# On macOS, most apps come from brew-nix; on Linux, from nixpkgs.
{ pkgs, lib, ... }:

let
  inherit (pkgs.stdenv) isLinux isDarwin;

  # Helper: pick the right package per platform.
  # Usage: app { linux = pkgs.foo; darwin = pkgs.brewCasks.foo; }
  app = { linux ? null, darwin ? null }:
    if isLinux && linux != null then linux
    else if isDarwin && darwin != null then darwin
    else null;

  t3code-appimage =
    let
      version = "0.0.4";
      src = pkgs.fetchurl {
        url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
        hash = "sha256-HlkQ/uPLXHh2Duamrmhp31yQqnETawQ4Ru7kg2MmpVs=";
      };
    in
    pkgs.appimageTools.wrapType2 {
      pname = "t3code";
      inherit version src;
      extraInstallCommands =
        let
          contents = pkgs.appimageTools.extract {
            pname = "t3code";
            inherit version src;
          };
        in
        ''
          install -Dm444 ${contents}/t3-code-desktop.desktop $out/share/applications/t3code.desktop
          install -Dm444 ${contents}/t3-code-desktop.png $out/share/icons/hicolor/512x512/apps/t3code.png
          substituteInPlace $out/share/applications/t3code.desktop \
            --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=t3code %U' \
            --replace-fail 'Icon=t3-code-desktop' 'Icon=t3code'
        '';
    };
in
{
  home.packages = builtins.filter (p: p != null) [
    # Communication
    (app { linux = pkgs.beeper;          darwin = pkgs.brewCasks.beeper; })
    (app { linux = pkgs.discord;         darwin = pkgs.brewCasks.discord; })
    (app { linux = pkgs.slack;           darwin = pkgs.brewCasks.slack; })

    # Media
    (app { linux = pkgs.obs-studio;      darwin = pkgs.brewCasks.obs; })
    (app { linux = pkgs.audacity;        darwin = pkgs.brewCasks.audacity; })

    # 3D Printing
    (app { linux = pkgs.bambu-studio;   darwin = pkgs.brewCasks.bambu-studio; })
    (app { linux = pkgs.freecad-wayland; darwin = pkgs.brewCasks.freecad; })
    (app { linux = pkgs.openscad-unstable; darwin = pkgs.brewCasks.openscad; })

    # Productivity
    (app { linux = pkgs.anki;            darwin = pkgs.brewCasks.anki; })
    (app { linux = pkgs.obsidian;        darwin = pkgs.brewCasks.obsidian; })
    (app { linux = pkgs.android-studio;  darwin = pkgs.brewCasks.jetbrains-toolbox; })
    (app { linux = t3code-appimage;      darwin = pkgs.brewCasks.t3-code; })
    (app { linux = pkgs.localsend;       darwin = pkgs.brewCasks.localsend; })

    # Security
    (app { linux = pkgs.proton-pass;     darwin = pkgs.brewCasks.proton-pass; })

    # Game Dev
    (app { linux = pkgs.godot_4;         darwin = pkgs.brewCasks.godot; })
    (app { linux = pkgs.blender;         darwin = pkgs.brewCasks.blender; })
    (app { linux = pkgs.aseprite;       darwin = pkgs.aseprite; })
    (app { linux = pkgs.tiled;           darwin = pkgs.brewCasks.tiled; })

    # Gaming
    (app { linux = pkgs.prismlauncher;   darwin = pkgs.brewCasks.prismlauncher; })
  ] ++ lib.optionals isDarwin (with pkgs.brewCasks; [
    # macOS-only apps
    setapp
    jordanbaird-ice
    lunar
    raspberry-pi-imager
    raycast # vicinae on linux (via home-hyprland)
    proton-drive
    proton-mail-bridge
    protonvpn
  ]);
}
