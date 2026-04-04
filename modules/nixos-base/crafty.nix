# Crafty Controller: Minecraft server manager via Docker.
{
  config,
  lib,
  ...
}:
let
  cfg = config.local.crafty;
  dataDir = "/var/lib/crafty";
in
{
  options.local.crafty = {
    enable = lib.mkEnableOption "Crafty Controller Minecraft server manager";
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to open firewall ports for the web UI and Minecraft.";
    };
    minecraftPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [ 25565 ];
      description = "Minecraft server ports to expose.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.backend = "docker";
    virtualisation.oci-containers.containers.crafty = {
      image = "registry.gitlab.com/crafty-controller/crafty-4:latest";
      ports =
        [ "8443:8443" ]
        ++ map (p: "${toString p}:${toString p}") cfg.minecraftPorts;
      volumes = [
        "${dataDir}/backups:/crafty/backups"
        "${dataDir}/logs:/crafty/logs"
        "${dataDir}/servers:/crafty/servers"
        "${dataDir}/config:/crafty/app/config"
        "${dataDir}/import:/crafty/import"
      ];
      environment = {
        TZ = config.time.timeZone;
      };
    };

    # Create data directory
    systemd.tmpfiles.rules = [
      "d ${dataDir} 0755 root root -"
    ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8443 ] ++ cfg.minecraftPorts;
    };
  };
}
