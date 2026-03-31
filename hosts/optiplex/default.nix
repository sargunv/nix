# NixOS configuration for optiplex.
{
  imports = [
    ../../modules/nixos-base
    ./hardware-configuration.nix
  ];

  networking.hostName = "optiplex";

  local.boot.secureBoot = false;

  system.stateVersion = "25.11";
}
