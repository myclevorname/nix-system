# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, wallpapers, ... }:

{
  options = {
    users.clevor.sway.enable = lib.mkEnableOption "the Sway configuration clevor likes.";
  };

  config = lib.mkIf config.users.clevor.sway.enable {
    users.users.clevor = {
      extraGroups = [ "video" "audio" ];
    };

    environment.systemPackages = with pkgs; [
      mako
      grim
      slurp
      wofi
    ];

    services.gnome.gnome-keyring.enable = true;

    # Nix suddenly started complaining ever since I updated nixpkgs.
    services.pipewire.enable = lib.mkForce false;

    hardware.graphics.enable = true;
    services.pulseaudio = {
      enable = true;
      support32Bit = true;
    };

    home-manager.users.clevor = let
      background = pkgs.stdenv.mkDerivation {
        name = "macaw.png";
        src = builtins.toString wallpapers + "/backgrounds/macaw.jpg";
        dontUnpack = true;
        nativeBuildInputs = with pkgs; [ ffmpeg ];
        installPhase = ''
          ffmpeg -i $src $out
        '';
      }; in
    {
      home.file = {
        ".sway/config".source = ./sway-config;
        ".sway/background.png".source = background;
      };
      programs.foot = {
        enable = true;
        settings.main.font = "Terminal:size=10.5";
      };
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
