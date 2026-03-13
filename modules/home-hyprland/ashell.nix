# Ashell status bar.
{ ... }:

{
  programs.ashell = {
    enable = true;
    systemd.enable = true;
    settings = {
      modules = {
        left = [ "Workspaces" ];
        center = [ "WindowTitle" ];
        right = [
          "SystemInfo"
          [
            "Tray"
            "Clock"
            "Privacy"
            "Settings"
            "CustomNotifications"
          ]
        ];
      };
      workspaces.visibility_mode = "MonitorSpecific";
      CustomModule = [
        {
          name = "CustomNotifications";
          icon = "";
          command = "swaync-client -t -sw";
          icons."dnd.*" = "";
          alert = ".*notification";
        }
      ];
    };
  };
}
