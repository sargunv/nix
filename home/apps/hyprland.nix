# Hyprland compositor and Wayland utilities.
# https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
{ config, pkgs, ... }:

{
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.packages = with pkgs; [
    grimblast
    wl-clipboard
    brightnessctl
    pamixer
    networkmanagerapplet
    hyprpolkitagent
    swww
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      submap = resize
      binde = , left, resizeactive, -20 0
      binde = , right, resizeactive, 20 0
      binde = , up, resizeactive, 0 -20
      binde = , down, resizeactive, 0 20
      bind = , escape, exec, hyprctl keyword general:col.active_border 'rgb(${config.lib.stylix.colors.base0D})'
      bind = , escape, submap, reset
      bind = $mod, R, exec, hyprctl keyword general:col.active_border 'rgb(${config.lib.stylix.colors.base0D})'
      bind = $mod, R, submap, reset
      submap = reset
    '';
    settings = {
      "$mod" = "SUPER";

      env = [
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "GDK_BACKEND,wayland,x11,*"
      ];

      # TODO: extract per-host monitor/workspace config when adding second machine
      monitor = [
        "desc:ASUSTek COMPUTER INC PG27UCDM TALMAV003641, 3840x2160@120, 0x525, 1.666667, bitdepth, 10"
        "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27U 23323B000942, 3840x2160@120, 2304x0, 1.666667, transform, 1, bitdepth, 10"
      ];

      workspace = [
        "1, monitor:desc:ASUSTek COMPUTER INC PG27UCDM TALMAV003641, default:true"
        "2, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27U 23323B000942, default:true"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow.enabled = false;
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint, 0.23, 1, 0.32, 1"
          "easeInOutCubic, 0.65, 0.05, 0.36, 1"
          "linear, 0, 0, 1, 1"
          "almostLinear, 0.5, 0.5, 0.75, 1.0"
          "quick, 0.15, 0, 0.1, 1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      input = {
        natural_scroll = true;
        scroll_method = "on_button_down";
        scroll_button = 274; # middle mouse
        touchpad.natural_scroll = true;
      };

      xwayland.force_zero_scaling = true;

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc.disable_hyprland_logo = true;

      exec-once = [
        "nm-applet --indicator"
        "hyprpolkitagent"
        "swww-daemon"
      ];

      bind = [
        "$mod, Return, exec, ghostty"
        "$mod, D, exec, fuzzel"
        "$mod, Q, killactive,"
        "$mod, F, fullscreen,"
        "$mod, V, togglefloating,"
        "$mod, P, pseudo,"
        "$mod, S, togglesplit,"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Move window
        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        # Scroll through workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        # Screenshots: F14 = monitor, SUPER+F14 = window, SHIFT+F14 = region
        ", F14, exec, grimblast copy output"
        "$mod, F14, exec, grimblast copy active"
        "SHIFT, F14, exec, grimblast copy area"

        # Lock screen
        "$mod, L, exec, hyprlock"

        # Logout menu
        "$mod, M, exec, ${pkgs.writeShellScript "power-menu" ''
          sel=$(printf 'Lock\nLogout\nReboot\nShutdown' | fuzzel --dmenu)
          case $sel in
            Lock) hyprlock;;
            Logout) hyprctl dispatch exit;;
            Reboot) systemctl reboot;;
            Shutdown) systemctl poweroff;;
          esac
        ''}"

        # Resize mode
        "$mod, R, exec, hyprctl keyword general:col.active_border 'rgb(${config.lib.stylix.colors.base08})'"
        "$mod, R, submap, resize"

        # Voxtype push-to-talk
        ", F13, exec, voxtype record start"
      ];

      # Volume and brightness (repeatable, works while locked)
      bindel = [
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
      ];

      bindl = [
        ", XF86AudioMute, exec, pamixer -t"
      ];

      # Voxtype: stop recording on key release
      bindr = [
        ", F13, exec, voxtype record stop"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "custom/voxtype" "pulseaudio" "network" "tray" ];
      clock = {
        format = "{:%H:%M}";
        tooltip-format = "{:%Y-%m-%d | %H:%M}";
      };
      pulseaudio = {
        format = "{volume}% {icon}";
        format-muted = "muted";
        format-icons.default = [ "" "" "" ];
        on-click = "pamixer -t";
      };
      network = {
        format-ethernet = "connected";
        format-wifi = "{essid} ({signalStrength}%)";
        format-disconnected = "disconnected";
      };
      "custom/voxtype" = {
        exec = "voxtype status --follow --format json --icon-theme nerd-font";
        return-type = "json";
        format = "{}";
        tooltip = true;
      };
    };
  };

  # Hide desktop entries that clutter the app launcher
  xdg.desktopEntries = {
    vim = { name = "Vim"; exec = "vim"; noDisplay = true; };
    gvim = { name = "GVim"; exec = "gvim"; noDisplay = true; };
    nixos-manual = { name = "NixOS Manual"; exec = "nixos-help"; noDisplay = true; };
    cups = { name = "CUPS"; exec = "xdg-open http://localhost:631"; noDisplay = true; };
    qt5ct = { name = "Qt5 Settings"; exec = "qt5ct"; noDisplay = true; };
    qt6ct = { name = "Qt6 Settings"; exec = "qt6ct"; noDisplay = true; };
  };

  programs.fuzzel = {
    enable = true;
    settings.main = {
      terminal = "ghostty";
      layer = "overlay";
    };
  };

  programs.hyprlock.enable = true;

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-radius = 5;
    };
  };
}
