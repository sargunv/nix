# Home Manager configuration for sargunv.
{
  imports = [
    ./tools
    ./apps
  ];

  home.username = "sargunv";
  home.homeDirectory = "/home/sargunv";

  xdg.enable = true;

  home.stateVersion = "25.11";
}
