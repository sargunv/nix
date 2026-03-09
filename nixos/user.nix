# User account and login shell.
{
  config,
  lib,
  pkgs,
  ...
}:

{
  users.users.sargunv = {
    isNormalUser = true;
    description = "Sargun Vohra";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
    ]
    ++ lib.optionals (!config.local.headless) [ "i2c" ];
  };

  programs.zsh.enable = true;
}
