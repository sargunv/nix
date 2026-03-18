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

    # Finder: show extensions, pathbar, and status bar
    NSGlobalDomain.AppleShowAllExtensions = true;
    finder.ShowPathbar = true;
    finder.ShowStatusBar = true;

    # Dock: autohide, no recents, stable space ordering
    dock.autohide = true;
    dock.show-recents = false;
    dock.mru-spaces = false;
    dock.persistent-apps = [
      "/Users/sargunv/Applications/Home Manager Apps/Ghostty.app"
      "/Applications/Vivaldi.app"
    ];

    CustomUserPreferences."com.jordanbaird.Ice" = {
      ItemSpacingOffset = "-16";
      SUAutomaticallyUpdate = false;
      SUEnableAutomaticChecks = false;
      SUHasLaunchedBefore = true;
    };

    CustomUserPreferences."com.setapp.DesktopClient" = {
      # System presence
      ShouldLoadFinderSyncExtensionOnLaunch = false;

      # App behavior
      LaunchAppAfterInstall = false;
      shouldDisableRateRecentAppWindow = true;
      shouldDisableFeedbackWindow = true;

      # Notifications
      shouldBlockNewAppsNotifications = true;
      shouldBlockSpecialOffersNotifications = true;
      shouldBlockSuccessfulAppUpdatesNotifications = true;
      shouldDisableNotificationBadgeInDockTile = false;

      # Updates
      SUAutomaticallyUpdate = false;
      SUEnableAutomaticChecks = false;
    };

    CustomUserPreferences."com.getcleanshot.app-setapp" = {
      transparentWindowBackground = true;
    };

    CustomUserPreferences."com.mitchellh.ghostty" = {
      SUEnableAutomaticChecks = false;
      SUHasLaunchedBefore = true;
    };
  };
}
