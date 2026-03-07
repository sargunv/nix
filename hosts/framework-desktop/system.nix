# System basics: hostname, networking, locale, nix settings, and system packages.
{ pkgs, ... }:

{
  # Networking
  networking.hostName = "framework-desktop";
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

  # System packages
  environment.systemPackages = with pkgs; [
    sbctl
    git
    vim
    wget
  ];

  # Firmware updates
  services.fwupd.enable = true;

  # Compressed swap in RAM for OOM protection
  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };
}
