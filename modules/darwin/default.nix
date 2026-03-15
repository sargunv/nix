# macOS-specific modules: system defaults, Homebrew, and home-manager wiring.
{
  system.primaryUser = "sargunv";

  imports = [
    ../nix.nix
    ../stylix.nix
    ./defaults.nix
    ./homebrew.nix
    ./home.nix
  ];
}
