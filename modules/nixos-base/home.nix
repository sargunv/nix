# Home-manager wiring: receives flake inputs via NixOS specialArgs and
# forwards them to home-manager.
{
  nixvim,
  gitignore,
  try-cli-package,
  nix-index-database,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  home-manager.sharedModules = [
    nixvim.homeModules.nixvim
    nix-index-database.homeModules.nix-index
  ];
  home-manager.extraSpecialArgs = {
    inherit
      gitignore
      try-cli-package
      ;
  };
  home-manager.users.sargunv.imports = [ ../home-base ];
}
