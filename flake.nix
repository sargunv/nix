{
  description = "system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gitignore = {
      url = "github:github/gitignore";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      lanzaboote,
      home-manager,
      nix-vscode-extensions,
      nixvim,
      gitignore,
      ...
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      vscode-extensions = nix-vscode-extensions.extensions.x86_64-linux;
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [
          nil
          nixd
          just
        ];
      };

      nixosConfigurations.framework-desktop = nixpkgs.lib.nixosSystem {
        modules = [
          lanzaboote.nixosModules.lanzaboote
          nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
          ./hosts/framework-desktop
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.sharedModules = [ nixvim.homeModules.nixvim ];
            home-manager.extraSpecialArgs = { inherit gitignore vscode-extensions; };
            home-manager.users.sargunv = import ./home;
          }
        ];
      };
    };
}
