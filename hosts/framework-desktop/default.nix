# NixOS configuration for framework-desktop.
{
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./desktop.nix
    ./system.nix
    ./user.nix
    ./llm.nix
  ];

  system.stateVersion = "25.11";
}
