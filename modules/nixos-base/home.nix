# Home-manager wiring: receives flake inputs via NixOS specialArgs and
# forwards them to home-manager.
{
  nixvim,
  gitignore,
  vscode-extensions,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  home-manager.sharedModules = [ nixvim.homeModules.nixvim ];
  home-manager.extraSpecialArgs = { inherit gitignore vscode-extensions; };
  home-manager.users.sargunv.imports = [ ../../home ];
}
