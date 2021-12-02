{ config, pkgs, lib, inputs, ... }:
{
  # configure NIX_PATH entries
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  # set up various useful registry entries
  nix.registry = {
    # `nixpkgs` is set to the same nixpkgs flake used to build this configuration
    nixpkgs.flake = inputs.nixpkgs;

    # `nixpkgs-unstable` is set to the current nixos-unstable
    nixpkgs-unstable.to = { type = "github"; owner = "NixOS"; repo = "nixpkgs"; ref = "nixos-unstable"; };

    # `active-config` is set to the flake the current system was built from
    active-config.flake = inputs.self;
  };

  # explicitly opt into nix 2.4, since nixos 21.11
  # will stick with 2.3.x for now
  # additionally, point global repository to a
  # dummy file
  nix.package = pkgs.nix_2_4;
  nix.extraOptions = 
  let
    dummyRegistry = pkgs.writeText
      "dummy-registry.json" "{}";
  in ''
    experimental-features = nix-command flakes
    flake-registry = ${dummyRegistry}
  '';

  # automatic garbage collection
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
    dates = "weekly";
  };
}
