# VSCodium editor: config and extensions (cask on macOS, nixpkgs on Linux).
{
  config,
  lib,
  pkgs,
  vscode-extensions,
  ...
}:

let
  settingsPath =
    if pkgs.stdenv.isDarwin then
      "Library/Application Support/VSCodium/User/settings.json"
    else
      ".config/VSCodium/User/settings.json";
in
{
  thaw.paths = [ settingsPath ];
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
        # Stub: Homebrew cask manages the app; HM only manages config/extensions.
        pkgs.runCommand "vscodium-stub" { } ''
          mkdir -p $out/bin
          ln -s /Applications/VSCodium.app/Contents/Resources/app/bin/codium $out/bin/vscodium
        '' // {
          pname = "vscodium";
          version = "9999";
          meta = { mainProgram = "vscodium"; };
        }
      else
        pkgs.vscodium;
    mutableExtensionsDir = true;
    profiles.default = {
      extensions =
        (with pkgs.vscode-extensions; [
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
