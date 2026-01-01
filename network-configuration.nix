{
  config,
  pkgs,
  configName,
  ...
}:

{
  # fileSystems."/mnt/share" = {
  #   device = "clevor-rpi:/smb/sam";
  #   fsType = "nfs";
  #   options = [
  #     "async"
  #     "vers=4"
  #     "rsize=1048576"
  #     "wsize=1048576"
  #   ];
  #   neededForBoot = false;
  # };

  networking.hosts = {
    "172.16.0.191" = [
      "clevor-laptop-nixos"
      "laptop.local"
      "laptop"
    ];
    "172.16.0.190" = [
      # "clevor-rpi-nixos"
      "clevor-rpi-9front"
      "rpi.local"
      "rpi"
    ];
  };
}
