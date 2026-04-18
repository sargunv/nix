# Shared inference configuration: options, model definitions, and llama-swap config.
# Platform-specific modules (nixos-base/inference.nix, darwin/inference.nix)
# import this and wire up the service layer.
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.local.inference;

  llama-server = lib.getExe' cfg.llama-cpp "llama-server";
  whisper-server = lib.getExe' cfg.whisper-cpp "whisper-server";

  models = {
    qwen35-35b-q8 = pkgs.fetchurl {
      url = "https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/resolve/main/Qwen3.6-35B-A3B-UD-Q8_K_XL.gguf";
      hash = "sha256-t2IhXF9Qf0hl30rD0a+oA4KK+kHgXsrD+sQxpnu9iOg=";
    };

    qwen35-35b-q4 = pkgs.fetchurl {
      url = "https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/resolve/main/Qwen3.6-35B-A3B-UD-Q4_K_XL.gguf";
      hash = "sha256-cHpVqKQ5fs3kTeDEmdPmjBrR0kDR2mWCa0lJ0QQ/RFA=";
    };

    whisper-large-v3-turbo = pkgs.fetchurl {
      url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo.bin";
      hash = "sha256-H8cPd0046xaZk6w5Huo1fvR8iHV+9y7llDh5t+jivGk=";
    };
  };

  llmModels =
    { }
    // lib.optionalAttrs cfg.qwen35b {
      "qwen3.6-35b-a3b" = {
        cmd = "${llama-server} --port \${PORT} -m ${cfg.qwen35bModel} -c ${toString cfg.qwen35bContext} --cache-reuse 1 -ngl 99 --temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.0 --presence-penalty 0.0 --repeat-penalty 1.0 --reasoning on --chat-template-kwargs '{\"preserve_thinking\":true}' --no-webui";
      };
    };

  persistentMembers = lib.filter (name: llmModels.${name}.persistent or false) (
    lib.attrNames llmModels
  );
  onDemandMembers = lib.filter (name: !(llmModels.${name}.persistent or false)) (
    lib.attrNames llmModels
  );
in
{
  options.local.inference = {
    llama-cpp = lib.mkOption {
      type = lib.types.package;
      default = if pkgs.stdenv.isDarwin then pkgs.llama-cpp else pkgs.llama-cpp-vulkan;
      description = "llama.cpp package to use for inference.";
    };

    whisper-cpp = lib.mkOption {
      type = lib.types.package;
      default = if pkgs.stdenv.isDarwin then pkgs.whisper-cpp else pkgs.whisper-cpp-vulkan;
      description = "whisper.cpp package to use for speech-to-text.";
    };

    qwen35b = lib.mkEnableOption "Qwen 3.6 35B-A3B (on-demand in llama-swap)";
    qwen35bModel = lib.mkOption {
      type = lib.types.path;
      default = models.qwen35-35b-q8;
      description = "GGUF model file for Qwen 3.6 35B-A3B.";
    };
    qwen35bContext = lib.mkOption {
      type = lib.types.int;
      default = 262144;
      description = "Context size for Qwen 3.6 35B-A3B.";
    };
    whisper = lib.mkEnableOption "Whisper Large V3 Turbo";

    _models = lib.mkOption {
      type = lib.types.attrs;
      internal = true;
      readOnly = true;
      default = models;
    };

    _llmModels = lib.mkOption {
      type = lib.types.attrs;
      internal = true;
      readOnly = true;
      default = llmModels;
    };

    _anyLlmEnabled = lib.mkOption {
      type = lib.types.bool;
      internal = true;
      readOnly = true;
      default = cfg.qwen35b;
    };

    _llama-swap-settings = lib.mkOption {
      type = lib.types.attrs;
      internal = true;
      readOnly = true;
      default = {
        healthCheckTimeout = 300;
        models = llmModels;
        groups =
          { }
          // lib.optionalAttrs (persistentMembers != [ ]) {
            always-on = {
              swap = false;
              exclusive = false;
              persistent = true;
              members = persistentMembers;
            };
          }
          // lib.optionalAttrs (onDemandMembers != [ ]) {
            on-demand = {
              swap = true;
              exclusive = false;
              members = onDemandMembers;
            };
          };
      };
    };

    _whisperServerArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      internal = true;
      readOnly = true;
      default = [
        whisper-server
        "--host"
        "127.0.0.1"
        "--port"
        "8090"
        "-m"
        (toString models.whisper-large-v3-turbo)
        "-l"
        "auto"
        "--convert"
        "--request-path"
        "/v1/audio"
        "--inference-path"
        "/transcriptions"
      ];
    };

    _whisperPath = lib.mkOption {
      type = lib.types.str;
      internal = true;
      readOnly = true;
      default = "${pkgs.ffmpeg-headless}/bin";
    };
  };
}
