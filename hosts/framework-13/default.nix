# NixOS configuration for framework-13.
{
  imports = [
    ../../modules/nixos-base
    ../../modules/nixos-desktop
    ./hardware-configuration.nix
  ];

  networking.hostName = "framework-13";

  local.desktop = {
    monitors = [ "eDP-1, preferred, auto, 1" ];
    workspaces = [ "1, default:true" ];
    xwaylandDpi = 192;
  };

  system.stateVersion = "25.11";
}
