# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ];

  # Custom module config
  # boot.kernel.x32.enable = true; # I don't rely on it
  boot.kernel.mg-lru.enable = true;
  users.clevor.sway.enable = true;
  users.clevor.sway.extraDimming = true;

  # This is pretty much a copy of hptop/configuration.nix
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  # boot.loader.grub.useOSProber = true;
  boot.loader.grub.enableCryptodisk = true;

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 150;
  };
  system.stateVersion = "24.11"; # Did you read the comment?
}
