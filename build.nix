{
  hostname ? abort "Hostname must be provided.",
  inject-self-source ? null,
  ...
}:

let

  hosts = import ./hosts;

  host = hosts.${hostname} or (abort "Host ${hostname} not defined in ${./hosts}.");

  extraSource = if inject-self-source == null then {} else { self = builtins.fromJSON inject-self-source; };

  sources = import ./sources.nix // extraSource;

  pkgs = import host.nixpkgs {
    inherit (host) system;
    overlays = map import (host.overlays or []);
  };

in pkgs.nixos [
  host.config
  { config._module.args.sources = sources; }
]

