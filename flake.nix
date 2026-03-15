{
  description = "system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    try-cli = {
      url = "github:tobi/try-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gruvbox-wallpaper = {
      url = "https://raw.githubusercontent.com/AngelJumbo/gruvbox-wallpapers/refs/heads/main/wallpapers/vector%20graphics/cosy-retreat-sunset.png";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      nix-darwin,
      lanzaboote,
      home-manager,
      nix-vscode-extensions,
      nixvim,
      gitignore,
      stylix,
      try-cli,
      gruvbox-wallpaper,
      ...
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    in
    {
      devShells = forAllSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            nil
            nixd
            just
          ];
        };
      });

      nixosConfigurations.framework-desktop =
        let
          system = "x86_64-linux";
          pkgs = nixpkgs.legacyPackages.${system};
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit gitignore nixvim gruvbox-wallpaper;
            vscode-extensions = nix-vscode-extensions.extensions.${system};
            zed-package = pkgs.zed-editor;
            try-cli-package = try-cli.packages.${system}.default;
          };
          modules = [
            lanzaboote.nixosModules.lanzaboote
            nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            ./hosts/framework-desktop
          ];
        };

      darwinConfigurations.Sarguns-MacBook-Pro =
        let
          system = "aarch64-darwin";
          pkgs = nixpkgs.legacyPackages.${system};
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit gitignore nixvim gruvbox-wallpaper;
            vscode-extensions = nix-vscode-extensions.extensions.${system};
            zed-package = pkgs.zed-editor;
            try-cli-package = try-cli.packages.${system}.default;
          };
          modules = [
            stylix.darwinModules.stylix
            home-manager.darwinModules.home-manager
            ./hosts/Sarguns-MacBook-Pro
          ];
        };
    };
}
