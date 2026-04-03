# SSH client configuration with hardware-backed key support.
{ lib, pkgs, ... }:
let
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
    matchBlocks."*" = {
      forwardAgent = true;
      identityFile =
        if pkgs.stdenv.isDarwin then "~/.ssh/id_ecdsa_sk_rk"
        else if pkgs.stdenv.isLinux then "~/.ssh/id_ecdsa_tpm"
        else null;
    };
  };

  home.packages = [ load-yubikey ];

  # macOS: tell ssh-keygen where to find the Secure Enclave provider
  # (needed for git SSH signing, which calls ssh-keygen -Y sign)
  home.sessionVariables = lib.mkIf pkgs.stdenv.isDarwin {
    SSH_SK_PROVIDER = "/usr/lib/ssh-keychain.dylib";
  };


  # Linux: ssh-tpm-agent for TPM-backed SSH keys
  services.ssh-tpm-agent = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
  };
}
