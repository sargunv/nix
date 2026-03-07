{ config, pkgs, ... }:

{
  home.username = "sargunv";
  home.homeDirectory = "/home/sargunv";

  home.packages = with pkgs; [
    fastfetch
    helix
    zed
    proton-pass
    vivaldi
    claude-code
    mise
    vscodium
    ripgrep
    fd
    eza
    zoxide
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Sargun Vohra";
        email = "sargunv@users.noreply.github.com";
      };
    };
  };

  programs.starship = {
    enable = true;
    settings = {
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";
}
