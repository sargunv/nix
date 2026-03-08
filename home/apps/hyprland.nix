# Hyprland compositor and Wayland utilities.
{ pkgs, ... }:

{
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.packages = with pkgs; [
    grimblast
    wl-clipboard
    cliphist
    brightnessctl
    pamixer
    networkmanagerapplet
    wlogout
    hyprpolkitagent
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

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
        "col.active_border" = "rgba(d79921ee)";
        "col.inactive_border" = "rgba(928374aa)";
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

      animations.enabled = true;

      input = {
        natural_scroll = true;
        scroll_method = "on_button_down";
        scroll_button = 274; # middle mouse
        touchpad.natural_scroll = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        disable_hyprland_logo = true;
        background_color = "rgb(1d2021)";
      };

      exec-once = [
        "nm-applet --indicator"
        "hyprpolkitagent"
        "wl-paste --watch cliphist store"
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

        # Clipboard history
        "$mod SHIFT, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"

        # Logout menu
        "$mod, M, exec, wlogout"
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
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "tray" ];
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
      };
    };
    style = ''
      * {
        font-family: "MonaspiceAr Nerd Font";
        font-size: 14px;
      }
      window#waybar {
        background-color: rgba(29, 32, 33, 0.9);
        color: #ebdbb2;
      }
      #workspaces button {
        padding: 0 5px;
        color: #928374;
      }
      #workspaces button.active {
        color: #d79921;
      }
      #clock, #pulseaudio, #network, #tray {
        padding: 0 10px;
      }
    '';
  };

  programs.fuzzel = {
    enable = true;
    settings.main = {
      terminal = "ghostty";
      layer = "overlay";
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        color = "rgb(1d2021)";
      };
      input-field = [
        {
          size = "300, 50";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.5;
          outer_color = "rgb(d79921)";
          inner_color = "rgb(282828)";
          font_color = "rgb(ebdbb2)";
          fade_on_empty = false;
          placeholder_text = "<i>Password...</i>";
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

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
      background-color = "#282828";
      text-color = "#ebdbb2";
      border-color = "#d79921";
    };
  };
}
