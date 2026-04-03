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
        else if pkgs.stdenv.isLinux then "~/.ssh/id_ecdsa_tpm.tpm"
        else null;
    } // lib.optionalAttrs pkgs.stdenv.isLinux {
      # Point the SSH client at the TPM agent directly, so outbound SSH
      # works without setting SSH_AUTH_SOCK globally (which would break
      # agent-forwarded sudo by hiding the forwarded agent).
      extraOptions.IdentityAgent = "\${XDG_RUNTIME_DIR}/ssh-tpm-agent.sock";
    };
  };

  home.packages = [ load-yubikey ];

  # macOS: tell ssh-keygen where to find the Secure Enclave provider
  # (needed for git SSH signing, which calls ssh-keygen -Y sign)
  home.sessionVariables = lib.mkIf pkgs.stdenv.isDarwin {
    SSH_SK_PROVIDER = "/usr/lib/ssh-keychain.dylib";
  };


  # Linux: ssh-tpm-agent for TPM-backed SSH keys.
  # Don't let it set SSH_AUTH_SOCK globally — the SSH client uses
  # IdentityAgent instead, and sudo needs SSH_AUTH_SOCK to remain the
  # forwarded agent socket so it requires Touch ID via the remote key.
  services.ssh-tpm-agent = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    setSshAuthSock = false;
  };
}
