# NixOS configuration for framework-desktop.
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./desktop.nix
    ./stylix.nix
    ./system.nix
    ./user.nix
    ./inference.nix
  ];

  system.stateVersion = "25.11";
}
