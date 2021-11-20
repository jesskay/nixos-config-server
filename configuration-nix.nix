{ config, pkgs, lib, ... }:
{
  # configure NIX_PATH entries
  nix.nixPath = [
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "/nix/var/nix/profiles/per-user/root/channels"
    # below this point is non-default, can be bootstrapped with -I if used in nixos-rebuild
    "nixos-config=https://github.com/jesskay/nixos-config-rpi4/archive/main.tar.gz"
    "agenix=https://github.com/ryantm/agenix/archive/master.tar.gz"
  ];

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
