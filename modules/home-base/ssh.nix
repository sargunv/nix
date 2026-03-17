# SSH client configuration with hardware-backed key support.
{ lib, pkgs, ... }:
let
  keys = import ../../keys.nix;
  allSshKeys =
    builtins.attrValues keys.hostSshKeys
    ++ builtins.attrValues keys.yubikeySshKeys;

  load-yubikey = pkgs.writeShellScriptBin "load-yubikey" (
    ''
      set -euo pipefail
      mkdir -p ~/.ssh
      echo "downloading resident SSH keys from YubiKey..."
      echo "(touch YubiKey when it blinks)"
      cd ~/.ssh
    ''
    + lib.optionalString pkgs.stdenv.isDarwin ''
      ssh-keygen -K -w /usr/lib/ssh-keychain.dylib
    ''
    + lib.optionalString pkgs.stdenv.isLinux ''
      ssh-keygen -K
    ''
    + ''
      echo ""
      echo "SSH key handle installed to ~/.ssh/"
    ''
  );
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = lib.mkIf pkgs.stdenv.isDarwin {
      extraOptions.SecurityKeyProvider = "/usr/lib/ssh-keychain.dylib";
    };
  };

  home.packages = [ load-yubikey ];

  home.file.".ssh/authorized_keys".text =
    builtins.concatStringsSep "\n" allSshKeys + "\n";

  # Linux: ssh-tpm-agent for TPM-backed SSH keys
  services.ssh-tpm-agent = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
  };
}
