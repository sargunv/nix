{
  description = "system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lanzaboote.url = "github:nix-community/lanzaboote/v1.0.0";
  };

  outputs = { self, nixpkgs, nixos-hardware, lanzaboote, ... }@inputs: {
    nixosConfigurations.framework-desktop = nixpkgs.lib.nixosSystem {
      modules = [
        lanzaboote.nixosModules.lanzaboote
        nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
        ./hosts/framework-desktop/configuration.nix
      ];
    };
  };
}
