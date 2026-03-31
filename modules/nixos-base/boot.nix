# Boot configuration: Lanzaboote secure boot, kernel, and shared boot params.
{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.local.boot = {
    secureBoot = lib.mkEnableOption "Lanzaboote secure boot" // { default = true; };
    extraKernelParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Hardware-specific kernel parameters to append.";
    };
  };

  config = {
    # Boot loader
    boot.loader.systemd-boot.enable = !config.local.boot.secureBoot;
    boot.lanzaboote = lib.mkIf config.local.boot.secureBoot {
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
