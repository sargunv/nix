# Homebrew: Mac App Store apps (casks managed via brew-nix).
{
  # Ensure Homebrew is on PATH (still needed for mas)
  environment.systemPath = [ "/opt/homebrew/bin" ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.extraFlags = [ "--verbose" ];

    # Casks that don't work with brew-nix (missing hashes)
    casks = [
      "handy"
      "orion"
      "sdformatter"
      "steam"
      "vivaldi"
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
