# Ashell status bar.
{ ... }:

{
  programs.ashell = {
    enable = true;
    systemd.enable = true;
    settings = {
      modules = {
        left = [ "Workspaces" "MediaPlayer" ];
        center = [ "WindowTitle" ];
        right = [ "SystemInfo" [ "Tray" "Clock" "Privacy" "Settings" ] ];
      };
      workspaces.visibility_mode = "MonitorSpecific";
    };
  };
}
