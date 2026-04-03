# NanoClaw: macOS launchd user agent
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.local.nanoclaw;
  nodePkg = pkgs.nodejs_20;
  workDir = "/Users/sargunv/nanoclaw";
in
{
  config = lib.mkIf cfg.enable {
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
  };
}
