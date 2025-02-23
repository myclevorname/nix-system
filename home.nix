{ pkgs, self, ... }:
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
    cachix
    self.packages.${system}.cemu-ti
    ciscoPacketTracer8 # https://lms.netacad.com/mod/page/view.php?id=85083644
#    dolphin-emu
    elinks
    file
    firefox
    (writeShellScriptBin "flush-swap" ''
      swapoff -a; systemctl restart swap.target
    '')
    gh
    git
    htop
    jmtpfs
    man-pages
    man-pages-posix
    moreutils
    nix-output-monitor
    nvtopPackages.intel
    obsidian
#    (retroarch.overrideAttrs (oldAttrs: {
#      cores = [ dolphin mgba ];
#    }))
    prismlauncher
    ripgrep
    self.packages.${system}.tilp
    unzip
    vim
    wf-recorder
    wget
    zip
  ];

  # Just testing
  services.ollama.enable = true;
  home.stateVersion = "24.11";
}
