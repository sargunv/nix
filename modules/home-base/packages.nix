# Standalone packages and programs.
{
  lib,
  pkgs,
  try-cli-package,
  ...
}:

let
  aviatorArchivePlatforms = {
    aarch64-darwin = "darwin_arm64";
    x86_64-darwin = "darwin_x86_64";
    aarch64-linux = "linux_arm64";
    x86_64-linux = "linux_x86_64";
  };
  aviatorHashes = {
    aarch64-darwin = "sha256-qAdTkaICL0j7vUCteI1QHne9zqGYsAGZfVVjUexAo/A=";
    x86_64-darwin = "sha256-K44tAx3bECUOmOhhdh/CLzwQFKpJwr4h2MM3g/fTJZs=";
    aarch64-linux = "sha256-w2FwIkjQ3pk7JD6m+xQOXrYy/MeA+QgchdEW0mUkJHE=";
    x86_64-linux = "sha256-1imkArU3anRHgkJZjAUUPb7URBMSETZ/iUrJ9ZjQ+eI=";
  };
  aviatorSystem = pkgs.stdenv.hostPlatform.system;
  aviatorArchivePlatform =
    aviatorArchivePlatforms.${aviatorSystem}
      or (throw "unsupported platform for aviator-cli: ${aviatorSystem}");

  aviator-cli = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "aviator-cli";
    version = "0.1.32";

    src = pkgs.fetchurl {
      url = "https://github.com/aviator-co/av/releases/download/v${version}/av_${version}_${aviatorArchivePlatform}.tar.gz";
      hash =
        aviatorHashes.${aviatorSystem} or (throw "unsupported platform for aviator-cli: ${aviatorSystem}");
    };

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      install -Dm755 av $out/bin/av
      mkdir -p $out/share
      cp -r man $out/share/man

      runHook postInstall
    '';

    meta = {
      description = "Command line tool to manage stacked PRs with Aviator";
      homepage = "https://github.com/aviator-co/av";
      license = lib.licenses.mit;
      mainProgram = "av";
      platforms = builtins.attrNames aviatorArchivePlatforms;
    };
  };
in
{
  home.packages =
    with pkgs;
    [
      # CLI tools
      aria2
      aviator-cli
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
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
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
