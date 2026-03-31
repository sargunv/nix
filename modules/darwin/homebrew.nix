# Homebrew: casks and Mac App Store apps.
{
  # Ensure Homebrew is on PATH (needed for mas and cask management)
  environment.systemPath = [ "/opt/homebrew/bin" ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.extraFlags = [ "--verbose" ];

    casks = [
      # Communication
      "beeper"
      "discord"
      "slack"

      # Media
      "obs"
      "audacity"

      # 3D Printing
      "bambu-studio"
      "freecad"
      "openscad"

      # Productivity
      "anki"
      "obsidian"
      "jetbrains-toolbox"
      "t3-code"
      "localsend"

      # Security
      "proton-pass"

      # Game Dev
      "godot"
      "blender"
      "tiled"

      # Gaming
      "prismlauncher"
      "steam"

      # macOS-only apps
      "bettermouse"
      "conductor"
      "ghostty"
      "handy"
      "jordanbaird-ice"
      "lunar"
      "orion"
      "proton-drive"
      "proton-mail-bridge"
      "protonvpn"
      "raspberry-pi-imager"
      "raycast"
      "rectangle"
      "sdformatter"
      "setapp"
      "vivaldi"
      "vscodium"
      "zed"
    ];

    masApps = {
      "Drag to Scroll" = 6748603900;
      "Folder Quick Look" = 6753110395;
      Infuse = 1136220934;
      Murasaki = 430300762;
      Passepartout = 1433648537;
    };
  };
}
