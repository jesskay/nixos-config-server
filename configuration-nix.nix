{ config, pkgs, lib, inputs, ... }:
{
  # configure NIX_PATH entries
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  nixpkgs.overlays = [
    (final: prev: {
      nginxStable = prev.nginxStable.override { openssl = prev.openssl; };
    })
  ];

  # set up various useful registry entries
  nix.registry = {
    # `nixpkgs` is set to the same nixpkgs flake used to build this configuration
    nixpkgs.flake = inputs.nixpkgs;

    # `nixpkgs-unstable` is set to this flake's nixos-unstable input
    nixpkgs-unstable.flake = inputs.nixpkgs-unstable;

    # `templates` is set to the same as the global registry, so `nix flake init` can work
    templates.to = { type = "github"; owner = "NixOS"; repo = "templates"; };

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
    dummyRegistry = pkgs.writeText "dummy-registry.json"
    ''
      {
        "version": 2,
        "flakes": []
      }
    '';
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
