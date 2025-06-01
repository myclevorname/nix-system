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
}
