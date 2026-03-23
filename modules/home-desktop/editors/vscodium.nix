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
      if pkgs.stdenv.isDarwin then pkgs.brewCasks.vscodium else pkgs.vscodium;
    mutableExtensionsDir = true;
    profiles.default = {
      extensions =
        (with pkgs.vscode-extensions; [
          anthropic.claude-code
          jnoortheen.nix-ide
          rust-lang.rust-analyzer
          llvm-vs-code-extensions.vscode-clangd
          bradlc.vscode-tailwindcss
        ])
        ++ (with vscode-extensions.open-vsx; [
          joaopaulocmarra.inline-blame-mini
          github.vscode-pull-request-github
          vitest.explorer
          tombi-toml.tombi
          golang.go
          hverlin.mise-vscode
          dprint.dprint
          github.vscode-github-actions
          opentofu.vscode-opentofu
          continue.continue
        ])
        ++ (with vscode-extensions.vscode-marketplace; [
          voidzero.vite-plus-extension-pack
          typespec.typespec-vscode
          tchoupinax.tilt
        ]);
      userSettings = {
        "go.alternateTools" = {
          "go" = "~/.local/share/mise/shims/go";
        };
        "update.mode" = "none";
        "mise.checkForNewMiseVersion" = false;
        "json.schemaDownload.trustedDomains" = {
          "https://schemastore.azurewebsites.net/" = true;
          "https://raw.githubusercontent.com/microsoft/vscode/" = true;
          "https://raw.githubusercontent.com/devcontainers/spec/" = true;
          "https://www.schemastore.org/" = true;
          "https://json.schemastore.org/" = true;
          "https://json-schema.org/" = true;
          "https://developer.microsoft.com/json-schemas/" = true;
          "https://dprint.dev" = true;
        };
      } // lib.optionalAttrs pkgs.stdenv.isLinux {
        "window.titleBarStyle" = "native";
        "window.menuBarVisibility" = "toggle";
      };
    };
  };
}
