# Desktop environment: SDDM, Hyprland, audio (PipeWire), and printing (CUPS).
{ pkgs, ... }:
{
  # Display manager and desktop
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  programs.hyprland.enable = true;

  # Printing
  services.printing.enable = true;

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
