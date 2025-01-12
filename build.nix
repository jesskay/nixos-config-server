{ hostname ? abort "Hostname must be provided." }:

let

  hosts = import ./hosts;

  host = hosts.${hostname} or (abort "Host ${hostname} not defined in ${./hosts}.");

  nixos = host.nixpkgs.nixos host.config;

in nixos.config.system.build.toplevel

