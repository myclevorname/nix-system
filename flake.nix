{
  description = "clevor's Configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.llvm-ez80.url = "git+file:///etc/nixos/llvm-ez80";

  # I will not use flake-utils as I want to reduce the amount of dependencies I have.

  outputs = { self, nixpkgs, llvm-ez80 }@attrs: {
    nixosConfigurations."clevor-laptop-nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [
        ./configuration.nix
        ({ config, pkgs, llvm-ez80, ... }: { environment.systemPackages = [ llvm-ez80 ]; })
      ];
    };
  };
}
