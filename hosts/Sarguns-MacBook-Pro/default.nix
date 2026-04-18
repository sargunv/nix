# nix-darwin configuration for Sarguns-MacBook-Pro.
{ config, ... }:
{
  imports = [
    ../../modules/darwin
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "Sarguns-MacBook-Pro";

  local.inference = {
    qwen35b = true;
    qwen35bModel = config.local.inference._models.qwen35-35b-q4;
  };

  system.stateVersion = 6;
}
