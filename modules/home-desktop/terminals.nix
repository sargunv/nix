# Terminal emulators: kitty on Linux, ghostty (cask) on macOS.
{
  config,
  pkgs,
  lib,
  ...
}:

{
  stylix.opacity.terminal = 0.85;

  programs.kitty = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;
    package = pkgs.kitty;
    settings = {
      window_padding_width = 8;
      active_tab_font_style = "bold";
      allow_remote_control = "socket-only";
      listen_on = "unix:@kitty";
    };
    # Stylix themes kitty via the deprecated upstream tinted-kitty template,
    # which maps color8 (ANSI bright black) to base02. base02 is the selection
    # background — against base00 the contrast is ~1.3:1 and dim text becomes
    # unreadable (most visibly: zsh-autosuggestions, which uses fg=8).
    # Stylix's other terminal targets (ghostty, alacritty, wezterm, foot) all
    # use base03 here, matching the chriskempson base16 styling spec. Override
    # color8 with mkAfter so it lands after stylix's include directive.
    # Tracked upstream: https://github.com/nix-community/stylix/issues/1411
    extraConfig = lib.mkAfter ''
      color8 #${config.lib.stylix.colors.base03}

      # Disable Monaspace texture healing; it changes glyph shapes contextually
      # and makes pairs like "Sw" look uneven in terminal cells.
      font_features MonaspiceArNF-Regular -calt
      font_features MonaspiceArNF-Bold -calt
      font_features MonaspiceArNF-Italic -calt
      font_features MonaspiceArNF-BoldItalic -calt
    '';
  };

  programs.ghostty = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    package = null;
    settings.macos-window-shadow = false;
    settings.background-blur = "macos-glass-regular";
  };
}
