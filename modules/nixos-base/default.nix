# Shared NixOS modules, imported by all NixOS hosts.
{
  imports = [
    ./boot.nix
    ./home.nix
    ./inference.nix
    ./system.nix
    ./user.nix
  ];
}
