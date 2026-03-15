# Home Manager configuration for sargunv.
{ lib, pkgs, ... }:
{
  imports = [
    ./shell
    ./git.nix
    ./editors
    ./terminals.nix
    ./packages.nix
  ];

  home.username = "sargunv";
  home.homeDirectory = lib.mkForce (
    if pkgs.stdenv.isDarwin then "/Users/sargunv" else "/home/sargunv"
  );

  home.sessionVariables = {
    PAGER = "less -RF --mouse";
    DELTA_PAGER = "less -RF --mouse";
    FNOX_AGE_KEY_FILE = "~/.ssh/id_ed25519";
  };

  xdg.enable = true;

  # Restart user services when their config changes on rebuild
  systemd.user.startServices = lib.mkIf pkgs.stdenv.isLinux "sd-switch";

  home.stateVersion = "25.11";
}
