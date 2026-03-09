# Shell configuration: zsh, starship prompt, and shell integrations.
{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    plugins = [
      {
        name = "zsh-autopair";
        src = pkgs.zsh-autopair;
        file = "share/zsh/zsh-autopair/autopair.zsh";
      }
      {
        name = "zsh-shift-select";
        src = pkgs.fetchFromGitHub {
          owner = "jirutka";
          repo = "zsh-shift-select";
          rev = "da460999b7d31aef0f0a82a3e749d70edf6f2ef9";
          hash = "sha256-ekA8acUgNT/t2SjSBGJs2Oko5EB7MvVUccC6uuTI/vc=";
        };
      }
      {
        name = "zpm-clipboard";
        src = pkgs.fetchFromGitHub {
          owner = "zpm-zsh";
          repo = "clipboard";
          rev = "c3a4a054cefe313d853dc9c32debb1b18aa7513c";
          hash = "sha256-XtS5HQ2HFYBoBZikuI82XT4MDcXsaPJioI7zNyBoIhs=";
        };
        file = "clipboard.plugin.zsh";
      }
    ];
    initContent = ''
      # Ctrl+Left/Right for word navigation
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
      # Alt+Left/Right for word navigation
      bindkey '^[[1;3D' backward-word
      bindkey '^[[1;3C' forward-word
      # Ctrl+Home/End for beginning/end of line
      bindkey '^[[1;5H' beginning-of-line
      bindkey '^[[1;5F' end-of-line
    '';
    shellAliases = {
      # ugrep shortcuts
      uq = "ug -Q";
      uz = "ug -z";
      ux = "ug -U --hexdump";
      ugit = "ug -R --ignore-files";
      # replace grep variants
      grep = "ug -G";
      egrep = "ug -E";
      fgrep = "ug -F";
      zgrep = "ug -zG";
      zegrep = "ug -zE";
      zfgrep = "ug -zF";
      # utilities
      open = "xdg-open";
      xdump = "ugrep -X \"\"";
      zmore = "ugrep+ -z -I -+ --pager \"\"";
    };
    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };
  };

  programs.starship = {
    enable = true;
    presets = [ "pure-preset" ];
    settings = {
      time = {
        disabled = false;
        style = "dimmed";
      };
      directory.truncate_to_repo = false;
      right_format = "$time";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings.enter_accept = false;
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    globalConfig.settings.trusted_config_paths = [ "~/Code" ];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };
}
