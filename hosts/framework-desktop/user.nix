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
      "uinput" # voxtype: dotool text output (Plasma workaround, not needed on Hyprland/Sway)
      "wheel"
    ];
  };

  programs.zsh.enable = true;
}
