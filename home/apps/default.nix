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
    vscodium
    nerd-fonts.monaspace
  ];
}
