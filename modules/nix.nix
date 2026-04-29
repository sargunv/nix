# Shared Nix and nixpkgs settings.
{
  nixpkgs.config.allowUnfree = true;

  # https://github.com/anthropics/claude-code/issues/41463
  nixpkgs.overlays = [
    (final: prev: {
      claude-code = prev.claude-code.overrideAttrs (old: {
        postFixup = (old.postFixup or "") + ''
          chmod +x $out/lib/node_modules/@anthropic-ai/claude-code/vendor/*/*/*
        '';
      });
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
