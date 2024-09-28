# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, self, ... }:

{
  imports = [
    ./sway.nix
    ./x32.nix
    ./benjamin.nix
  ];

  # Custom module config
  boot.kernel.x32.enable = true;
  boot.kernel.mg-lru.enable = true;
  programs.sway.clevorConfig.enable = true;
  users.benjamin.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "clevor-laptop-nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  # Support the Joycon controllers
  # services.joycond.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.clevor.gid = 1000;

  users.users.clevor = {
    isNormalUser = true;
    description = "Sam Connelly";
    group = "clevor";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "users" ];
  };

  nixpkgs.config.allowUnfree = true;


  environment.systemPackages = with pkgs; [
    vim
  ];

  programs.tmux.enable = true;
  services.openssh.enable = true;

  # Aah remove scary
  # services.printing.enable = true;
  # services.avahi = {
  #   enable = true;
  #   nssmdns4 = true;
  # };

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Risky! Changes `nix store optimise` to `nix store optimize` because I am American.
  nix.package = self.packages.x86_64-linux.nix;

  zramSwap = {
    enable = true;
    memoryPercent = 150;
  };

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Haven't used it in a while
  programs.steam.enable = true;
}
