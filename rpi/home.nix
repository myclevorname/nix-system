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
    elinks
    file
    (writeShellScriptBin "flush-swap" ''
      swapoff -a; systemctl restart swap.target
    '')
    gh
    git
    htop
    man-pages
    man-pages-posix
    moreutils
    nix-output-monitor
    ripgrep
    unzip
    vim
    wget
    zip
  ];

  home.stateVersion = "24.11";
}
