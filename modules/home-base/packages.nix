# Standalone packages and programs.
{ lib, pkgs, try-cli-package, ... }:

let
  thaw = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "thaw";
    version = "0.20260322.0";
    src = pkgs.fetchurl {
      url = "https://github.com/sargunv/thaw/releases/download/v${version}/thaw_${version}_${
        if pkgs.stdenv.hostPlatform.isDarwin then "darwin" else "linux"
      }_${
        if pkgs.stdenv.hostPlatform.isAarch64 then "arm64" else "amd64"
      }.tar.gz";
      hash =
        if pkgs.stdenv.hostPlatform.isDarwin && pkgs.stdenv.hostPlatform.isAarch64 then
          "sha256-xHrDF4SMLgF4DIaNqvGmsy8a/hdsKvlSDE5Ft1fqt1k="
        else if pkgs.stdenv.hostPlatform.isDarwin then
          "sha256-0vYNAaH0Hv+tvbFzjCE4GbFQV/vpfG7pn5zQUbspMss="
        else if pkgs.stdenv.hostPlatform.isAarch64 then
          "sha256-0Ja70Q7GgqvEQDIsHg5cWL/boj0Vqw7d64LJLLQmxAU="
        else
          "sha256-oVvu5cQpfdtsfYdENkyZ47BwtgL+g68PnKojkyMJgjg=";
    };
    sourceRoot = ".";
    installPhase = ''
      install -Dm755 thaw $out/bin/thaw
    '';
  };
in
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

    # Dotfile management
    thaw

    # Security (CLI)
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
