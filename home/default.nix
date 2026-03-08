# Home Manager configuration for sargunv.
{
  imports = [
    ./shell.nix
    ./git.nix
    ./tools.nix
    ./neovim.nix
    ./apps
  ];

  home.username = "sargunv";
  home.homeDirectory = "/home/sargunv";

  xdg.enable = true;

  home.stateVersion = "25.11";
}
