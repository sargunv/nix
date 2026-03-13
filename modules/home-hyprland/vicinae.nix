# Vicinae - desktop launcher.
{ config, pkgs, ... }:

let
  extensionsSrc = pkgs.fetchFromGitHub {
    owner = "vicinaehq";
    repo = "extensions";
    rev = "ab4a6706f879716f9fbbdbee0c300f365c72f2d4";
    hash = "sha256-KmJYe/AHmJlwtift7wmm8YZJm3/hudRY5z3mU23HoqA=";
  };

  mkExt = name: config.lib.vicinae.mkExtension {
    inherit name;
    src = "${extensionsSrc}/extensions/${name}";
  };
in
{
  programs.vicinae = {
    enable = true;
    systemd.enable = true;
    settings = {
      providers = {
        "@ShyAssassin/vscode-recents" = {
          preferences = {
            vscodeFlavour = "VSCodium";
          };
        };
        system = {
          entrypoints.browse-apps.enabled = true;
        };
      };
    };
    extensions = map mkExt [
      "hypr-keybinds"
      "nix"
      "zed-recents"
      "vscode-recents"
      "jetbrains-recent-projects"
    ];
  };
}
