# Shared SSH server configuration.
{ lib, pkgs, ... }:
{
  services.openssh = {
    enable = true;
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    extraConfig = ''
      PasswordAuthentication no
      PermitRootLogin no
    '';
  };
}
