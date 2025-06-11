rec {
  x32 = import ./x32.nix;
  mg-lru = import ./mg-lru.nix;
  sway = import ./sway.nix;
  imported = [
    x32
    mg-lru
    sway
  ];
}
