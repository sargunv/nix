# nix-darwin configuration for Sarguns-MacBook-Pro.
{
  imports = [
    ../../modules/darwin
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "Sarguns-MacBook-Pro";

  local.inference = {
    sweepNextEdit = true;
    qwenCoder = true;
    qwen35b = true;
  };

  system.stateVersion = 6;
}
