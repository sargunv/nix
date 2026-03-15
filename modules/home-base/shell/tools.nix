{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ncdu
    dust
    duf
  ];

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
    globalConfig.settings = {
      trusted_config_paths = [ "~/Code" ];
      node.compile = false;
      python.compile = false;
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
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
