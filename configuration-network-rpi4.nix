{ config, pkgs, pkgs-unstable, lib, ... }:
{
  # build kernel module for USB wifi adapter
  boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8821au ];

  networking.hostName = "rpi4";
  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlp1s0u1u3" ];
  networking.wireless.networks = {
    "TP-LINK_7C8B_5G" = {
      pskRaw = "ext:PSK_RAW_5G";
      priority = 10;
    };
    "TP-LINK_7C8B" = {
      pskRaw = "ext:PSK_RAW";
      priority = 1;
    };
  };
  networking.wireless.secretsFile = config.age.secrets.wireless.path;

  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  # enable mosh - this will both add the package to the
  # environment and carve out the appropriate allowed
  # ports range for mosh
  programs.mosh.enable = true;

  ## tailscale
  services.tailscale.enable = true;
  services.tailscale.package = pkgs-unstable.tailscale;  # 21.11 has quite an old version
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
