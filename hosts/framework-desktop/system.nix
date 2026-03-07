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
