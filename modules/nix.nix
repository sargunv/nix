# Shared Nix and nixpkgs settings.
{
  nixpkgs.config.allowUnfree = true;

  # https://github.com/anthropics/claude-code/issues/41463
  nixpkgs.overlays = [
    (final: prev: {
      # mise pulls direnv as a runtime dep, and direnv 2.37.1's upstream
      # tests can hang on aarch64-darwin (watch-dir scenario). Skip checks
      # until nixpkgs catches up.
      direnv = prev.direnv.overrideAttrs (
        _old:
        prev.lib.optionalAttrs prev.stdenv.isDarwin {
          doCheck = false;
        }
      );
    })
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 14d";
  };

  nix.settings.auto-optimise-store = true;

  nix.channel.enable = false;
  nix.nixPath = [ ];
}
