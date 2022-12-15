{ config, pkgs, lib, ... }:
{
  imports = [ ./mod-simple-nginx.nix ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "letsencrypt@psquid.net";

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    # default catch-all sites
    virtualHosts."_" = {
      addSSL = true;
      sslCertificateKey = "/var/www/snakeoil-2021.key";
      sslCertificate = "/var/www/snakeoil-2021.crt";
      default = true;
      locations."/" = {
        root = "/var/www/html";
        index = "nonexistent.html";
      };
    };
    
    # terse SSL+ACME-by-default sites, as defined in mod-simple-nginx
    simpleVhosts = {
      "dl.psquid.net" = {
        vhostType = "static";
        webroot = "/var/www/dl.psquid.net/html";
      };
      "dl-public.psquid.net" = {
        vhostType = "index";
        webroot = "/var/www/dl-public.psquid.net/html";
      };
      "gaydog.mom" = {
        vhostType = "static";
        webroot = "/var/www/www.gaydog.mom/html";
        aliases = [ "www.gaydog.mom" ];
      };
      "msjessi.ca" = {
        vhostType = "static";
        webroot = "/var/www/www.msjessi.ca/html";
        aliases = [ "www.msjessi.ca" ];
      };
      "psquid.net" = {
        vhostType = "static";
        webroot = "/var/www/www.psquid.net/html";
        aliases = [ "www.psquid.net" ];
      };
    };
  };
}
