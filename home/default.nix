# Home Manager configuration for sargunv.
{
  imports = [
    ./shell.nix
    ./git.nix
    ./tools.nix
    ./apps
  ];

  home.username = "sargunv";
  home.homeDirectory = "/home/sargunv";

  home.stateVersion = "25.11";
}
