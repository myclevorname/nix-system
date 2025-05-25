{ config, pkgs, configName, ... }:

{
#  fileSystems."/mnt/share" = {
#    device = "clevor-rpi:/smb/sam";
#    fsType = "nfs";
#    options = [
#      "async"
#      "vers=4"
#      "rsize=1048576"
#      "wsize=1048576"
#    ];
#    neededForBoot = false;
#  };

  networking.hosts = {
    "172.16.0.191" = [ "clevor-laptop-nixos" "laptop.local" "laptop" ];
    # "172.16.0.121" = [ "clevor-rpi-nixos" "rpi.local" "rpi" ];
    "172.16.0.158" = [ "clevor-hptop-nixos" "hptop.local" "hptop" ];
  };

  nix.buildMachines =
    let
      laptop = 20;
      rpi = 10;
      hptop = 1;
      this = if configName == "clevor-laptop-nixos" then laptop
        else if configName == "clevor-hptop-nixos"  then hptop
        else if configName == "clevor-rpi-nixos"    then rpi
        else throw "Unknown machine speed";
    in [
      {
        hostName = "clevor-hptop-nixos";
        system = "x86_64-linux";
        protocol = "ssh-ng";
        maxJobs = 2;
        speedFactor = hptop / this;
        supportedFeatures = [ "benchmark" "big-parallel" "kvm" "nixos-test"];
      }
      {
        hostName = "clevor-laptop-nixos";
        system = "x86_64-linux";
        protocol = "ssh-ng";
        maxJobs = 4;
        speedFactor = laptop / this;
        supportedFeatures = [ "benchmark" "big-parallel" "kvm" "nixos-test" ];
      }
  ];
  nix.distributedBuilds = configName == "clevor-hptop-nixos";
  nix.settings.builders-use-substitutes = configName == "clevor-hptop-nixos";
}
