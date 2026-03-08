# VSCodium editor.
{ pkgs, vscode-extensions, ... }:

{
  home.file.".continue/config.yaml".text = builtins.toJSON {
    name = "Local";
    version = "1.0.0";
    schema = "v1";
    allowAnonymousTelemetry = false;
    models = [
      {
        name = "Local Autocomplete";
        provider = "openai";
        apiBase = "http://localhost:8000/v1";
        model = "qwen2.5-coder-1.5b";
        apiKey = "none";
        roles = [ "autocomplete" ];
      }
    ];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;
    profiles.default = {
      extensions =
        (with pkgs.vscode-extensions; [
jnoortheen.nix-ide
          rust-lang.rust-analyzer
          llvm-vs-code-extensions.vscode-clangd
          bradlc.vscode-tailwindcss
        ])
        ++ (with vscode-extensions.open-vsx; [
          jdinhlife.gruvbox
          joaopaulocmarra.inline-blame-mini
          ms-python.python
          github.vscode-pull-request-github
          vitest.explorer
          tombi-toml.tombi
          oxc.oxc-vscode
          hverlin.mise-vscode
          dprint.dprint
          github.vscode-github-actions
          opentofu.vscode-opentofu
          continue.continue
        ]);
      userSettings = {
        "editor.fontFamily" = "MonaspiceAr Nerd Font";
        "terminal.integrated.fontFamily" = "MonaspiceAr Nerd Font";
        "workbench.colorTheme" = "Gruvbox Dark Hard";
      };
    };
  };
}
