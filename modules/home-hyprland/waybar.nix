# Waybar status bar.
{ ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 4;
      modules-left = [ "hyprland/workspaces" "hyprland/submap" "systemd-failed-units" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [
        "mpris"
        "privacy"
        "idle_inhibitor"
        "pulseaudio"
        "bluetooth"
        "network"
        "cpu"
        "memory"
        "battery"
        "clock"
      ];
      "hyprland/window" = {
        format = "{}";
        separate-outputs = true;
      };
      mpris = {
        format = "{player_icon} {title}";
        format-paused = "{player_icon} {status_icon} {title}";
        player-icons = {
          default = "▶";
          vivaldi = "󰖟";
        };
        status-icons = {
          paused = "⏸";
        };
        title-len = 30;
        tooltip-format = "{artist} — {title} ({album})";
      };
      privacy = {
        icon-size = 14;
        icon-spacing = 4;
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "󰅶";
          deactivated = "󰾪";
        };
        tooltip-format-activated = "Idle inhibitor on";
        tooltip-format-deactivated = "Idle inhibitor off";
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
        on-click = "pavucontrol";
      };
      bluetooth = {
        format = "󰂲";
        format-on = "󰂯";
        format-connected = "󰂱 {num_connections}";
        tooltip-format-connected = "{device_alias}\t{device_battery_percentage}%";
        on-click = "overskride";
      };
      network = {
        format-ethernet = "󰈀";
        format-wifi = "󰖩";
        format-disconnected = "󰖪";
        tooltip-format-ethernet = "{ifname}: {ipaddr}\n↓ {bandwidthDownBytes} ↑ {bandwidthUpBytes}";
        tooltip-format-wifi = "{essid} ({signalStrength}%)\n↓ {bandwidthDownBytes} ↑ {bandwidthUpBytes}";
        on-click = "nm-connection-editor";
      };
      cpu = {
        format = "󰻠 {icon}";
        format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
        tooltip-format = "{usage}%";
        on-click = "kitty btop";
      };
      memory = {
        format = "󰍛 {icon}";
        format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
        tooltip-format = "{percentage}% ({used:0.1f}G / {total:0.1f}G)";
        on-click = "kitty btop";
      };
      battery = {
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        states = {
          warning = 20;
          critical = 10;
        };
      };
      systemd-failed-units = {
        format = "✗ {nr_failed}";
        hide-on-ok = true;
      };
    };
    style = ''
      #pulseaudio {
        min-width: 20px;
      }
      #systemd-failed-units {
        color: @base08;
      }
    '';
  };
}
