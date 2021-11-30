{ config, pkgs, lib, ... }:
{
  # configure NIX_PATH entries
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  # explicitly opt into nix 2.4, since nixos 21.11
  # will stick with 2.3.x for now
  nix.package = pkgs.nix_2_4;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # automatic garbage collection
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
    dates = "weekly";
  };
}
