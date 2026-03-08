# Local LLM inference server (llama-cpp with Vulkan).
{ pkgs, ... }:
{
  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp-vulkan;
    port = 8000;
    extraFlags = [
      "-hf"
      "sweepai/sweep-next-edit-1.5b"
      "--cache-reuse"
      "64"
    ];
  };
}
