{
  config,
  pkgs,
  try-cli-package,
  ...
}:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    profileExtra = ''
      if [[ -f "$ZDOTDIR/.zprofile.local" ]]; then
        source "$ZDOTDIR/.zprofile.local"
      fi
    '';
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

      # try-cli ephemeral workspace manager
      eval "$(${try-cli-package}/bin/try init ~/Code/tries)"
    '';
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
}
