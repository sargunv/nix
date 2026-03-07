# Boot configuration: Lanzaboote secure boot, kernel, and LUKS auto-login passthrough.
{ pkgs, ... }:

{
  # Lanzaboote secure boot
  boot.loader.systemd-boot.enable = false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # LUKS password passthrough to KWallet via auto-login
  boot.initrd.systemd.enable = true;
  services.displayManager.autoLogin.user = "sargunv";
  systemd.services.display-manager.serviceConfig.KeyringMode = "inherit";
  security.pam.services.sddm-autologin.text = pkgs.lib.mkBefore ''
    auth optional ${pkgs.systemd}/lib/security/pam_systemd_loadkey.so
    auth include sddm
  '';
}
