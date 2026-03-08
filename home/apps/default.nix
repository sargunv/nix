# GUI applications and editors.
{ pkgs, ... }:

{
  imports = [
    ./kitty.nix
    ./hyprland.nix
    ./vscodium.nix
    ./zed.nix
    ./t3code.nix
    ./voxtype.nix
  ];

  home.packages = with pkgs; [
    beeper
    vivaldi
    proton-pass
    proton-vpn-cli
    nerd-fonts.monaspace
  ];
}
