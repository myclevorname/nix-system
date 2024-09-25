{ pkgs, my-pkgs, tilp-pkgs, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    initExtra = ''
      export PS1="\\[\\033[1;32m\\][\\[\\e]0;\\u@\\h: \\w\\a\\]\\u@\\h:\\w]\$\\[\\033[0m\\] ";
    '';
  };

  home.packages = with pkgs; [
    baobab
    bluetuith
    cabal-install
    my-pkgs.packages.${system}.ce-toolchain
    cargo
    (cemu-ti.overrideAttrs {
      dontWrapQtApps = true;
      fixupPhase = ''
        runHook preFixup
        wrapQtApp $out/bin/CEmu --add-flags "--platform xcb"
        runHook postFixup
      '';
    })
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
    rustc
    spasm-ng
    tilem
    tilp-pkgs.legacyPackages.${system}.tilp2
    vim
    vlc
    wf-recorder
    wget
  ];

  home.stateVersion = "24.11";
}
