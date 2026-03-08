# Desktop environment: greetd, Hyprland, audio (PipeWire), and printing (CUPS).
{ pkgs, ... }:
{
  # Display manager
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "start-hyprland";
        user = "sargunv";
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  # Compositor
  programs.hyprland.enable = true;

  # Keyring
  services.gnome.gnome-keyring.enable = true;

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
