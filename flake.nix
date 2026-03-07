{
  description = "system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote.url = "github:nix-community/lanzaboote/v1.0.0";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, lanzaboote, home-manager, ... }@inputs: {
    nixosConfigurations.framework-desktop = nixpkgs.lib.nixosSystem {
      modules = [
        lanzaboote.nixosModules.lanzaboote
        nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
        ./hosts/framework-desktop/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.sargunv = import ./home/home.nix;
        }
      ];
    };
  };
}
