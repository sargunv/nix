# Restic backups to NAS.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.local.backups;
  nfsCfg = config.local.nfs;
in
{
  options.local.backups = {
    enable = lib.mkEnableOption "restic backups to NAS";
    paths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Paths to back up.";
    };
    timerOnCalendar = lib.mkOption {
      type = lib.types.str;
      default = "daily";
      description = "systemd OnCalendar expression for backup frequency.";
    };
    pruneOpts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
      ];
      description = "Restic forget/prune retention policy.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = nfsCfg.backups.enable;
        message = "local.backups requires local.nfs.backups to be enabled.";
      }
      {
        assertion = cfg.paths != [ ];
        message = "local.backups.paths must not be empty.";
      }
    ];

    # Generate the restic password file on first activation.
    system.activationScripts.resticPassword = ''
      if [ ! -f /etc/restic-password ]; then
        ${pkgs.openssl}/bin/openssl rand -base64 32 > /etc/restic-password
        chmod 600 /etc/restic-password
      fi
    '';

    environment.systemPackages = [ pkgs.restic ];
    environment.shellAliases.resticb = "sudo restic -r ${nfsCfg.backups.mountPoint}/restic --password-file /etc/restic-password";

    services.restic.backups.nas = {
      repository = "${nfsCfg.backups.mountPoint}/restic";
      passwordFile = "/etc/restic-password";
      paths = cfg.paths;
      pruneOpts = cfg.pruneOpts;
      timerConfig = {
        OnCalendar = cfg.timerOnCalendar;
        Persistent = true;
      };
      initialize = true;
    };
  };
}
