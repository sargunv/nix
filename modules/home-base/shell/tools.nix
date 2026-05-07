{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ncdu
    dust
    duf
  ];

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings.enter_accept = false;
  };

  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  xdg.configFile."mise/config.toml".text = ''
    [settings]
    trusted_config_paths = ["~/Code"]

    [settings.node]
    compile = false
    corepack = true

    [settings.python]
    compile = false

    [tools]
    "core:java" = "temurin-25"
    "core:node" = "lts"
    "core:python" = "latest"

    "aqua:astral-sh/uv" = "latest"
    "aqua:anomalyco/opencode" = "latest"
    "aqua:anthropics/claude-code" = "latest"
    "aqua:charmbracelet/crush" = "latest"
    "aqua:openai/codex" = "latest"

    "github:badlogic/pi-mono" = "latest"

    "npm:@google/gemini-cli" = "latest"
    "npm:droid" = "latest"
  '';

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    icons = "auto";
    git = true;
  };
}
