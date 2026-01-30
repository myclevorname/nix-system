{
  config,
  lib,
  configName,
  inputs,
  ...
}:
let
  configs = [
    "laptop"
    # "rpi"
    "hptop"
    "hp2top"
  ];
  inherit (lib.strings) hasInfix;
  inherit (lib.lists) findFirst;
  inherit (lib.trivial) throwIf;
  flip =
    x: y: z:
    x z y;
  pickConfig =
    hostname:
    let
      name = findFirst (flip hasInfix hostname) null configs;
    in
    throwIf (name == null) "Hostname ${configName} does not correspond to a valid host." name;
  path = ./. + "/${pickConfig configName}";
in
{
  imports = [
    (path + "/hardware-configuration.nix")
    ./network-configuration.nix
    ./secrets.nix
    (path + "/configuration.nix")
  ];

  home-manager = {
    backupFileExtension = "hm.bak";
    extraSpecialArgs = inputs;
    useGlobalPkgs = true;
    useUserPackages = true;
    users.clevor = {
      imports = [
        (path + "/home.nix")
        ./common-home.nix
      ];

    };
  };
}
