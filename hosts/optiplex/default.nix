# NixOS configuration for optiplex.
{
  imports = [
    ../../modules/nixos-base
    ./hardware-configuration.nix
  ];

  networking.hostName = "optiplex";

  local.boot.secureBoot = false;
  local.nanoclaw.enable = true;

  local.nfs.backups.enable = true;

  local.backups = {
    enable = true;
    paths = [
      "/var/lib/crafty"
      "/home/sargunv/nanoclaw"
    ];
  };

  local.crafty = {
    enable = true;
    minecraftPorts = [
      25565
      25566
      25567
      25568
      25569
    ];
    sidecarPorts = [
      25564
      25563
      25562
      25561
      25560
    ];
  };

  system.stateVersion = "25.11";
}
