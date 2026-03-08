# User account and login shell.
{ pkgs, ... }:

{
  users.users.sargunv = {
    isNormalUser = true;
    description = "Sargun Vohra";
    shell = pkgs.zsh;
    extraGroups = [
      "input" # voxtype: evdev hotkey detection
      "networkmanager"
      "wheel"
    ];
  };

  programs.zsh.enable = true;
}
