{
  description = "clevor's Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    nixosConfigurations = {
      "clevor-laptop-nixos" = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = attrs // { configName = "clevor-laptop-nixos"; inputs = attrs; };
        modules = commonConfig;
      };
      "clevor-laptop-nixos-generic" = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = attrs // { configName = "clevor-laptop-nixos-generic"; };
        modules = commonConfig;
      };
    };
    nixosModules = import ./modules;
    packages."x86_64-linux" = {
      nix = nixpkgs'.nixVersions.nix_2_24.overrideAttrs (final: old: {
        patchPhase = (if old ? patchPhase then old.patchPhase else "") + ''
          substituteInPlace src/nix/optimise-store.cc --replace-fail '"optimise"' '"optimize"'
          substituteInPlace src/nix/optimise-store.md --replace-fail 'store optimise' 'store optimize' --replace-fail \
            ')""' 'Note that the original command is `nix store optimise`, but clevor made a patch that changes it to `nix store optimize`.
          
          )""'
        '';
      });
      tilp = nixpkgs'.callPackage (tilp-pkgs + "/pkgs/by-name/ti/tilp/package.nix") { };
      cemu-ti = nixpkgs'.cemu-ti.overrideAttrs {
        meta.broken = false;
      };
    };
  };
}
