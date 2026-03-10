# Standalone packages and programs.
{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
