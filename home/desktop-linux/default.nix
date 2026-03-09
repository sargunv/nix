# Linux desktop environment: Wayland compositor, terminal, and GUI utilities.
{ config, pkgs, ... }:

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
    ./waybar.nix
    ./lockscreen.nix
    ./notifications.nix
    ./voxtype.nix
  ];

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  # Remove minimize/maximize buttons from CSD windows (no-op on tiling WM)
  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = "appmenu:close";

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
    hyprsunset
    hyprpicker

    # Desktop apps (Linux default handlers)
    nautilus
    gnome-weather
    gthumb
    evince
    mpv
    onlyoffice-desktopeditors
    baobab
    gnome-disk-utility

    # GUI utilities for waybar
    networkmanagerapplet
    overskride
    pavucontrol
    wdisplays
    wttrbar
  ];

  # Terminal emulator
  stylix.opacity.terminal = 0.85;
  programs.kitty = {
    enable = true;
    settings = {
      window_padding_width = 8;
      active_tab_font_style = "bold";
    };
  };

  # App launcher
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
  };

  # Hide desktop entries that clutter the app launcher
  xdg.desktopEntries = {
    nixos-manual = {
      name = "NixOS Manual";
      exec = "nixos-help";
      noDisplay = true;
    };
    cups = {
      name = "CUPS";
      exec = "xdg-open http://localhost:631";
      noDisplay = true;
    };
    qt5ct = {
      name = "Qt5 Settings";
      exec = "qt5ct";
      noDisplay = true;
    };
    qt6ct = {
      name = "Qt6 Settings";
      exec = "qt6ct";
      noDisplay = true;
    };
    nvim = {
      name = "Neovim wrapper";
      exec = "nvim";
      noDisplay = true;
    };
    kvantummanager = {
      name = "Kvantum Manager";
      exec = "kvantummanager";
      noDisplay = true;
    };
    rofi = {
      name = "Rofi";
      exec = "rofi";
      noDisplay = true;
    };
    rofi-theme-selector = {
      name = "Rofi Theme Selector";
      exec = "rofi-theme-selector";
      noDisplay = true;
    };
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
}
