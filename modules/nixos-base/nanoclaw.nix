# NanoClaw: NixOS systemd user service
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.local.nanoclaw;
  nodePkg = pkgs.nodejs_20;
  workDir = "/home/sargunv/nanoclaw";
in
{
  config = lib.mkIf cfg.enable {
    systemd.user.services.nanoclaw = {
      description = "NanoClaw AI Agent";
      after = [
        "network.target"
        "docker.service"
      ];
      wantedBy = [ "default.target" ];
      path = [
        nodePkg
        pkgs.git
        pkgs.docker-client
      ];
      serviceConfig = {
        WorkingDirectory = workDir;
        ExecStart = "${nodePkg}/bin/node dist/index.js";
        Restart = "on-failure";
        RestartSec = 10;
        KillMode = "process";
      };
    };

    # User services survive SSH logout
    users.users.sargunv.linger = true;
  };
}
