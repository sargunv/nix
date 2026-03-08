# GUI applications and editors.
{ pkgs, ... }:

{
  imports = [
    ./ghostty.nix
    ./vscodium.nix
    ./zed.nix
    ./t3code.nix
    ./voxtype.nix
  ];

  home.packages = with pkgs; [
    beeper
    via
    vivaldi
    proton-pass
    proton-vpn-cli
    nerd-fonts.monaspace
  ];
}
