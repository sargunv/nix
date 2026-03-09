# Hyprland compositor and Wayland keybindings.
# https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
{
  config,
  pkgs,
  osConfig,
  ...
}:

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
in

{
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

      # Host-specific monitor and workspace layout
      monitor = osConfig.local.desktop.monitors;
      workspace = osConfig.local.desktop.workspaces;

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
        scroll_button = 274; # BTN_MIDDLE
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
        "xrdb -merge <<< 'Xft.dpi:${toString osConfig.local.desktop.xwaylandDpi}' "
      ];

      bind = [
        "$mod, Return, exec, kitty"
        "$mod, Space, exec, rofi -show drun -show-icons" # Launch
        "$mod, Q, killactive," # [Q]uit
        "$mod, P, pseudo," # [P]seudotile
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
}
