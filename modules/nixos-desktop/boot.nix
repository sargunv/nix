# Desktop boot extras: Plymouth and LUKS password passthrough to gnome-keyring.
{ config, pkgs, lib, ... }:

{
  boot.plymouth.enable = true;

  # LUKS password passthrough to gnome-keyring via greetd auto-login.
  # greetd's initial_session skips PAM auth, so pam_systemd_loadkey won't work.
  # pam_fde_boot_pw runs in the session phase instead, retrieving the LUKS key
  # from the kernel keyring and injecting it into gnome-keyring.
  boot.initrd.systemd.enable = true;
  systemd.services.greetd.serviceConfig.KeyringMode = lib.mkForce "inherit";
  security.pam.services.greetd.rules.session.fde_boot_pw = {
    order = config.security.pam.services.greetd.rules.session.env.order + 10;
    control = "optional";
    modulePath = "${pkgs.pam_fde_boot_pw}/lib/security/pam_fde_boot_pw.so";
    args = [ "inject_for=gkr" ];
  };
}
