# Shared NixOS modules, imported by all hosts.
{
  imports = [
    ./boot.nix
    ./desktop.nix
    ./home.nix
    ./inference.nix
    ./stylix.nix
    ./system.nix
    ./user.nix
  ];
}
