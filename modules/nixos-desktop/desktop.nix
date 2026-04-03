# Desktop environment: greetd, Hyprland, audio (PipeWire), and printing (CUPS).
# https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/
{
  lib,
  pkgs,
  vscode-extensions,
  zed-package,
  ...
}:
{
  options.local.desktop = {
    monitors = lib.mkOption { type = lib.types.listOf lib.types.str; };
    workspaces = lib.mkOption { type = lib.types.listOf lib.types.str; };
    xwaylandDpi = lib.mkOption { type = lib.types.int; };
  };

  config = {
    # Wire GUI and Hyprland home-manager config
    home-manager.extraSpecialArgs = {
      inherit vscode-extensions zed-package;
    };
    home-manager.users.sargunv = {
      imports = [
        ../home-desktop
        ../home-hyprland
      ];
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
    users.users.sargunv.extraGroups = [ "i2c" ];

    # Steam
    programs.steam.enable = true;
    programs.steam.extraCompatPackages = with pkgs; [ proton-ge-bin ];

    # AppImages and Flatpaks
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
    services.flatpak.enable = true;

    # File search index
    services.locate = {
      enable = true;
      package = pkgs.plocate;
      interval = "hourly";
    };

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
