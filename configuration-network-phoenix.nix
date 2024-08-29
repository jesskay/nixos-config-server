{ config, pkgs, pkgs-unstable, lib, ... }:
{
  networking.hostName = "phoenix";
  networking.useDHCP = true;

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  networking.interfaces.ens3.ipv6.addresses = [
    {
      address = "2a01:4f9:c011:ba17::1";
      prefixLength = 64;
    }
  ];

  networking.defaultGateway6 = {
    address = "fe80::1";
    interface = "ens3";
  };

  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # enable mosh - this will both add the package to the
  # environment and carve out the appropriate allowed
  # ports range for mosh
  programs.mosh.enable = true;

  ## tailscale
  services.tailscale.enable = true;
  services.tailscale.package = pkgs-unstable.tailscale;  # stable tends to be quite behind
  environment.systemPackages = [ config.services.tailscale.package ];
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
  # to allow this machine to work as a subnet router
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;
  # relax reverse path checks to not break exit node
  networking.firewall.checkReversePath = "loose";
}
