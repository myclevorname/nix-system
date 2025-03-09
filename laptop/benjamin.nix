# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, benjamin, lib, ... }:

{
  options = {
    users.benjamin.enable = lib.mkEnableOption "the specialization for the user Benjamin.";
  };

  config = lib.mkIf config.users.benjamin.enable {
    specialisation."benjamin".configuration = {
      users.users.bpf = {
        isNormalUser = true;
        description = "Benjamin Connelly";
        extraGroups = [ "libvirtd" "users" ];
        packages = with pkgs; [ openjdk23 ];
      };

      services = {
        desktopManager = {
          plasma6.enable = true;
          plasma6.enableQt5Integration = true;
        };
        displayManager.sddm = {
          enable = true;
          autoNumlock = true;
          wayland.enable = true;
        };
      };
    };
  };
}
