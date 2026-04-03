# macOS-specific modules: system defaults, Homebrew, and home-manager wiring.
{
  system.primaryUser = "sargunv";

  imports = [
    ../nanoclaw.nix
    ./nanoclaw.nix
    ../nix.nix
    ../stylix.nix
    ./defaults.nix
    ./homebrew.nix
    ./inference.nix
    ./auto-upgrade.nix
    ../ssh.nix
    ./docker.nix
    ./home.nix
  ];
}
