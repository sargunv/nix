# GUI applications and editors.
{ pkgs, ... }:

{
  imports = [
    ./ghostty.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    vivaldi
    proton-pass
    proton-vpn-cli
    vscodium
    nerd-fonts.monaspace
  ];
}
