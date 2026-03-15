# Setapp: declarative app list and CLI tool.
# Apps are listed here but installed manually via `just setapp`.
{ pkgs, ... }:

let
  setapp-cli-unwrapped = pkgs.stdenv.mkDerivation rec {
    pname = "setapp-cli";
    version = "2.1.0";
    src = pkgs.fetchurl {
      url = "https://github.com/maximlevey/setapp-cli/releases/download/v${version}/setapp-cli-v${version}-macos-universal.tar.gz";
      hash = "sha256-jinenbmNVCBGj6kF7hO8iGjQo2hxQlPBDcvs27Ssnpg=";
    };
    sourceRoot = ".";
    installPhase = ''
      install -Dm755 setapp-cli $out/bin/setapp-cli
    '';
  };

  setapp-cli = pkgs.writeShellScriptBin "setapp-cli" ''
    frameworks="$HOME/Library/Application Support/Setapp/LaunchAgents/Setapp.app/Contents/Frameworks"
    export DYLD_FRAMEWORK_PATH="$frameworks:$frameworks/SetappInterface.framework/Versions/A/Frameworks"
    exec ${setapp-cli-unwrapped}/bin/setapp-cli "$@"
  '';

  appList = [
    "Archiver"
    "CleanMyMac"
    "CleanShot X"
    "DevUtils"
    "ForkLift"
    "Lungo"
    "Numi"
    "RapidAPI"
    "Swish"
    "TablePlus"
  ];
in
{
  environment.systemPackages = [ setapp-cli ];

  home-manager.users.sargunv.home.file.".setapp/AppList".text =
    builtins.concatStringsSep "\n" appList + "\n";
}
