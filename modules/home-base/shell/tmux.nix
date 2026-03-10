# Tmux terminal multiplexer.
{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    terminal = "tmux-256color";
    keyMode = "vi";
    clock24 = true;
    focusEvents = true;
    aggressiveResize = true;
    disableConfirmationPrompt = true;
    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
    ];
  };
}
