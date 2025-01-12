let

  sources = import ../sources.nix;

in

{

  rpi4 = rec {
    system = "aarch64-linux";
    config = ./rpi4/default.nix;
    nixpkgs = import sources.nixpkgs-unstable { inherit system; };
  };

}
