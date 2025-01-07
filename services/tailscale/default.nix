{ config, pkgs-unstable, ... }:

{

  services.tailscale = {

    enable = true;

    # stable nixpkgs tends to be somewhat out of date, as tailscale updates frequently
    package = pkgs-unstable.tailscale;

  };

  # add tailscale to PATH, using the same package as the service
  environment.systemPackages = [ config.services.tailscale.package ];

  networking.firewall = {

    # let traffic over tailscale's interface bypass firewall rules
    trustedInterfaces = [ "tailscale0" ];

    # allow UDP traffic in for tailscale
    allowedUDPPorts = [ config.services.tailscale.port ];

  };

  # forwarding must be set up to allow this machine to work as a subnet router in tailscale
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  # relax reverse path checks to not break exit node functionality
  networking.firewall.checkReversePath = "loose";

}
