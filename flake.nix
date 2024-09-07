{
  description = "clevor's Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    my-pkgs = {
      url = "github:myclevorname/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tilp-pkgs.url = "github:NixOS/nixpkgs/21.11";
    wallpapers = {
      url = "github:ParrotSec/parrot-wallpapers";
      flake = false;
    };
    spasm.url = "github:myclevorname/nixpkgs/spasm-ng";
  };
  # I will not use flake-utils as I want to reduce the amount of dependencies I have.

  outputs = { self, nixpkgs, my-pkgs, wallpapers, tilp-pkgs, spasm }@attrs:
    let nixpkgs' = import nixpkgs { system = "x86_64-linux"; }; in {
    nixosConfigurations."clevor-laptop-nixos" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        ./network-configuration.nix
        self.nixosModules.mg-lru
      ];
    };
    nixosModules.mg-lru = { config, lib, ... }: {
      options = {
        boot.kernel.mg-lru = {
          enable = lib.mkEnableOption "the multi-gen LRU to improve performance under memory pressure";
          leafPageTables = lib.mkOption {
            default = true;
            type = lib.types.bool;
            description = ''
              Whether to allow the multi-gen LRU to clear the accessed bit in leaf page table
              entries in large batches.
              Enabling it may theoretically worsen lock contention, but disabling it will
              incur a minor performance penalty for the multi-gen LRU. Only disable if there
              are unforeseen side effects.
            '';
          };
          nonLeafPageTables = lib.mkOption {
            default = true;
            type = lib.types.bool;
            description = ''
              Whether to allow the multi-gen LRU to clear the accessed bit in non-leaf page
              table entries.
              Disabling it will incur a minor performance penalty for the multi-gen LRU. Only
              disable if there are unforeseen side effects.
            '';
          };
        };
      };
      config = lib.mkIf config.boot.kernel.mg-lru.enable {
          boot.kernelParams = with config.boot.kernel.mg-lru;
            let
              enabled = if enable then 1 else 0;
              leaf = if leafPageTables then 2 else 0;
              nonLeaf = if nonLeafPageTables then 4 else 0;
            in [ "CONFIG_LRU_GEN=y" "CONFIG_LRU_GEN_ENABLED=${builtins.toString (enabled+leaf+nonLeaf)}" ];
        };
    };

    nixosConfigurations."clevor-laptop-nixos-generic" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./configuration.nix
        self.nixosModules.mg-lru
      ];
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
