{ try-cli-package, ... }:
{
  imports = [
    ./zsh.nix
    ./starship.nix
    ./ugrep.nix
    ./tmux.nix
    ./tools.nix
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      eval (${try-cli-package}/bin/try init ~/Code/tries | string collect)
    '';
  };

}
