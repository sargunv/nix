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
    globalConfig.settings = {
      trusted_config_paths = [ "~/Code" ];
      node.compile = false;
      python.compile = false;
    };
  };

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };

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
