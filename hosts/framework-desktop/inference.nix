# Local AI inference services. Models are fetched at build time.
# - LLMs via llama-swap (on-demand model loading)
# - Speech-to-text via whisper.cpp server
{ pkgs, lib, ... }:
let
  llama-server = lib.getExe' pkgs.llama-cpp-vulkan "llama-server";
  whisper-server = lib.getExe' pkgs.whisper-cpp-vulkan "whisper-server";

  models = {
    sweep-next-edit = pkgs.fetchurl {
      url = "https://huggingface.co/sweepai/sweep-next-edit-1.5B/resolve/main/sweep-next-edit-1.5b.q8_0.v2.gguf";
      hash = "sha256-EyHqXl11KeYPl3DGoLOpZfiVQtFs9K5RurJn9qiBUNo=";
    };

    qwen25-coder = pkgs.fetchurl {
      url = "https://huggingface.co/QuantFactory/Qwen2.5-Coder-1.5B-GGUF/resolve/main/Qwen2.5-Coder-1.5B.Q8_0.gguf";
      hash = "sha256-S1JPnoUJa1kICcHTXnthaQDQ2XfRLS907sFoUs3YXtY=";
    };

    qwen35-35b = pkgs.fetchurl {
      url = "https://huggingface.co/unsloth/Qwen3.5-35B-A3B-GGUF/resolve/main/Qwen3.5-35B-A3B-UD-Q8_K_XL.gguf";
      hash = "sha256-hqr2RkkfYjzgp9aYPqh4jjawnVnlVDpHmczFfuOvFak=";
    };

    whisper-large-v3-turbo = pkgs.fetchurl {
      url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo.bin";
      hash = "sha256-H8cPd0046xaZk6w5Huo1fvR8iHV+9y7llDh5t+jivGk=";
    };
  };
in
{
  # LLM inference via llama-swap
  services.llama-swap = {
    enable = true;
    port = 8000;
    settings = {
      healthCheckTimeout = 300;
      models = {
        "sweep-next-edit-1.5b" = {
          cmd = ''${llama-server} --port ''${PORT} -m ${models.sweep-next-edit} -c 4096 --cache-reuse 1 -ngl 99 --no-webui'';
          persistent = true;
        };
        "qwen2.5-coder-1.5b" = {
          cmd = ''${llama-server} --port ''${PORT} -m ${models.qwen25-coder} -c 4096 --cache-reuse 1 -ngl 99 --no-webui'';
          persistent = true;
        };
        "qwen3.5-35b-a3b" = {
          cmd = ''${llama-server} --port ''${PORT} -m ${models.qwen35-35b} -c 32768 --cache-reuse 1 -ngl 99 --no-webui'';
        };
      };
    };
  };

  # Speech-to-text via whisper.cpp server
  systemd.services.whisper-server = {
    description = "Whisper.cpp speech-to-text server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${whisper-server} --host 127.0.0.1 --port 8090 -m ${models.whisper-large-v3-turbo} -l en --convert --request-path /v1/audio --inference-path /transcriptions";
      Environment = "PATH=${pkgs.ffmpeg-headless}/bin";
      Restart = "on-failure";
      RestartSec = 5;
      DynamicUser = true;
      CacheDirectory = "whisper-server";
      RuntimeDirectory = "whisper-server";
      WorkingDirectory = "/run/whisper-server";
    };
  };
}
