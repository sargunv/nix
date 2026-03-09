# Boot configuration: Lanzaboote secure boot, kernel, and LUKS auto-login passthrough.
{
  config,
  pkgs,
  lib,
  ...
}:

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
  boot.kernelParams = [
    "amdgpu.gttsize=114688" # 112 GB GTT (system memory for GPU)
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "udev.log_priority=3"
    "rd.systemd.show_status=auto"
  ];
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
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
