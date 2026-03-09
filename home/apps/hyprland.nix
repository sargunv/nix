# Hyprland compositor and Wayland utilities.
# https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
{ config, pkgs, ... }:

let
  power-menu = pkgs.writeShellScript "power-menu" ''
    choice=$(printf "Lock\nLogout\nReboot\nShutdown" | ${pkgs.rofi}/bin/rofi -dmenu -p "Power" -show-icons)
    case "$choice" in
      Lock) hyprlock ;;
      Logout) hyprshutdown ;;
      Reboot) hyprshutdown -t 'Restarting...' --post-cmd 'reboot' ;;
      Shutdown) hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0' ;;
    esac
  '';

  display-settings-tui = pkgs.buildGoModule {
    pname = "display-settings-tui";
    version = "unstable-2025-07-12";
    src = pkgs.fetchFromGitHub {
      owner = "navinreddy23";
      repo = "DisplaySettingsTUI";
      rev = "41cef6e250654df450e07a79c255f31702c4c419";
      hash = "sha256-lzqnZdyciF4xiZxNAgxDkcN3eEHkntKDriYH+yWtoDU=";
    };
    vendorHash = "sha256-g8sHKFih0ZZIZzrDtvOmrWdiuHd08APVkamYjzuZI6E=";
    subPackages = [ "cmd" ];
    postInstall = "mv $out/bin/cmd $out/bin/display-settings-tui";
  };
in

{
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # Remove minimize/maximize buttons from CSD windows (no-op on tiling WM)
  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = "appmenu:close";

  home.packages = with pkgs; [
    grimblast
    wl-clipboard
    brightnessctl
    pamixer
    ddcutil
    display-settings-tui
    hyprpolkitagent
    hyprshutdown
    hyprsunset
    hyprpicker
    xrdb
    nautilus
    gnome-weather
    gthumb
    evince
    mpv
    onlyoffice-desktopeditors
    bluetui
    wiremix
    wttrbar
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      submap = Resize: [arrows] resize  [Esc] exit
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
        "hyprpolkitagent"
        "hyprsunset"
        ''xrdb -merge <<< 'Xft.dpi:160' '' # Fix scaling for XWayland apps
      ];

      bind = [
        "$mod, Return, exec, kitty"
        "$mod, L, exec, rofi -show drun -show-icons" # [L]aunch
        "$mod, Q, killactive," # [Q]uit
        "$mod, F, togglefloating," # [F]loat
        "$mod, Z, fullscreen, 1" # [Z]en

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

        "$mod, M, exec, ${power-menu}" # [M]enu
        "$mod, R, exec, hyprctl keyword general:col.active_border 'rgb(${config.lib.stylix.colors.base08})'"
        "$mod, R, submap, Resize: [arrows] resize  [Esc] exit" # [R]esize

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
        # Voxtype toggle-to-talk (key sends XF86Tools instead of F13 on this keyboard)
        ", XF86Tools, exec, voxtype record toggle"
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
      spacing = 4;
      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/submap" ];
      modules-right = [ "tray" "custom/weather" "custom/brightness" "pulseaudio" "bluetooth" "network" "clock" "custom/voxtype" ];
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
        format-icons.default = [ "󰕿" "󰖀" "󰕾" ];
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

  # Hide desktop entries that clutter the app launcher
  xdg.desktopEntries = {
    nixos-manual = { name = "NixOS Manual"; exec = "nixos-help"; noDisplay = true; };
    cups = { name = "CUPS"; exec = "xdg-open http://localhost:631"; noDisplay = true; };
    qt5ct = { name = "Qt5 Settings"; exec = "qt5ct"; noDisplay = true; };
    qt6ct = { name = "Qt6 Settings"; exec = "qt6ct"; noDisplay = true; };
    nvim = { name = "Neovim wrapper"; exec = "nvim"; noDisplay = true; };
    kvantummanager = { name = "Kvantum Manager"; exec = "kvantummanager"; noDisplay = true; };
    rofi = { name = "Rofi"; exec = "rofi"; noDisplay = true; };
    rofi-theme-selector = { name = "Rofi Theme Selector"; exec = "rofi-theme-selector"; noDisplay = true; };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "application/pdf" = "org.gnome.Evince.desktop";
      "image/png" = "org.gnome.gThumb.desktop";
      "image/jpeg" = "org.gnome.gThumb.desktop";
      "image/gif" = "org.gnome.gThumb.desktop";
      "image/webp" = "org.gnome.gThumb.desktop";
      "image/bmp" = "org.gnome.gThumb.desktop";
      "image/svg+xml" = "org.gnome.gThumb.desktop";
      "text/markdown" = "typora.desktop";
      "video/mp4" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        blur_passes = 3;
        blur_size = 6;
      };
      input-field = {
        size = "250, 60";
        position = "0, -200";
        halign = "center";
        valign = "center";
        placeholder_text = "";
      };
      label = [
        {
          text = ''cmd[update:1000] date +"%H"'';
          font_size = 150;
          font_family = config.stylix.fonts.sansSerif.name;
          color = "rgba(${config.lib.stylix.colors.base09}99)";
          position = "0, 250";
          halign = "center";
          valign = "center";
        }
        {
          text = ''cmd[update:1000] date +"%M"'';
          font_size = 150;
          font_family = config.stylix.fonts.sansSerif.name;
          color = "rgba(${config.lib.stylix.colors.base05}99)";
          position = "0, 50";
          halign = "center";
          valign = "center";
        }
        {
          text = ''cmd[update:60000] date +"%A, %d %B"'';
          font_size = 24;
          font_family = config.stylix.fonts.sansSerif.name;
          color = "rgb(${config.lib.stylix.colors.base04})";
          position = "0, -80";
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
    };
  };
}
