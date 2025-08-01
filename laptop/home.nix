{
  pkgs,
  self,
  narser,
  ce-programs,
  ...
}:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    initExtra = ''
      export PS1="\\[\\033[1;32m\\][\\[\\e]0;\\u@\\h: \\w\\a\\]\\u@\\h:\\w]\$\\[\\033[0m\\] ";
      export PATH=$PATH:/home/clevor/zig/bin
    '';
  };

  # programs.vesktop.enable = true;

  home.packages = with pkgs; [
    baobab
    bluetuith
    cachix
    self.packages.${system}.cemu-ti
    # dolphin-emu
    # (stdenv.mkDerivation {
    #   name = "edmentum";
    #   src = ../edmentum;
    #   dontUnpack = true;
    #   installPhase = ''
    #     mkdir -p $out/bin
    #     cp $src $out/bin/edmentum
    #     chmod +x $out/bin/edmentum
    #   '';
    #   buildInputs = [ python3 ];
    # })
    # elinks
    file
    (writeShellScriptBin "flush-swap" ''
      swapoff -a; systemctl restart swap.target
    '')
    gh
    git
    htop
    jmtpfs
    libqalculate
    librewolf
    man-pages
    man-pages-posix
    moreutils
    narser.packages.${system}.default
    nix-output-monitor
    # nvtopPackages.intel
    # obsidian
    # (retroarch.overrideAttrs (oldAttrs: {
    #   cores = [ dolphin mgba ];
    # }))
    prismlauncher
    ripgrep
    ce-programs.legacyPackages.${system}.tilp2
    unicode-paracode
    unzip
    vim
    wf-recorder
    wget
    zip
  ];

  services.ollama.enable = true;

  home.stateVersion = "24.11";
}
