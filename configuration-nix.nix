{ config, pkgs, lib, ... }:
{
  # configure NIX_PATH entries
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
    # below this point is non-default, can be bootstrapped with -I if used in nixos-rebuild
    "agenix=https://github.com/ryantm/agenix/archive/master.tar.gz"
  ];

  # automatic garbage collection
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
    dates = "weekly";
  };
}
