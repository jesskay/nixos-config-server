{ config, pkgs, lib, ... }:
{
  networking.hostName = "rpi4";
  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlan0" ];
  networking.wireless.networks = {
    "TP-LINK_7C8B".pskRaw = "@PSK_RAW@";
  };
  networking.wireless.environmentFile = config.age.secrets.wireless.path;

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
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
  environment.systemPackages = [ pkgs.tailscale ];
  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
  # to allow this machine to work as a subnet router
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
}
