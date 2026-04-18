# Setapp: declarative app list and CLI tool (macOS only).
{ pkgs, config, lib, ... }:

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
    "CleanShot X"
    "DevUtils"
    "ForkLift"
    "iStat Menus"
    "Lungo"
    "Numi"
    "Supercharge"
    "Swish"
    "TablePlus"
  ];
in
lib.mkIf pkgs.stdenv.isDarwin {
  home.packages = [ setapp-cli ];

  home.file.".setapp/AppList".text =
    builtins.concatStringsSep "\n" appList + "\n";

  # Symlink so setapp-cli can find Setapp.app (it only checks ~/Applications and /Applications)
  home.file."Applications/Setapp.app".source =
    config.lib.file.mkOutOfStoreSymlink "/Applications/Setapp.app";

  # Sync Setapp apps on activation
  home.activation.setapp-sync =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${setapp-cli}/bin/setapp-cli bundle install && \
      ${setapp-cli}/bin/setapp-cli bundle cleanup || \
        echo "setapp-cli: skipping sync (Setapp may not be installed or logged in yet)"
    '';
}
