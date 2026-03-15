# nix-darwin configuration for Sarguns-MacBook-Pro.
{
  imports = [
    ../../modules/darwin
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "Sarguns-MacBook-Pro";

  system.stateVersion = 6;
}
