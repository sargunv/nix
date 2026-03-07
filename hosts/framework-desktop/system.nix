# System basics: hostname, networking, nix settings, and system packages.
{ pkgs, ... }:

{
  # Networking
  networking.hostName = "framework-desktop";
  networking.networkmanager.enable = true;

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
}
