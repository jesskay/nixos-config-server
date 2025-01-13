{ pkgs, sources, ... }:

{

  # Enable flakes explicitly - this is implicit in a flake-based config.
  nix.settings.experimental-features = "nix-command flakes";

  # Set the NIX_PATH to point <nixpkgs> to the flake set up in the registry below.
  nix.nixPath = ["nixpkgs=flake:nixpkgs"];

  # set up various useful flake registry entries
  nix.registry = {
    # `nixpkgs` is set to the nixpkgs source used to build this configuration
    nixpkgs.to = { type = "path"; path = sources.nixpkgs-unstable.outPath; };

    # `templates` is set to the same as the global registry, so `nix flake init` can work
    templates.to = { type = "github"; owner = "NixOS"; repo = "templates"; };
  };

  # point global repository to a dummy file
  nix.extraOptions = 
  let
    dummyRegistry = pkgs.writeText "dummy-registry.json"
    ''
      {
        "version": 2,
        "flakes": []
      }
    '';
  in ''
    flake-registry = ${dummyRegistry}
  '';

  # automatic garbage collection
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
    dates = "weekly";
  };

  # trust root (and @wheel, as users in @wheel could become root to bypass trust anyway,
  # so excluding them is reduced convenience for no benefit)
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

}

