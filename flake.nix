{
  description = "clevor's Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tilp-pkgs.url = "github:myclevorname/nixpkgs/tilp2";
    wallpapers = {
      url = "github:ParrotSec/parrot-wallpapers";
      flake = false;
    };
  };
  # I will not use flake-utils as I want to reduce the amount of dependencies I have.

  outputs = { self, nixpkgs, wallpapers, home-manager, tilp-pkgs, ... }@attrs:
    let
      nixpkgs' = import nixpkgs { system = "x86_64-linux"; };
      commonConfig = [
        ./common-configuration.nix
        ./choose.nix
        home-manager.nixosModules.home-manager
      ] ++
        (import ./modules).imported;
    in {
    nixosConfigurations = (list: builtins.listToAttrs
      (nixpkgs'.lib.lists.flatten
        (builtins.map
          ({ name, system }:
            let hostname = "clevor-" + name + "-nixos"; in [
            {
              name = hostname;
              value = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = attrs // { configName = hostname; inputs = attrs; };
                modules = commonConfig;
              };
            }
            {
              name = hostname + "-generic";
              value = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = attrs // { configName = hostname + "-generic"; inputs = attrs; };
                modules = commonConfig;
              };
            }
          ])
          list
        )
      )
    ) [
      { name = "laptop"; system = "x86_64-linux"; }
      { name = "rpi"; system = "aarch64-linux"; }
    ];
    nixosModules = import ./modules;
    packages."x86_64-linux" = {
      tilp = nixpkgs'.callPackage (tilp-pkgs + "/pkgs/by-name/ti/tilp/package.nix") { };
      cemu-ti = nixpkgs'.cemu-ti.overrideAttrs {
        meta.broken = false;
      };
    };
  };
}
