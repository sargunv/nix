# User account and login shell.
{ pkgs, ... }:

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
  };

  programs.zsh.enable = true;
}
