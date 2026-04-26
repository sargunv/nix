# Hyprland compositor and Wayland keybindings.
# https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
{
  config,
  pkgs,
  osConfig,
  ...
}:

{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      submap = Resize
      binded = , left, Shrink left, resizeactive, -20 0
      binded = , right, Grow right, resizeactive, 20 0
      binded = , up, Shrink up, resizeactive, 0 -20
      binded = , down, Grow down, resizeactive, 0 20
      bindd = , escape, Exit resize mode, exec, hyprctl keyword general:col.active_border 'rgb(${config.lib.stylix.colors.base0D})'
      bindd = , escape, Exit resize mode, submap, reset
      bindd = $mod, R, Exit resize mode, exec, hyprctl keyword general:col.active_border 'rgb(${config.lib.stylix.colors.base0D})'
      bindd = $mod, R, Exit resize mode, submap, reset
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

      windowrule = [
        "float on, match:class nm-connection-editor"
        "float on, match:class wdisplays"
        "float on, match:class com.gabm.satty"
        "float on, match:class localsend_app"
        "size 900 600, match:class com.gabm.satty"
        # JetBrains IDE fixes: https://github.com/hyprwm/Hyprland/issues/2412
        "center true, match:class jetbrains-.*, match:title splash, match:float true"
        "no_focus true, match:class jetbrains-.*, match:title splash, match:float true"
        "no_focus true, match:class jetbrains-.*, match:title win.*, match:float true"
        "no_blur true, match:class jetbrains-.*, match:float true"
        "no_initial_focus true, match:class jetbrains-.*, match:float true"
        "opacity 1 override 1 override 1, match:class jetbrains-.*, match:float true"
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
          size = 6;
          passes = 2;
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
        "xrdb -merge <<< 'Xft.dpi:${toString osConfig.local.desktop.xwaylandDpi}' "
      ];

      bindd = [
        "$mod, Return, Open terminal, exec, kitty"
        "$mod, Space, Open launcher, exec, vicinae toggle"
        "$mod, Q, Kill active window, killactive,"
        "$mod, P, Toggle pseudotile, pseudo,"
        "$mod, F, Toggle floating, togglefloating,"
        "$mod, Z, Toggle zen mode, fullscreen, 1"
        "$mod, N, Toggle notifications, exec, swaync-client -t -sw"

        "$mod, left, Focus left, movefocus, l"
        "$mod, right, Focus right, movefocus, r"
        "$mod, up, Focus up, movefocus, u"
        "$mod, down, Focus down, movefocus, d"

        "$mod SHIFT, left, Move window left, movewindow, l"
        "$mod SHIFT, right, Move window right, movewindow, r"
        "$mod SHIFT, up, Move window up, movewindow, u"
        "$mod SHIFT, down, Move window down, movewindow, d"

        "$mod, 1, Workspace 1, workspace, 1"
        "$mod, 2, Workspace 2, workspace, 2"
        "$mod, 3, Workspace 3, workspace, 3"
        "$mod, 4, Workspace 4, workspace, 4"
        "$mod, 5, Workspace 5, workspace, 5"
        "$mod, 6, Workspace 6, workspace, 6"
        "$mod, 7, Workspace 7, workspace, 7"
        "$mod, 8, Workspace 8, workspace, 8"
        "$mod, 9, Workspace 9, workspace, 9"

        "$mod SHIFT, 1, Move to workspace 1, movetoworkspace, 1"
        "$mod SHIFT, 2, Move to workspace 2, movetoworkspace, 2"
        "$mod SHIFT, 3, Move to workspace 3, movetoworkspace, 3"
        "$mod SHIFT, 4, Move to workspace 4, movetoworkspace, 4"
        "$mod SHIFT, 5, Move to workspace 5, movetoworkspace, 5"
        "$mod SHIFT, 6, Move to workspace 6, movetoworkspace, 6"
        "$mod SHIFT, 7, Move to workspace 7, movetoworkspace, 7"
        "$mod SHIFT, 8, Move to workspace 8, movetoworkspace, 8"
        "$mod SHIFT, 9, Move to workspace 9, movetoworkspace, 9"

        "$mod, mouse_down, Scroll to next workspace, workspace, e+1"
        "$mod, mouse_up, Scroll to previous workspace, workspace, e-1"

        ", XF86Launch5, Screenshot region, exec, grimblast save area - | satty -f -"
        "$mod, XF86Launch5, Screenshot monitor, exec, grimblast save output - | satty -f -"
        "$mod SHIFT, XF86Launch5, Screenshot all monitors, exec, grimblast save screen - | satty -f -"

        "$mod, R, Enter resize mode, exec, hyprctl keyword general:col.active_border 'rgb(${config.lib.stylix.colors.base08})'"
        "$mod, R, Enter resize mode, submap, Resize"
      ];

      # Volume and brightness (repeatable, works while locked)
      bindeld = [
        ", XF86AudioRaiseVolume, Volume up, exec, swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, Volume down, exec, swayosd-client --output-volume lower"
        ", XF86MonBrightnessUp, Brightness up, exec, swayosd-client --brightness raise"
        ", XF86MonBrightnessDown, Brightness down, exec, swayosd-client --brightness lower"
      ];

      # Non-repeatable, works while locked
      bindld = [
        ", XF86AudioMute, Toggle mute, exec, swayosd-client --output-volume mute-toggle"
        ", XF86AudioMicMute, Toggle mic mute, exec, swayosd-client --input-volume mute-toggle"
        ", XF86AudioPlay, Play/pause, exec, swayosd-client --playerctl play-pause"
        ", XF86AudioNext, Next track, exec, swayosd-client --playerctl next"
        ", XF86AudioPrev, Previous track, exec, swayosd-client --playerctl previous"
        ", Caps_Lock, Caps Lock, exec, swayosd-client --caps-lock"
        ", Num_Lock, Num Lock, exec, swayosd-client --num-lock"
        ", Scroll_Lock, Scroll Lock, exec, swayosd-client --scroll-lock"
        ", XF86Tools, Toggle voice dictation, exec, voxtype record toggle"
      ];

      # Mouse bindings
      bindmd = [
        "$mod, mouse:272, Move window, movewindow"
        "$mod, mouse:273, Resize window, resizewindow"
      ];
    };
  };
}
