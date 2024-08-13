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

#  networking.hosts = {
#    "172.16.0.126" = [ "clevor-rpi.local" "clevor-rpi" "rpi" "rpi.local" ];
#  };
}
