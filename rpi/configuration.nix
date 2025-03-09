{ config, lib, pkgs, ... }:

{
  networking.networkmanager = {
    enable = true;
    wifi.powersave = false;
  };
  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
  ];

  # services.nfs.server = {
  #   enable = true;
  #   exports = ''
  #     /mnt/smb/clevor 171.16.0.191(rw,async)
  #   '';
  # };



  services.hardware.argonone.enable = true;

  networking.firewall.enable = false;

  system.stateVersion = "24.11";
}
