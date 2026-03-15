# Shared Nix and nixpkgs settings.
{
  nixpkgs.config.allowUnfree = true;

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
