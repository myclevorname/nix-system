{
  description = "clevor's Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    my-pkgs = {
      url = "github:myclevorname/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tilp-pkgs.url = "github:NixOS/nixpkgs/21.11";
    wallpapers = {
      url = "github:ParrotSec/parrot-wallpapers";
      flake = false;
    };
  };
  # I will not use flake-utils as I want to reduce the amount of dependencies I have.

  outputs = { self, nixpkgs, my-pkgs, wallpapers, tilp-pkgs, home-manager }@attrs:
    let
      nixpkgs' = import nixpkgs { system = "x86_64-linux"; };
      commonConfig = [
        ./configuration.nix
        self.nixosModules.mg-lru
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension = "hm.bak";
            extraSpecialArgs = attrs;
            useGlobalPkgs = true;
            useUserPackages = true;
            users.clevor = import ./home.nix;
          };
        }
      ];
    in {
    nixosConfigurations."clevor-laptop-nixos" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./hardware-configuration.nix
        ./network-configuration.nix
      ] ++ commonConfig;
    };
    nixosModules.mg-lru = import ./modules/mg-lru.nix;

    nixosConfigurations."clevor-laptop-nixos-generic" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = commonConfig;
    };
    packages."x86_64-linux" = {
      nix = nixpkgs'.pkgs.nixVersions.nix_2_24.overrideAttrs (final: old: {
        patchPhase = (if old ? patchPhase then old.patchPhase else "") + ''
          substituteInPlace src/nix/optimise-store.cc --replace-fail '"optimise"' '"optimize"'
          substituteInPlace src/nix/optimise-store.md --replace-fail 'store optimise' 'store optimize' --replace-fail \
            ')""' 'Note that the original command is `nix store optimise`, but clevor made a patch that changes it to `nix store optimize`.
          
          )""'
        '';
      });
    };
  };
}
