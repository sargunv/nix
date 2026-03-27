# Home Manager configuration for sargunv.
{ lib, pkgs, ... }:
{
  imports = [
    ./shell
    ./git.nix
    ./editors
    ./packages.nix
    ./ssh.nix
    ./thaw.nix
  ];

  home.username = "sargunv";
  home.homeDirectory = lib.mkForce (
    if pkgs.stdenv.isDarwin then "/Users/sargunv" else "/home/sargunv"
  );

  home.sessionVariables = {
    PAGER = "less -RF --mouse";
    DELTA_PAGER = "less -RF --mouse";
  };

  home.packages = lib.optionals pkgs.stdenv.isLinux [
    (pkgs.runCommand "open" { } ''
      mkdir -p $out/bin
      ln -s ${pkgs.xdg-utils}/bin/xdg-open $out/bin/open
    '')
  ];

  xdg.enable = true;

  programs.man.generateCaches = lib.mkIf pkgs.stdenv.isDarwin false;

  # Restart user services when their config changes on rebuild
  systemd.user.startServices = lib.mkIf pkgs.stdenv.isLinux "sd-switch";

  home.stateVersion = "26.05";
}
