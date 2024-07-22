{ pkgs, lib, config, ... }:
{
  boot.kernelPatches = [{
    name = "add-x32-support";
    patch = null;
    extraConfig = ''
      X86_X32_ABI y
    '';
  }];
}
