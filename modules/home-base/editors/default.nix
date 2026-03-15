# Code editors, AI coding tools, and editorconfig.
{
  imports = [
    ./neovim
    ./claude-code.nix
    ./codex.nix
    ./opencode.nix
    ./vscodium.nix
    ./zed.nix
  ];

  editorconfig = {
    enable = true;
    settings."*" = {
      charset = "utf-8";
      end_of_line = "lf";
      insert_final_newline = true;
      trim_trailing_whitespace = true;
    };
  };
}
