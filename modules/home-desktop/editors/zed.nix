# Zed editor: config and extensions (cask on macOS, nixpkgs on Linux).
{ lib, pkgs, zed-package, ... }:

{
  # Symlink zeditor to zed (nixpkgs uses "zeditor" to avoid conflicts)
  home.file.".local/bin/zed" = lib.mkIf pkgs.stdenv.isLinux {
    source = "${zed-package}/bin/zeditor";
  };

  programs.zed-editor = {
    enable = true;
    package =
      if pkgs.stdenv.isDarwin then null else zed-package;
    extensions = [
      "nix"
      "oxc"
      "toml"
      "dockerfile"
      "git-firefly"
      "just"
    ];
    userSettings = {
      load_direnv = "shell_hook";
      edit_predictions = {
        provider = "zed";
      };
    };
  };
}
