{
  description = "clevor's Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    llvm-ez80.url = "github:myclevorname/llvm-ez80";
    cemu-ti = {
      url = "https://github.com/CE-Programming/CEmu";
      type = "git";
      submodules = true;
      flake = false;
    };
    wallpapers = {
      url = "github:ParrotSec/parrot-wallpapers";
      flake = false;
    };
  };
  # I will not use flake-utils as I want to reduce the amount of dependencies I have.

  outputs = { self, nixpkgs, llvm-ez80, cemu-ti, wallpapers }@attrs: {
    nixosConfigurations."clevor-laptop-nixos" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        ./network-configuration.nix
        ({ config, pkgs, llvm-ez80, ... }: { environment.systemPackages = [ llvm-ez80.packages.${system}.llvm-ez80 self.packages.${system}.cemu-ti ]; })
      ];
    };
    nixosConfigurations."clevor-laptop-nixos-generic" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./configuration.nix
        ({ config, pkgs, llvm-ez80, ... }: { environment.systemPackages = [ llvm-ez80.packages.${system}.llvm-ez80 self.packages.${system}.cemu-ti ]; })
      ];
    };
    packages."x86_64-linux".cemu-ti = (import nixpkgs { system = "x86_64-linux"; }).pkgs.cemu-ti.overrideAttrs (finalAttrs: oldAttrs: {
      version = "unstable";
      src = cemu-ti;
    });
  };
}
