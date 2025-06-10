# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, nixpkgs, self, configName, ... }:

{
  imports = [
    ./benjamin.nix
  ];

  # Custom module config
  boot.kernel.x32.enable = true; # I don't rely on it
  boot.kernel.mg-lru.enable = true;
  users.clevor.sway.enable = true;
  users.benjamin.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  # Support the Joycon controllers
  # services.joycond.enable = true;

  programs.gnupg.agent.enable = true;

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  zramSwap = {
    enable = true;
    memoryPercent = 150;
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  services.open-webui.enable = true;

  # Haven't used it in a while
  # programs.steam.enable = true;
}
