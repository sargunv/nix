# GUI packages.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Communication
    beeper
    slack
    discord

    # Browsers
    vivaldi

    # Media
    pinta
    obs-studio

    # Productivity
    anki
    obsidian
    # Security (GUI)
    proton-pass

    # Gaming
    prismlauncher
  ];
}
