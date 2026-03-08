# VSCodium editor.
{ pkgs, vscode-extensions, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions =
        (with pkgs.vscode-extensions; [
          vscodevim.vim
          jnoortheen.nix-ide
          rust-lang.rust-analyzer
          llvm-vs-code-extensions.vscode-clangd
          bradlc.vscode-tailwindcss
        ])
        ++ (with vscode-extensions.open-vsx; [
          vitest.explorer
          tombi-toml.tombi
          oxc.oxc-vscode
          hverlin.mise-vscode
          dprint.dprint
          github.vscode-github-actions
          mkhl.mkhl-just
          opentofu.vscode-opentofu
        ]);
      userSettings = {
        "editor.fontFamily" = "MonaspiceAr Nerd Font";
        "terminal.integrated.fontFamily" = "MonaspiceAr Nerd Font";
      };
    };
  };
}
