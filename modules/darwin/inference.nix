# macOS inference services: launchd wiring for shared inference config.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.local.inference;

  settingsFormat = pkgs.formats.yaml { };
  llama-swap-config = settingsFormat.generate "config.yaml" cfg._llama-swap-settings;
in
{
  imports = [ ../inference.nix ];

  config = lib.mkMerge [
    # LLM inference via llama-swap
    (lib.mkIf cfg._anyLlmEnabled {
      launchd.daemons.llama-swap = {
        serviceConfig = {
          ProgramArguments = [
            (lib.getExe pkgs.llama-swap)
            "--listen=localhost:8000"
            "--config=${llama-swap-config}"
          ];
          RunAtLoad = true;
          KeepAlive = true;
          StandardOutPath = "/var/log/llama-swap.log";
          StandardErrorPath = "/var/log/llama-swap.log";
        };
      };
    })

    # Speech-to-text via whisper.cpp server
    (lib.mkIf cfg.whisper {
      launchd.daemons.whisper-server = {
        serviceConfig = {
          ProgramArguments = cfg._whisperServerArgs;
          EnvironmentVariables = {
            PATH = cfg._whisperPath;
          };
          RunAtLoad = true;
          KeepAlive = true;
          StandardOutPath = "/var/log/whisper-server.log";
          StandardErrorPath = "/var/log/whisper-server.log";
        };
      };
    })
  ];
}
