{
  hostname ? abort "Hostname must be provided.",
  inject-self-source ? null,
  ...
}:

let

  hosts = import ./hosts;

  host = hosts.${hostname} or (abort "Host ${hostname} not defined in ${./hosts}.");

  extraSource = if inject-self-source == null then {} else { self = builtins.fromJSON inject-self-source; };

  nixos = host.nixpkgs.nixos [
    host.config
    { config._module.args.sources = (import ./sources.nix) // extraSource; }
  ];

in nixos.config.system.build.toplevel

