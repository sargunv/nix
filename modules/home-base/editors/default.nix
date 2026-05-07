# CLI editors, AI coding tools, and editorconfig.
{ ... }:

{
  imports = [
    ./neovim
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
