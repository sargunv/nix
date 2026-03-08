# Desktop environment: SDDM, Plasma 6, audio (PipeWire), and printing (CUPS).
{ pkgs, ... }:
{
  # Display manager and desktop
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Printing
  services.printing.enable = true;

  # Plasma workaround: uinput access for dotool, needed because KDE Wayland
  # doesn't support the virtual keyboard protocol that wtype uses.
  # On Hyprland/Sway, wtype works natively and this can be removed.
  hardware.uinput.enable = true;

  # Plasma workaround: F13-F24 are mapped to XF86 media keys by default.
  # This treats them as regular function keys for use as custom hotkeys.
  services.xserver.xkb.options = "fkeys:basic_13-24";

  # Allow VIA to access keyboards via hidraw for remapping
  services.udev.packages = [ pkgs.via ];

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
