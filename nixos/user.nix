# User account and login shell.
{ pkgs, ... }:

{
  users.users.sargunv = {
    isNormalUser = true;
    description = "Sargun Vohra";
    shell = pkgs.zsh;
    extraGroups = [
      "i2c"
      "networkmanager"
      "wheel"
    ];
  };

  programs.zsh.enable = true;
}
