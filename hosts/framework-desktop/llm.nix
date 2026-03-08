# Local LLM inference via llama-swap (on-demand model loading).
# Models are fetched at build time — no runtime downloads needed.
{ pkgs, lib, ... }:
let
  llama-server = lib.getExe' pkgs.llama-cpp-vulkan "llama-server";

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

  };
in
{
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
}
