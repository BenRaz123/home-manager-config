{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      flake-utils,
      ...
    }:
    { homeModules.ben = ./home.nix; }// flake-utils.lib.eachDefaultSystem (system: {
      homeConfigurations.ben = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home.nix ];
      };

    });
}
