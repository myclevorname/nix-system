# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, llvm-ez80, tilp-pkgs, self, spasm, ... }:

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
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Support the Joycon controllers
#  services.joycond.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
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

  # Configure keymap in X11
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
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    baobab
    bluetuith
    cabal-install
    cemu-ti
    dolphin-emu
    elinks
    firefox
    (writeShellScriptBin "flush-swap" ''
      swapoff -a; systemctl restart swap.target
    '')
    gh
    ghc
    git
    gnumake
    haskellPackages.hoogle
    htop
    jmtpfs
    man-pages
    man-pages-posix
    metadata
    moreutils
    nasm
    nix-output-monitor
    nvtopPackages.intel
    (retroarch.overrideAttrs (oldAttrs: {
      cores = [ dolphin mgba ];
    }))
    prismlauncher
    spasm.legacyPackages.x86_64-linux.spasm-ng
    vim
    vlc
    wf-recorder
    wget
    llvm-ez80.packages.${system}.default
    tilp-pkgs.legacyPackages.${system}.tilp2
  ];

  programs.tmux.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "unstable"; # Did you read the comment?

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
  # programs.steam.enable = true;

  # Not allowed to use joycons
  # services.joycond.enable = true;
}
