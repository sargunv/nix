# VSCodium editor: config and extensions (package installed via cask on macOS).
{
  lib,
  pkgs,
  vscode-extensions,
  ...
}:

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
    package =
      if pkgs.stdenv.isDarwin then
        pkgs.emptyDirectory // {
          pname = "vscodium";
          version = "0";
          meta = { mainProgram = "codium"; };
        }
      else
        pkgs.vscodium;
    mutableExtensionsDir = pkgs.stdenv.isDarwin;
    profiles.default = {
      extensions = lib.mkIf pkgs.stdenv.isLinux (
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
        ])
      );
      userSettings = {
        "window.titleBarStyle" = "native";
        "window.menuBarVisibility" = "toggle";
      };
    };
  };
}
