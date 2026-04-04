# NFS mounts for Synology NAS.
{
  config,
  lib,
  ...
}:
let
  cfg = config.local.nfs;
in
{
  options.local.nfs = {
    backups = {
      enable = lib.mkEnableOption "NFS mount for backups from Synology NAS";
      mountPoint = lib.mkOption {
        type = lib.types.str;
        default = "/mnt/nas/backups";
        description = "Local mount point for the backups share.";
      };
    };
  };

  config = lib.mkIf cfg.backups.enable {
    fileSystems.${cfg.backups.mountPoint} = {
      device = "synology:/volume1/optiplex-backups";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
        "noauto"
        "nofail"
      ];
    };
  };
}
