# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  users.users.bpf = {
    isNormalUser = true;
    description = "Benjamin Connelly";
    extraGroups = [ "libvirtd" "users" ];
    packages = with pkgs; [];
  };
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.plasma6.enableQt5Integration = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.autoNumlock = true;
  services.displayManager.sddm.wayland.enable = true;
}
