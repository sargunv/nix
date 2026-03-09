# Home Manager configuration for sargunv.
# Desktop environment (home/desktop) is imported per-host in flake.nix.
{
  imports = [
    ./shell
    ./git.nix
    ./editors
    ./packages.nix
  ];

  home.username = "sargunv";
  home.homeDirectory = "/home/sargunv";

  xdg.enable = true;

  # Restart user services when their config changes on rebuild
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
