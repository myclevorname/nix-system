{
  description = "clevor's Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ce-programs.url = "github:myclevorname/nix-calculators";
    wallpapers = {
      url = "github:ParrotSec/parrot-wallpapers";
      flake = false;
    };
    wl-gammarelay = {
      url = "github:jeremija/wl-gammarelay";
      flake = false;
    };
    narser.url = "git+https://codeberg.org/clevor/narser";
  };
  # I will not use flake-utils as I want to reduce the amount of dependencies I have.

  outputs =
    {
      self,
      nixpkgs,
      wallpapers,
      home-manager,
      ...
    }@attrs:
    let
      system = "x86_64-linux";
      nixpkgs' = nixpkgs.legacyPackages.${system};
      commonConfig = [
        ./common-configuration.nix
        ./choose.nix
        home-manager.nixosModules.home-manager
      ]
      ++ (import ./modules).imported;
    in
    {
      nixosConfigurations =
        (
          list:
          builtins.listToAttrs (
            nixpkgs'.lib.lists.flatten (
              builtins.map (
                { name, system }:
                let
                  hostname = "clevor-" + name + "-nixos";
                in
                [
                  {
                    name = hostname;
                    value = nixpkgs.lib.nixosSystem {
                      inherit system;
                      specialArgs = attrs // {
                        configName = hostname;
                        inputs = attrs;
                      };
                      modules = commonConfig;
                    };
                  }
                  {
                    name = hostname + "-generic";
                    value = nixpkgs.lib.nixosSystem {
                      inherit system;
                      specialArgs = attrs // {
                        configName = hostname + "-generic";
                        inputs = attrs;
                      };
                      modules = commonConfig;
                    };
                  }
                ]
              ) list
            )
          )
        )
          [
            {
              name = "laptop";
              system = "x86_64-linux";
            }
            {
              name = "hptop";
              system = "x86_64-linux";
            }
            {
              name = "hp2top";
              system = "x86_64-linux";
            }
            {
              name = "rpi";
              system = "aarch64-linux";
            }
          ];
      nixosModules = import ./modules;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
      packages.x86_64-linux = {
        cemu-ti = nixpkgs'.cemu-ti.overrideAttrs {
          meta.broken = false;
        };
        wl-gammarelay = nixpkgs'.buildGoModule {
          name = "wl-gammarelay";
          src = attrs.wl-gammarelay;
          vendorHash = "sha256-yJ6AuL0cmU+rMQNv3lmHQQSVipUZAUFxsLvthIsoS+s=";
          preBuild = ''
            make -C protocol
          '';
          nativeBuildInputs = with nixpkgs'; [ wayland-scanner ];
          buildInputs = with nixpkgs'; [ wayland ];
        };
      };
    };
}
