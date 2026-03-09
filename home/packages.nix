# Standalone packages and programs.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages =
    (with pkgs; [
      # CLI tools
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

      # Security (CLI)
      proton-pass-cli
      proton-vpn-cli
    ])
    ++ lib.optionals (!config.local.headless) (
      with pkgs;
      [
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
        obsidian
        typora
        localsend

        # Security (GUI)
        proton-pass

        # Gaming
        prismlauncher
      ]
    );

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
