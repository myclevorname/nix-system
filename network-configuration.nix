{ config, pkgs, ... }:

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
    "172.16.0.131" = [ "clevor-laptop-nixos" "laptop.local" ];
    "172.16.0.121" = [ "clevor-rpi-nixos" "rpi.local" ];
  };
}
