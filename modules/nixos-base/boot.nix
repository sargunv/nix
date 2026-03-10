# Boot configuration: Lanzaboote secure boot, kernel, and shared boot params.
{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.local.boot = {
    extraKernelParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Hardware-specific kernel parameters to append.";
    };
  };

  config = {
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
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ]
    ++ config.local.boot.extraKernelParams;
    boot.consoleLogLevel = 3;
    boot.initrd.verbose = false;
  };
}
