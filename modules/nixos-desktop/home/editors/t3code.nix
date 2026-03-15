# T3 Code - AI code editor by Ping
{ pkgs, ... }:

let
  version = "0.0.4";

  src = pkgs.fetchurl {
    url = "https://github.com/pingdotgg/t3code/releases/download/v${version}/T3-Code-${version}-x86_64.AppImage";
    hash = "sha256-HlkQ/uPLXHh2Duamrmhp31yQqnETawQ4Ru7kg2MmpVs=";
  };

  t3code = pkgs.appimageTools.wrapType2 {
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
  home.packages = [ t3code ];
}
