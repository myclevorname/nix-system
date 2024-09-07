# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, wallpapers, ... }:

{
  options = {
    programs.sway.clevorConfig.enable = lib.mkEnableOption "the Sway configuration clevor likes.";
  };

  config = lib.mkIf config.programs.sway.clevorConfig.enable {
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

    # Nix suddenly started complaining ever since I updated nixpkgs.
    services.pipewire.enable = lib.mkForce false;

    hardware.graphics.enable = true;
    hardware.pulseaudio = {
      enable = true;
      support32Bit = true;
    };

    environment.etc = let
      background = derivation {
        name = "macaw.png";
        system = "x86_64-linux";
        builder = ./build-wallpaper.sh;
        args = [ "${pkgs.ffmpeg}/bin/ffmpeg" "${wallpapers}/backgrounds/macaw.jpg" ];
      };
    in {
      "sway/config".source = lib.mkForce ./sway-config;
      "sway/background.png".source = background;
      "xdg/foot/foot.ini".source = ./foot.ini;
    };

    programs = {
      sway = {
        enable = true;
        wrapperFeatures.gtk = true;
      };
      light.enable = true;
    };
  };
}
