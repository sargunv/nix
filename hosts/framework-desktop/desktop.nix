# Desktop environment: SDDM, Plasma 6, audio (PipeWire), and printing (CUPS).
{
  # Display manager and desktop
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Printing
  services.printing.enable = true;

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
