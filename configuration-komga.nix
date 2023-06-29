{ config, pkgs, lib, ... }:
{
  services.komga.enable = true;
  services.komga.port = 7394;

  services.nginx.simpleVhosts."komga.psquid.net" = {
    vhostType = "proxy";
    port = config.services.komga.port;
  };
}

