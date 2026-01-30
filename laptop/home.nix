{
  pkgs,
  self,
  narser,
  ce-programs,
  ...
}:
{
  home.packages = with pkgs; [
    _9pfs
    asunder # trying to rip everything except my pants
    baobab
    bluetuith
    cachix
    ce-programs.legacyPackages.${stdenv.hostPlatform.system}.cemu-ti
    (writeShellScriptBin "rpi-connect" ''
      drawterm -h rpi -p -t 604800
    '')
    drawterm
    # elinks
    # jmtpfs
    prismlauncher
    # (retroarch.overrideAttrs (oldAttrs: {
    #   cores = [ dolphin mgba ];
    # }))
    wf-recorder
  ];

  services.ollama.enable = true;
}
