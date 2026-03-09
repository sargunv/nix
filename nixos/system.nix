# System basics: networking, locale, and nix settings.
{ lib, ... }:

{
  options.local.headless = lib.mkEnableOption "headless mode (no GUI, no bootloader)";

  config = {
    # Networking
    networking.networkmanager.enable = true;

    # Locale
    time.timeZone = "America/Los_Angeles";
    i18n.defaultLocale = "en_US.UTF-8";

    # Nix settings
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    nix.settings.auto-optimise-store = true;

    # Auto-upgrade from GitHub
    system.autoUpgrade = {
      enable = true;
      flake = "github:sargunv/nix";
      dates = "04:00";
      allowReboot = false;
    };

    # Firmware updates
    services.fwupd.enable = true;

    # Compressed swap in RAM for OOM protection
    zramSwap = {
      enable = true;
      memoryPercent = 25;
    };
  };
}
