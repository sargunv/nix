# CLI tools and shell environment.
{ pkgs, ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./neovim.nix
    ./claude-code.nix
    ./codex.nix
    ./opencode.nix
  ];

  home.packages = with pkgs; [ ugrep proton-pass-cli nixfmt fd fastfetch bat chafa lazydocker try caligula pastel ];

  programs.btop.enable = true;

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
    ];
  };

  editorconfig = {
    enable = true;
    settings."*" = {
      charset = "utf-8";
      end_of_line = "lf";
      insert_final_newline = true;
      trim_trailing_whitespace = true;
    };
  };

  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };
}
