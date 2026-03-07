# GUI applications and editors.
{ pkgs, ... }:

{
  imports = [
    ./ghostty.nix
    ./vscodium.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    vivaldi
    proton-pass
    proton-vpn-cli
    nerd-fonts.monaspace
  ];
}
