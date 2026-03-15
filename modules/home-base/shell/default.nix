{
  imports = [
    ./zsh.nix
    ./starship.nix
    ./ugrep.nix
    ./tmux.nix
    ./tools.nix
  ];

  programs.fish.enable = true;
  programs.nushell.enable = true;
}
