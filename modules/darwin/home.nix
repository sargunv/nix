# Home-manager wiring: receives flake inputs via darwin specialArgs and
# forwards them to home-manager.
{
  nixvim,
  gitignore,
  vscode-extensions,
  zed-package,
  try-cli-package,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  home-manager.sharedModules = [ nixvim.homeModules.nixvim ];
  home-manager.extraSpecialArgs = {
    inherit
      gitignore
      vscode-extensions
      zed-package
      try-cli-package
      ;
  };
  home-manager.users.sargunv.imports = [ ../home-base ];
}
