# Git and GitHub CLI configuration.
{ lib, pkgs, gitignore, ... }:

let
  keys = import ../../keys.nix;
  email = "sargunv@users.noreply.github.com";

  allSshKeys =
    builtins.attrValues keys.hostSshKeys
    ++ builtins.attrValues keys.yubikeySshKeys;

  allowedSignersFile = pkgs.writeText "allowed-signers"
    (builtins.concatStringsSep "\n"
      (map (key: "${email} ${key}") allSshKeys) + "\n");

  readIgnoreFile =
    path:
    builtins.filter (line: line != "" && !lib.hasPrefix "#" line) (
      lib.splitString "\n" (builtins.readFile path)
    );
in
{
  programs.git = {
    enable = true;
    ignores =
      readIgnoreFile "${gitignore}/Global/Linux.gitignore"
      ++ readIgnoreFile "${gitignore}/Global/macOS.gitignore"
      ++ readIgnoreFile "${gitignore}/Global/mise.gitignore";
    settings = {
      user = {
        name = "Sargun Vohra";
        email = email;
        signingKey = "~/.ssh/signing_key.pub";
      };
      init.defaultBranch = "main";
      branch.sort = "-committerdate";
      push = {
        autoSetupRemote = true;
        useForceIfIncludes = true;
      };
      pull.rebase = true;
      rebase.autoStash = true;
      diff.algorithm = "histogram";
      merge.conflictstyle = "zdiff3";
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "${allowedSignersFile}";
      commit.gpgSign = true;
      tag.gpgSign = true;
    } // lib.optionalAttrs pkgs.stdenv.isLinux {
      # TPM keys can't be read directly by ssh-keygen; inject -U to sign via agent
      gpg.ssh.program = toString (pkgs.writeShellScript "ssh-tpm-sign" ''
        args=()
        for arg in "$@"; do
          args+=("$arg")
          if [ "$arg" = "sign" ]; then
            args+=("-U")
          fi
        done
        exec ${pkgs.openssh}/bin/ssh-keygen "''${args[@]}"
      '');
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.lazygit = {
    enable = true;
    settings.gui.nerdFontsVersion = "3";
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "https";
    gitCredentialHelper = {
      enable = true;
    };
  };
}
