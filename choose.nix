{ config, lib, configName, inputs, ... }:
let
  configs = [ "laptop" "rpi" "hptop" ];
  inherit (lib.strings) hasInfix hasSuffix;
  inherit (lib.lists) findFirst;
  inherit (lib.trivial) throwIf;
  flip = x: y: z: x z y;
  pickConfig = hostname:
    let
      name = findFirst (flip hasInfix hostname) null configs;
    in
      throwIf (name == null) "Hostname ${configName} does not correspond to a valid host." name;
  isGeneric = hasSuffix "generic";
  path = ./. + "/${pickConfig configName}";
in {
  imports = 
    (if !isGeneric configName
      then [ (path + "/hardware-configuration.nix") ./network-configuration.nix ]
      else []
    ) ++ [ (path + "/configuration.nix") ];
  home-manager = {
    backupFileExtension = "hm.bak";
    extraSpecialArgs = inputs;
    useGlobalPkgs = true;
    useUserPackages = true;
    users.clevor = import (path + "/home.nix");
  };
}
