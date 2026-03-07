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
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      lanzaboote,
      home-manager,
      ...
    }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
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
            home-manager.users.sargunv = import ./home;
          }
        ];
      };
    };
}
