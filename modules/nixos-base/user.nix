# User account and login shell.
{ pkgs, ... }:
let
  keys = import ../../keys.nix;
  allSshKeys =
    builtins.attrValues keys.hostSshKeys
    ++ builtins.attrValues keys.yubikeySshKeys;
in
{
  users.users.sargunv = {
    isNormalUser = true;
    description = "Sargun Vohra";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "tss"
      "docker"
    ];
    openssh.authorizedKeys.keys = allSshKeys;
  };

  programs.zsh.enable = true;
}
