{ config, lib, ... }:
{
  options = {
    boot.kernel.mg-lru = {
      enable = lib.mkEnableOption "the multi-gen LRU to improve performance under memory pressure";
      leafPageTables = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = ''
          Whether to allow the multi-gen LRU to clear the accessed bit in leaf page table
          entries in large batches.
          Enabling it may theoretically worsen lock contention, but disabling it will
          incur a minor performance penalty for the multi-gen LRU. Only disable if there
          are unforeseen side effects.
        '';
      };
      nonLeafPageTables = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = ''
          Whether to allow the multi-gen LRU to clear the accessed bit in non-leaf page
          table entries.
          Disabling it will incur a minor performance penalty for the multi-gen LRU. Only
          disable if there are unforeseen side effects.
        '';
      };
    };
  };
  config = lib.mkIf config.boot.kernel.mg-lru.enable {
    boot.kernelParams =
      with config.boot.kernel.mg-lru;
      let
        boolToInt = x: if x then 1 else 0;
        enabled = boolToInt enable;
        leaf = 2 * (boolToInt leafPageTables);
        nonLeaf = 4 * (boolToInt nonLeafPageTables);
      in
      [
        "CONFIG_LRU_GEN=y"
        "CONFIG_LRU_GEN_ENABLED=${builtins.toString (enabled + leaf + nonLeaf)}"
      ];
  };
}
