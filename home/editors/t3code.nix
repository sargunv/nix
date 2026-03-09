# T3 Code - AI code editor by Ping
{
  config,
  lib,
  pkgs,
  ...
}:

let
  version = "0.0.4";

  appimage-src = pkgs.fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
    hash = "sha256-HlkQ/uPLXHh2Duamrmhp31yQqnETawQ4Ru7kg2MmpVs=";
  };

  t3code-linux = pkgs.appimageTools.wrapType2 {
    pname = "t3code";
    inherit version;
    src = appimage-src;
    extraInstallCommands =
      let
        contents = pkgs.appimageTools.extract {
          pname = "t3code";
          inherit version;
          src = appimage-src;
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

  t3code-darwin = pkgs.stdenv.mkDerivation {
    pname = "t3code";
    inherit version;
    src = pkgs.fetchurl {
      url =
        let
          arch = if pkgs.stdenv.isAarch64 then "arm64" else "x64";
        in
        "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-${arch}.dmg";
      hash =
        if pkgs.stdenv.isAarch64 then
          "sha256-FKt3RDQ1SwLf6fOttK5fICnd8ZZWEvIJqCWtqNqd/5k="
        else
          "sha256-nH170qcbxSE1mbmOlhgM/hZ3r96CNhchjhjHW+w8uEs=";
    };
    nativeBuildInputs = [ pkgs.undmg ];
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications/
    '';
  };
in
lib.mkIf (!config.local.headless) {
  home.packages = [
    (if pkgs.stdenv.isDarwin then t3code-darwin else t3code-linux)
  ];
}
