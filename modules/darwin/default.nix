# macOS-specific modules: system defaults, Homebrew, and home-manager wiring.
let
  keys = import ../../keys.nix;
  allSshKeys =
    builtins.attrValues keys.hostSshKeys
    ++ builtins.attrValues keys.yubikeySshKeys;
in
{
  system.primaryUser = "sargunv";

  users.users.sargunv.openssh.authorizedKeys.keys = allSshKeys;

  imports = [
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
