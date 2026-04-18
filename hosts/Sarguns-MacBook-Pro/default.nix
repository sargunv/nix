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
  };

  system.stateVersion = 6;
}
