# GUI applications and editors.
{ pkgs, ... }:

{
  imports = [
    ./ghostty.nix
  ];

  home.packages = with pkgs; [
    vivaldi
    proton-pass
    zed-editor
    vscodium
  ];
}
