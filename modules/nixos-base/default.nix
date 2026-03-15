# Shared NixOS modules, imported by all NixOS hosts.
{
  imports = [
    ../nix.nix
    ./boot.nix
    ./home.nix
    ./inference.nix
    ./system.nix
    ./user.nix
  ];
}
