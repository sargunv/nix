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
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gruvbox-wallpapers.url = "github:AngelJumbo/gruvbox-wallpapers";
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
      stylix,
      gruvbox-wallpapers,
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
        specialArgs = { inherit gruvbox-wallpapers; };
        modules = [
          lanzaboote.nixosModules.lanzaboote
          nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
          ./hosts/framework-desktop
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.sharedModules = [ nixvim.homeModules.nixvim ];
            home-manager.extraSpecialArgs = {
              inherit gitignore vscode-extensions;
              hostDesktop = {
                monitors = [
                  "desc:ASUSTek COMPUTER INC PG27UCDM TALMAV003641, 3840x2160@120, 0x525, 1.666667, bitdepth, 10"
                  "desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27U 23323B000942, 3840x2160@120, 2304x0, 1.666667, transform, 1, bitdepth, 10"
                ];
                workspaces = [
                  "1, monitor:desc:ASUSTek COMPUTER INC PG27UCDM TALMAV003641, default:true"
                  "2, monitor:desc:GIGA-BYTE TECHNOLOGY CO. LTD. M27U 23323B000942, default:true"
                ];
                xwaylandDpi = 160;
              };
            };
            home-manager.users.sargunv = {
              imports = [
                ./home
                ./home/desktop
              ];
            };
          }
        ];
      };
    };
}
