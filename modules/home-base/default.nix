# Home Manager configuration for sargunv.
{ lib, pkgs, ... }:
{
  imports = [
    ./shell
    ./git.nix
    ./editors
    ./packages.nix
  ];

  home.username = "sargunv";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/sargunv" else "/home/sargunv";

  xdg.enable = true;

  # Restart user services when their config changes on rebuild
  systemd.user.startServices = lib.mkIf pkgs.stdenv.isLinux "sd-switch";

  home.stateVersion = "25.11";
}
