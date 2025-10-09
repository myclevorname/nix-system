{
  nixpkgs,
  pkgs,
  configName,
  ...
}:
{
  networking.hostName = configName;

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
    extraGroups = [
      "networkmanager"
      "wheel"
      # "libvirtd"
      "users"
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  services.openssh.enable = true;
  programs.tmux.enable = true;

  nix.registry.nixpkgs.flake = nixpkgs;
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
