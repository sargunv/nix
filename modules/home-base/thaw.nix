# Thaw: materialize Nix-managed symlinks into mutable copies after activation.
# Modules can append to `thaw.paths` to declare files that apps need to write to.
{
  config,
  lib,
  pkgs,
  ...
}:

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
  options.thaw.paths = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Home-relative paths to materialize after home-manager activation.";
  };

  config = {
    home.packages = [ thaw ];

    home.activation.thaw-configs = lib.mkIf (config.thaw.paths != [ ]) (
      lib.hm.dag.entryAfter [ "writeBoundary" ] (
        lib.concatMapStringsSep "\n" (
          p: ''${thaw}/bin/thaw materialize "${config.home.homeDirectory}/${p}" || true''
        ) config.thaw.paths
      )
    );
  };
}
