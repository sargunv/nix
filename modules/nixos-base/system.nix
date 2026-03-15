# NixOS system basics: networking, locale, scheduling, and hardware services.
{
  # Networking
  networking.networkmanager.enable = true;

  # Locale
  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  # NixOS-specific gc scheduling
  nix.gc.dates = "weekly";

  # Auto-upgrade from GitHub
  system.autoUpgrade = {
    enable = true;
    flake = "github:sargunv/nix";
    dates = "04:00";
    allowReboot = false;
  };

  # Firmware updates
  services.fwupd.enable = true;

  # Compressed swap in RAM for OOM protection
  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };
}
