# Shared NixOS modules, imported by all NixOS hosts.
{
  imports = [
    ./backups.nix
    ./boot.nix
    ./crafty.nix
    ./home.nix
    ./inference.nix
    ./nfs.nix
    ../nix.nix
    ../ssh.nix
    ./system.nix
    ./user.nix
  ];
}
