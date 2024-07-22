# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "hid-nintendo" ];
  boot.extraModulePackages = [ ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/841cf718-7f18-49fb-96d3-8f0165f3fdb3";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-72090c27-a2cf-4655-876a-de5cee69644e".device = "/dev/disk/by-uuid/72090c27-a2cf-4655-876a-de5cee69644e";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8022-283B";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  fileSystems."/mnt/steam" = {
    device = "/dev/disk/by-uuid/c40f046e-fa91-4b8a-b7f8-1f844dc1b800";
    fsType = "ext4";
    neededForBoot = false;
  };

  fileSystems."/var/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "size=8G" ];
  };

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "300%";
    cleanOnBoot = true;
  };

  swapDevices = [ { device = "/dev/sda9"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
