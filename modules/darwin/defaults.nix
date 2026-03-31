# macOS system defaults and Touch ID sudo.
{  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.defaults = {
    # Keyboard: fast repeat, no press-and-hold
    NSGlobalDomain.InitialKeyRepeat = 15;
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.ApplePressAndHoldEnabled = false;

    # 24-hour clock
    NSGlobalDomain.AppleICUForce24HourTime = true;
    menuExtraClock.Show24Hour = true;

    # Finder: show extensions, pathbar, and status bar
    NSGlobalDomain.AppleShowAllExtensions = true;
    finder.ShowPathbar = true;
    finder.ShowStatusBar = true;

    # Dock: autohide, no recents, stable space ordering
    dock.autohide = true;
    dock.show-recents = false;
    dock.mru-spaces = false;
    dock.persistent-apps = [
      "/Applications/Ghostty.app"
      "/Applications/Orion.app"
    ];

  };
}
