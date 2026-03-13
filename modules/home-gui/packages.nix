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
    android-studio
    # Security (GUI)
    proton-pass

    # Gaming
    prismlauncher
  ];
}
