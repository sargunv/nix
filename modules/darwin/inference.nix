# macOS inference services: launchd wiring for shared inference config.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.local.inference;
  user = config.system.primaryUser;
  userLogDir = "/Users/${user}/Library/Logs";
  llamaSwapLog = "${userLogDir}/llama-swap.log";
  whisperLog = "${userLogDir}/whisper-server.log";

  settingsFormat = pkgs.formats.yaml { };
  llama-swap-config = settingsFormat.generate "config.yaml" cfg._llama-swap-settings;
in
{
  imports = [ ../inference.nix ];

  config = lib.mkMerge [
    # LLM inference via llama-swap
    (lib.mkIf cfg._anyLlmEnabled {
      launchd.user.agents.llama-swap = {
        serviceConfig = {
          ProgramArguments = [
            (lib.getExe pkgs.llama-swap)
            "--listen=localhost:8000"
            "--config=${llama-swap-config}"
          ];
          RunAtLoad = true;
          KeepAlive = true;
          ProcessType = "Interactive";
          StandardOutPath = llamaSwapLog;
          StandardErrorPath = llamaSwapLog;
        };
      };
    })

    # Speech-to-text via whisper.cpp server
    (lib.mkIf cfg.whisper {
      launchd.user.agents.whisper-server = {
        serviceConfig = {
          ProgramArguments = cfg._whisperServerArgs;
          EnvironmentVariables = {
            PATH = cfg._whisperPath;
          };
          RunAtLoad = true;
          KeepAlive = true;
          ProcessType = "Interactive";
          StandardOutPath = whisperLog;
          StandardErrorPath = whisperLog;
        };
      };
    })
  ];
}
