# Shared NixOS modules, imported by all NixOS hosts.
{
  imports = [
    ../nanoclaw.nix
    ./backups.nix
    ./boot.nix
    ./crafty.nix
    ./home.nix
    ./inference.nix
    ./nanoclaw.nix
    ./nfs.nix
    ../nix.nix
    ../ssh.nix
    ./system.nix
    ./user.nix
  ];
}
