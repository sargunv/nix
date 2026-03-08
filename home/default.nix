# Home Manager configuration for sargunv.
{
  imports = [
    ./tools
    ./apps
  ];

  home.username = "sargunv";
  home.homeDirectory = "/home/sargunv";

  xdg.enable = true;

  # Restart user services when their config changes on rebuild
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
