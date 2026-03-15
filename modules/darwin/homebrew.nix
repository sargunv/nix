# Homebrew: managed casks and Mac App Store apps.
{
  # Ensure Homebrew is on PATH
  environment.systemPath = [ "/opt/homebrew/bin" ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;

    masApps = {
      "Drag to Scroll" = 6748603900;
      "Folder Quick Look" = 6753110395;
      Infuse = 1136220934;
      Murasaki = 430300762;
      Passepartout = 1433648537;
      Slack = 803453959;
    };

    casks = [
      # Communication
      "beeper"
      "discord"

      # Browsers
      "vivaldi"

      # Media
      "pinta"
      "obs"

      # Productivity
      "anki"
      "obsidian"
      "setapp"

      # Development
      "jetbrains-toolbox"
      "zed"
      "vscodium"
      "t3-code"

      # Terminals
      "ghostty"
      "kitty"

      # Utilities
      "jordanbaird-ice"
      "lunar"
      "raspberry-pi-imager"
      "raycast"
      "sdformatter"

      # Security
      "proton-drive"
      "proton-pass"
      "protonvpn"

      # Gaming
      "steam"
      "prismlauncher"
    ];
  };
}
