# Desktop environment: greetd, Hyprland, audio (PipeWire), and printing (CUPS).
# https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.local.desktop = {
    monitors = lib.mkOption { type = lib.types.listOf lib.types.str; };
    workspaces = lib.mkOption { type = lib.types.listOf lib.types.str; };
    xwaylandDpi = lib.mkOption { type = lib.types.int; };
  };

  config = lib.mkIf (!config.local.headless) {
    # Wire desktop-linux home-manager config
    home-manager.users.sargunv = {
      imports = [ ../home/desktop-linux ];
    };

    # Display manager
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "start-hyprland";
          user = "sargunv";
        };
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
          user = "greeter";
        };
      };
    };

    # Compositor
    programs.hyprland.enable = true;

    # Keyring
    services.gnome.gnome-keyring.enable = true;

    # Printing
    services.printing.enable = true;

    # Allow VIA to access keyboards via hidraw for remapping
    services.udev.packages = [ pkgs.via ];

    # DDC/CI for external monitor brightness control
    boot.kernelModules = [ "i2c-dev" ];
    services.udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    '';
    users.groups.i2c = { };

    # Steam
    programs.steam.enable = true;
    programs.steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];

    # Run unpatched binaries, AppImages, and Flatpaks
    programs.nix-ld.enable = true;
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
    services.flatpak.enable = true;

    # Bluetooth
    hardware.bluetooth.enable = true;

    # Audio
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
