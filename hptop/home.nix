{
  pkgs,
  self,
  ce-programs,
  ...
}:
{
  home.packages = with pkgs; [
    baobab
    bluetuith
    cachix
    ce-programs.legacyPackages.${system}.cemu-ti
    jmtpfs
    ce-programs.legacyPackages.${system}.tilp2
    wf-recorder
  ];
}
