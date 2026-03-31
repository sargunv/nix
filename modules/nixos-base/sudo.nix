# SSH agent-forwarded sudo authentication.
# Allows sudo via Touch ID / hardware key on the client machine.
{ ... }:
let
  keys = import ../../keys.nix;
  allSshKeys =
    builtins.attrValues keys.hostSshKeys
    ++ builtins.attrValues keys.yubikeySshKeys;
in
{
  security.pam.sshAgentAuth = {
    enable = true;
    authorizedKeysFiles = [ "/etc/ssh/sudo_authorized_keys" ];
  };

  security.pam.services.sudo.sshAgentAuth = true;

  security.sudo.extraConfig = ''
    Defaults env_keep += "SSH_AUTH_SOCK"
  '';

  environment.etc."ssh/sudo_authorized_keys" = {
    text = builtins.concatStringsSep "\n" allSshKeys + "\n";
    mode = "0444";
  };
}
