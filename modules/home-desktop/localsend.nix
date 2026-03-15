# LocalSend - cross-platform file sharing (Linux only).
{ pkgs, lib, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  xdg.configFile."autostart/localsend_app.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=LocalSend
    Exec=localsend_app --hidden
    StartupNotify=false
    Terminal=false
  '';
}
