# Standalone packages and programs.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI tools
    ugrep
    fd
    bat
    fastfetch
    chafa
    nixfmt
    pastel

    # Container tools
    lazydocker

    # Disk utilities
    try
    caligula

    # Communication
    beeper
    slack
    discord

    # Browsers
    vivaldi

    # Media
    spotify
    pinta
    obs-studio
    kdePackages.kdenlive

    # Productivity
    obsidian
    typora
    localsend

    # Security
    proton-pass
    proton-pass-cli
    proton-vpn-cli

    # Gaming
    prismlauncher
  ];

  programs.btop.enable = true;

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
    ];
  };

  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };
}
