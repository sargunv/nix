# NixOS inference services: systemd wiring for shared inference config.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.local.inference;
in
{
  imports = [ ../inference.nix ];

  config = lib.mkMerge [
    # LLM inference via llama-swap
    (lib.mkIf cfg._anyLlmEnabled {
      services.llama-swap = {
        enable = true;
        port = 8000;
        settings = cfg._llama-swap-settings;
      };
    })

    # Speech-to-text via whisper.cpp server
    (lib.mkIf cfg.whisper {
      systemd.services.whisper-server = {
        description = "Whisper.cpp speech-to-text server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = lib.concatStringsSep " " cfg._whisperServerArgs;
          Environment = "PATH=${cfg._whisperPath}";
          Restart = "on-failure";
          RestartSec = 5;
          DynamicUser = true;
          CacheDirectory = "whisper-server";
          RuntimeDirectory = "whisper-server";
          WorkingDirectory = "/run/whisper-server";
        };
      };
    })
  ];
}
