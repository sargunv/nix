# Shared NixOS modules, imported by all NixOS hosts.
{
  imports = [
    ../nanoclaw.nix
    ./nanoclaw.nix
    ../nix.nix
    ./boot.nix
    ./home.nix
    ./inference.nix
    ../ssh.nix
    ./sudo.nix
    ./system.nix
    ./user.nix
  ];
}
