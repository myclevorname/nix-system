# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  users.users.clevor = {
    extraGroups = [ "video" "audio" ];
  };

  environment.systemPackages = with pkgs; [
    mako
    foot
    grim
    slurp
    wofi
  ];

  services.gnome.gnome-keyring.enable = true;

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    light.enable = true;
  };
}
