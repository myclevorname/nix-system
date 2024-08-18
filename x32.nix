{ lib, config, ... }:
{
  options = {
    boot.kernel.x32.enable = lib.mkEnableOption ''
      the x32 subarchtecture for x86_64-linux.
      Enabling it may expose security volnerabilities.
    '';
  };

  config = lib.mkIf config.boot.kernel.x32.enable {
    boot.kernelPatches = [{
      name = "add-x32-support";
      patch = null;
      extraConfig = ''
        X86_X32_ABI y
      '';
    }];
  };
}
