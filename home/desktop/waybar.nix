# Waybar status bar.
{ config, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 4;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/submap" ];
      modules-right = [
        "tray"
        "custom/weather"
        "custom/brightness"
        "pulseaudio"
        "bluetooth"
        "network"
        "clock"
        "custom/voxtype"
      ];
      "hyprland/submap" = {
        format = "{}";
        tooltip = false;
      };
      "custom/weather" = {
        format = "{}°";
        tooltip = true;
        interval = 3600;
        exec = "wttrbar";
        return-type = "json";
        on-click = "gnome-weather";
      };
      "custom/brightness" = {
        format = "󰃠 ";
        interval = "once";
        tooltip = false;
        on-click = "kitty display-settings-tui";
      };
      clock = {
        format = "{:%H:%M}";
        tooltip-format = "{:%Y-%m-%d | %H:%M}";
      };
      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 muted";
        format-icons.default = [
          "󰕿"
          "󰖀"
          "󰕾"
        ];
        tooltip-format = "{desc}";
        reverse-scrolling = true;
        on-click = "kitty wiremix";
      };
      bluetooth = {
        format = "󰂲";
        format-on = "󰂯";
        format-connected = "󰂱 {num_connections}";
        tooltip-format-connected = "{device_alias}\t{device_battery_percentage}%";
        on-click = "kitty bluetui";
      };
      network = {
        format-ethernet = "󰈀";
        format-wifi = "󰖩 {signalStrength}%";
        format-disconnected = "󰖪";
        tooltip-format-ethernet = "{ifname}: {ipaddr}";
        tooltip-format-wifi = "{essid} ({signalStrength}%)";
        on-click = "kitty nmtui";
      };
      # https://raw.githubusercontent.com/peteonrails/voxtype/main/docs/WAYBAR.md
      "custom/voxtype" = {
        exec = "voxtype status --follow --format json";
        return-type = "json";
        format = "{} ";
        tooltip = true;
      };
    };
    style = ''
      #tray {
        margin-right: 4px;
      }
      #custom-voxtype.recording {
        color: #${config.lib.stylix.colors.base08};
      }
      #custom-voxtype.transcribing {
        color: #${config.lib.stylix.colors.base0A};
      }
    '';
  };
}
