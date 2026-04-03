# Standalone packages and programs.
{ lib, pkgs, try-cli-package, ... }:

{
  home.packages = with pkgs; [
    # CLI tools
    comma
    fd
    bat
    jq
    sqlite
    numr
    fastfetch
    chafa
    nixfmt
    pastel
    sox

    # Container tools
    lazydocker

    # Disk utilities
    try-cli-package
    caligula

    # Security (CLI)
    gnupg
    proton-pass-cli
  ] ++ lib.optionals pkgs.stdenv.isLinux [
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
