# NanoClaw AI agent: shared options with platform-specific service wiring.
# Enable per-host with `local.nanoclaw.enable = true`.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.local.nanoclaw;
  nodePkg = pkgs.nodejs_20;
  homeDir =
    if pkgs.stdenv.isDarwin then "/Users/sargunv" else "/home/sargunv";
  workDir = "${homeDir}/nanoclaw";
in
{
  options.local.nanoclaw = {
    enable = lib.mkEnableOption "NanoClaw AI agent";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      # NixOS: systemd user service
      (lib.mkIf pkgs.stdenv.isLinux {
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
        security.loginctl-linger.users = [ "sargunv" ];
      })

      # macOS: launchd user agent
      (lib.mkIf pkgs.stdenv.isDarwin {
        launchd.user.agents.nanoclaw = {
          serviceConfig = {
            Label = "com.nanoclaw";
            ProgramArguments = [
              "${nodePkg}/bin/node"
              "dist/index.js"
            ];
            WorkingDirectory = workDir;
            RunAtLoad = true;
            KeepAlive = true;
            EnvironmentVariables = {
              PATH = lib.makeBinPath [
                nodePkg
                pkgs.git
                pkgs.docker-client
              ] + ":/usr/bin:/bin";
            };
            StandardOutPath = "${workDir}/logs/launchd-stdout.log";
            StandardErrorPath = "${workDir}/logs/launchd-stderr.log";
          };
        };
      })
    ]
  );
}
