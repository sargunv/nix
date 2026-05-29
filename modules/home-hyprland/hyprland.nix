# Hyprland compositor and Wayland keybindings.
# https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  toLua = lib.generators.toLua { };

  mkMonitor = monitor:
    let
      parts = builtins.match "([^,]+), *([^,]+), *([^,]+), *([^,]+)(.*)" monitor;
      output = builtins.elemAt parts 0;
      mode = builtins.elemAt parts 1;
      position = builtins.elemAt parts 2;
      scale = builtins.elemAt parts 3;
      rest = builtins.elemAt parts 4;
      bitdepth = builtins.match ".*, *bitdepth, *([0-9]+).*" rest;
      transform = builtins.match ".*, *transform, *([0-9]+).*" rest;
    in
    if parts == null then
      ''hl.monitor(${toLua monitor})''
    else
      ''
        hl.monitor({
          output = ${toLua output},
          mode = ${toLua mode},
          position = ${toLua position},
          scale = ${toLua scale},
          ${lib.optionalString (transform != null) "transform = ${builtins.elemAt transform 0},"}
          ${lib.optionalString (bitdepth != null) "bitdepth = ${builtins.elemAt bitdepth 0},"}
        })
      '';

  mkWorkspace = workspace:
    let
      parts = builtins.match "([^,]+), *monitor:(.*), *default:true" workspace;
    in
    if parts == null then
      ''-- Unsupported workspace rule from Nix config: ${workspace}''
    else
      ''
        hl.workspace_rule({
          workspace = ${toLua (builtins.elemAt parts 0)},
          monitor = ${toLua (builtins.elemAt parts 1)},
          default = true,
        })
      '';
in

{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    extraConfig = ''
      local mod = "SUPER"

      hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
      hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
      hl.env("GDK_BACKEND", "wayland,x11,*")

      ${lib.concatMapStringsSep "\n" mkMonitor osConfig.local.desktop.monitors}

      ${lib.concatMapStringsSep "\n" mkWorkspace osConfig.local.desktop.workspaces}

      hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
      hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
      hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
      hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1.0} } })
      hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

      hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
      hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
      hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
      hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
      hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
      hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
      hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
      hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
      hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
      hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
      hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
      hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
      hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
      hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

      hl.on("hyprland.start", function()
        hl.exec_cmd("hyprpolkitagent")
        hl.exec_cmd(${toLua "${pkgs.bash}/bin/bash -lc \"xrdb -merge <<< 'Xft.dpi:${toString osConfig.local.desktop.xwaylandDpi}'\""})
      end)

      hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty"), { description = "Open terminal" })
      hl.bind(mod .. " + Space", hl.dsp.exec_cmd("vicinae toggle"), { description = "Open launcher" })
      hl.bind(mod .. " + Q", hl.dsp.window.close(), { description = "Kill active window" })
      hl.bind(mod .. " + P", hl.dsp.window.pseudo(), { description = "Toggle pseudotile" })
      hl.bind(mod .. " + F", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
      hl.bind(mod .. " + Z", hl.dsp.window.fullscreen(1), { description = "Toggle zen mode" })
      hl.bind(mod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"), { description = "Toggle notifications" })

      hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }), { description = "Focus left" })
      hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Focus right" })
      hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }), { description = "Focus up" })
      hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }), { description = "Focus down" })

      hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }), { description = "Move window left" })
      hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }), { description = "Move window right" })
      hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }), { description = "Move window up" })
      hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }), { description = "Move window down" })

      for i = 1, 9 do
        hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }), { description = "Workspace " .. i })
        hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }), { description = "Move to workspace " .. i })
      end

      hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Scroll to next workspace" })
      hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Scroll to previous workspace" })

      hl.bind("XF86Launch5", hl.dsp.exec_cmd("grimblast save area - | satty -f -"), { description = "Screenshot region" })
      hl.bind(mod .. " + XF86Launch5", hl.dsp.exec_cmd("grimblast save output - | satty -f -"), { description = "Screenshot monitor" })
      hl.bind(mod .. " + SHIFT + XF86Launch5", hl.dsp.exec_cmd("grimblast save screen - | satty -f -"), { description = "Screenshot all monitors" })

      hl.bind(mod .. " + R", function()
        hl.exec_cmd("hyprctl keyword general:col.active_border 'rgb(${config.lib.stylix.colors.base08})'")
        hl.dispatch(hl.dsp.submap("Resize"))
      end, { description = "Enter resize mode" })

      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { locked = true, repeating = true, description = "Volume up" })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), { locked = true, repeating = true, description = "Volume down" })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"), { locked = true, repeating = true, description = "Brightness up" })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { locked = true, repeating = true, description = "Brightness down" })

      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true, description = "Toggle mute" })
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"), { locked = true, description = "Toggle mic mute" })
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"), { locked = true, description = "Play/pause" })
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd("swayosd-client --playerctl next"), { locked = true, description = "Next track" })
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("swayosd-client --playerctl previous"), { locked = true, description = "Previous track" })
      hl.bind("Caps_Lock", hl.dsp.exec_cmd("swayosd-client --caps-lock"), { locked = true, description = "Caps Lock" })
      hl.bind("Num_Lock", hl.dsp.exec_cmd("swayosd-client --num-lock"), { locked = true, description = "Num Lock" })
      hl.bind("Scroll_Lock", hl.dsp.exec_cmd("swayosd-client --scroll-lock"), { locked = true, description = "Scroll Lock" })
      hl.bind("XF86Tools", hl.dsp.exec_cmd("voxtype record toggle"), { locked = true, description = "Toggle voice dictation" })

      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

      hl.define_submap("Resize", function()
        hl.bind("left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true, description = "Shrink left" })
        hl.bind("right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true, description = "Grow right" })
        hl.bind("up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true, description = "Shrink up" })
        hl.bind("down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true, description = "Grow down" })
        local exit_resize = function()
          hl.exec_cmd("hyprctl keyword general:col.active_border 'rgb(${config.lib.stylix.colors.base0D})'")
          hl.dispatch(hl.dsp.submap("reset"))
        end
        hl.bind("escape", exit_resize, { description = "Exit resize mode" })
        hl.bind(mod .. " + R", exit_resize, { description = "Exit resize mode" })
      end)

      hl.window_rule({ match = { class = "nm-connection-editor" }, float = true })
      hl.window_rule({ match = { class = "wdisplays" }, float = true })
      hl.window_rule({ match = { class = "com.gabm.satty" }, float = true })
      hl.window_rule({ match = { class = "localsend_app" }, float = true })
      hl.window_rule({ match = { class = "com.gabm.satty" }, size = "900 600" })
      hl.window_rule({ match = { class = "jetbrains-.*", title = "splash", float = true }, center = true })
      hl.window_rule({ match = { class = "jetbrains-.*", title = "splash", float = true }, no_focus = true })
      hl.window_rule({ match = { class = "jetbrains-.*", title = "win.*", float = true }, no_focus = true })
      hl.window_rule({ match = { class = "jetbrains-.*", float = true }, no_blur = true })
      hl.window_rule({ match = { class = "jetbrains-.*", float = true }, no_initial_focus = true })
      hl.window_rule({ match = { class = "jetbrains-.*", float = true }, opacity = "1 override 1 override 1" })
    '';
    settings = {
      config = {
        animations.enabled = true;
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
        input = {
          natural_scroll = true;
          scroll_method = "on_button_down";
          scroll_button = 274; # BTN_MIDDLE
          touchpad.natural_scroll = true;
        };
        xwayland.force_zero_scaling = true;
        dwindle.preserve_split = true;
        misc.disable_hyprland_logo = true;
      };
    };
  };
}
