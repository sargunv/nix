# Linux desktop environment: Wayland compositor, terminal, and GUI utilities.
{ config, lib, pkgs, ... }:

let
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
  imports = [
    ./hyprland.nix
    ./ashell.nix
    ./lockscreen.nix
    ./notifications.nix
    ./voxtype.nix
    ./vicinae.nix
  ];

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # Volume/brightness on-screen display
  services.swayosd.enable = true;

  # Night Shift equivalent: warmer screen between sunset and sunrise.
  # Uses Hyprland's CTM protocol (HDR-correct) instead of wlr-gamma-control.
  xdg.configFile."sunsetr/sunsetr.toml".text = ''
    backend = "hyprland"
    transition_mode = "geo"
    latitude = 47.6
    longitude = -122.3
    day_temp = 6500
    night_temp = 4000
    day_gamma = 100
    night_gamma = 100
  '';

  systemd.user.services.sunsetr = {
    Unit = {
      Description = "Sunsetr - automatic blue light filter";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.sunsetr}/bin/sunsetr";
      Restart = "on-failure";
      RestartSec = 30;
      Slice = "background.slice";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Remove window buttons from CSD windows (no-op on tiling WM)
  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = "appmenu:";

  # GNOME Text Editor preferences
  dconf.settings."org/gnome/TextEditor" = {
    highlight-current-line = true;
    indent-style = "space";
    show-line-numbers = true;
    show-map = true;
    show-right-margin = true;
    tab-width = lib.hm.gvariant.mkUint32 4;
  };

  # Hide desktop entries for Qt/Kvantum settings apps (managed by Stylix)
  xdg.desktopEntries.qt5ct = { name = "Qt5 Settings"; noDisplay = true; };
  xdg.desktopEntries.qt6ct = { name = "Qt6 Settings"; noDisplay = true; };
  xdg.desktopEntries.kvantummanager = { name = "Kvantum Manager"; noDisplay = true; };

  # Vivaldi wrapper that detaches from the launcher (e.g. `gh repo view --web`)
  # so callers don't block until the browser exits.
  xdg.desktopEntries.vivaldi-detached = {
    name = "Vivaldi";
    genericName = "Web Browser";
    exec = "${pkgs.systemd}/bin/systemd-run --user --quiet --collect ${pkgs.vivaldi}/bin/vivaldi %U";
    icon = "vivaldi";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
    mimeType = [
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "text/html"
      "application/xhtml+xml"
    ];
    noDisplay = true;
  };

  home.packages = with pkgs; [
    # Wayland utilities
    playerctl
    grimblast
    satty
    wl-clipboard
    brightnessctl
    pamixer
    ddcutil
    display-settings-tui
    xrdb

    # Hyprland ecosystem
    hyprpolkitagent
    hyprshutdown
    hyprpicker

    # Desktop apps (Linux default handlers)
    pinta
    nautilus
    gthumb
    evince
    mpv
    onlyoffice-desktopeditors
    apostrophe
    baobab
    gnome-disk-utility
    fragments
    gnome-text-editor
    snapshot

    # GUI utilities
    wdisplays

  ];

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
      "x-scheme-handler/http" = "vivaldi-detached.desktop";
      "x-scheme-handler/https" = "vivaldi-detached.desktop";
      "text/html" = "vivaldi-detached.desktop";
      "application/xhtml+xml" = "vivaldi-detached.desktop";
      "text/plain" = "org.gnome.TextEditor.desktop";
      "text/markdown" = "org.gnome.gitlab.somas.Apostrophe.desktop";
      "video/mp4" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/quicktime" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
    };
  };
}
