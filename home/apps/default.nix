# GUI applications and editors.
{ pkgs, lib, ... }:

{
  imports =
    [
      ./ghostty.nix
      ./vscodium.nix
      ./zed.nix
      ./t3code.nix
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
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
